import SwiftSyntax

struct StructDef: Documentable {
	var name: String
	var doc: String?
	var decls: [any StructDefPart]
	var conformances: [TypeRef]
	var typeParameters: [TypeParameterDef]
	var schemaPath: String

	static let defaultConformances: [TypeRef] = [
		.hashable,
		.codable,
		.sendable,
	]

	init(
		_ name: String,
		conformances: [TypeRef] = defaultConformances,
		typeParameters: [TypeParameterDef] = [],
		schemaPath: String = #filePath,
		@StructDefBuilder build: () -> any StructDefPart
	) {
		self.name = name
		self.decls = build().structComponents
		self.conformances = conformances
		self.typeParameters = typeParameters
		self.schemaPath = schemaPath
	}

	var fields: [FieldDef] {
		decls.compactMap { $0 as? FieldDef }
	}

	var requestableFieldCases: [EnumCaseDef<String>] {
		fields
			.filter { !$0.isExcludedFromFields && $0.type.isOptional }
			.map {
				EnumCaseDef($0.serialName)
					.swiftName($0.customSwiftName)
					.doc($0.doc)
			}
	}

	func generateFieldsStruct() -> StructDef {
		let fieldsEnum = EnumDef<String>("Field") {
			for `case` in requestableFieldCases {
				`case`
			}
		}
		return copyWith(self, \.decls, decls + [fieldsEnum])
	}
}

func IdentifierStruct(_ name: String, rawValue: TypeRef) -> StructDef {
	StructDef(name, conformances: [.identifier]) {
		FieldDef("rawValue", type: rawValue).required()
	}
}

@resultBuilder
struct StructDefBuilder {
	static func buildExpression(_ expression: any StructDefPart) -> any StructDefPart {
		return expression
	}

	static func buildBlock(_ components: any StructDefPart...) -> any StructDefPart {
		return CompositeStructDefPart(structComponents: components.flatMap { $0.structComponents })
	}

	static func buildArray(_ components: [any StructDefPart]) -> any StructDefPart {
		return CompositeStructDefPart(structComponents: components.flatMap { $0.structComponents })
	}

	static func buildEither(first component: any StructDefPart) -> any StructDefPart {
		return component
	}

	static func buildEither(second component: any StructDefPart) -> any StructDefPart {
		return component
	}

	static func buildOptional(_ component: (any StructDefPart)?) -> any StructDefPart {
		return component ?? CompositeStructDefPart(structComponents: [])
	}
}

protocol StructDefPart: DeclarationDef {
	var structComponents: [any StructDefPart] { get }
}

extension StructDefPart {
	var structComponents: [any StructDefPart] {
		return [self]
	}
}

private struct CompositeStructDefPart: StructDefPart {
	var structComponents: [any StructDefPart]
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		fatalError("Not applicable")
	}
}

extension StructDef: StructDefPart {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printStruct(self)
	}
}

extension StructDef: GroupPart {
	var file: FileDef? {
		FileDef(name + ".swift", schemaPath: schemaPath) { self }
	}
}
