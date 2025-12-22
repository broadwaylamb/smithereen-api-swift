import SwiftSyntax

struct RequestDef: Documentable {
	var name: String
	var customSwiftName: String?
	var structDef: StructDef
	var resultType: TypeRef?
	var extended: Extended?

	final class Extended: Sendable {
		let newFields: [FieldDef]
		let request: RequestDef

		init(newFields: [FieldDef], request: RequestDef) {
			self.newFields = newFields
			self.request = request
		}
	}

	var doc: String? {
		get {
			structDef.doc
		}
		set {
			structDef.doc = newValue
		}
	}

	static let defaultConformances: [TypeRef] = [
		TypeRef(name: "SmithereenAPIRequest"),
		.hashable,
		.encodable,
		.sendable,
	]

	init(
		_ name: String,
		swiftName: String? = nil,
		resultType: TypeRef? = nil,
		conformances: [TypeRef] = defaultConformances,
		typeParameters: [TypeParameterDef] = [],
		@StructDefBuilder build: () -> any StructDefPart,
	) {
		self.name = name
		self.customSwiftName = swiftName
		self.resultType = resultType
		let swiftName = swiftName ?? name
		structDef = StructDef(
			(swiftName.split(separator: ".").last.map(String.init) ?? swiftName).uppercasedFirstChar,
			conformances: conformances,
			typeParameters: typeParameters,
			build: build,
		)
	}

	func withExtendedVersion(
		_ extendedName: String,
		extendedResultType: TypeRef,
		@StructDefBuilder extendedFields: () -> any StructDefPart,
	) -> Self {
		let newDecls = extendedFields()
		let newFields = newDecls.structComponents.compactMap { $0 as? FieldDef }
		let extendedRequestDef = RequestDef(
			name,
			swiftName: extendedName,
			resultType: extendedResultType,
			conformances: Self.defaultConformances,
		) {
			let extendedFieldNames = Set(newFields.map { $0.swiftName })
			for field in structDef.fields where !extendedFieldNames.contains(field.swiftName)  {
				field
			}
			newDecls
		}
		.doc(doc)

		var copyWithExtended = RequestDef(
			name,
			swiftName: customSwiftName,
			resultType: resultType,
			conformances: structDef.conformances,
		) {
			for decl in structDef.decls {
				decl
			}
			extendedRequestDef
		}
		.doc(doc)

		copyWithExtended.extended = Extended(
			newFields: newFields,
			request: extendedRequestDef,
		)
		return copyWithExtended
	}
}

extension RequestDef: GroupPart {
	var file: FileDef? {
		FileDef(
			name
				.split(separator: ".")
				.map { $0.uppercasedFirstChar }
				.joined(separator: ".") + ".swift",
			additionalImports: ["Hammond"],
		) {
			self
		}
	}
}

extension RequestDef: StructDefPart {
	var structComponents: [any StructDefPart] { [self] }

	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printRequest(self)
	}
}

extension RequestDef {
	func requiresPermissions(_ permission: String) -> Self {
		let note = "- Note: This method requires the following permissions: `\(permission)`."
		if let docText = self.doc {
			return doc(docText + "\n\n" + note)
		} else {
			return doc(note)
		}
	}
}
