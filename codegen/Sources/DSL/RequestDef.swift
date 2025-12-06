import SwiftSyntax

struct RequestDef: Documentable {
	var name: String
	var customSwiftName: String?
	var structDef: StructDef
	var resultType: TypeRef?
	
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
	]

	init(
		_ name: String,
		swiftName: String? = nil,
		resultType: TypeRef? = nil,
		conformances: [TypeRef] = defaultConformances,
		@StructDefBuilder build: () -> any StructDefPart,
	) {
		self.name = name
		self.customSwiftName = swiftName
		self.resultType = resultType
		structDef = StructDef(
			swiftName ?? (name.split(separator: ".").last.map(String.init) ?? name).capitalizedFirstChar,
			conformances: conformances,
			build: build,
		)
	}
}

extension RequestDef: GroupPart {
	var file: FileDef? {
		FileDef(
			name
				.split(separator: ".")
				.map { $0.capitalizedFirstChar }
				.joined(separator: ".") + ".swift",
			additionalImports: ["Hammond"],
		) {
			self
		}
	}
}

extension RequestDef: StructDefPart {
	var components: [any StructDefPart] { [self] }

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
