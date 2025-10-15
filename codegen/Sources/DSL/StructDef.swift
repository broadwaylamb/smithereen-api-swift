import SwiftSyntax

struct StructDef: Documentable {
	var name: String
	var doc: String?
	var decls: [any StructDefPart]
	var conformances: [TypeRef]

	static let defaultConformances: [TypeRef] = [
		.hashable,
		.codable,
		.sendable,
	]
	
	init(_ name: String, conformances: [TypeRef] = defaultConformances, @StructDefBuilder build: () -> any StructDefPart) {
		self.name = name
		self.decls = build().components
		self.conformances = conformances
	}

	var fields: [FieldDef] {
		decls.compactMap { $0 as? FieldDef }
	}

	func generateFieldsStruct() -> StructDef {
		let fieldsEnum = EnumDef("Field") {
			for field in fields where !field.isExcludedFromFields && field.type.isOptional {
				EnumCaseDef(field.serialName)
					.swiftName(field.customSwiftName)
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
		return CompositeStructDefPart(components: components.flatMap { $0.components })
	}

	static func buildArray(_ components: [any StructDefPart]) -> any StructDefPart {
		return CompositeStructDefPart(components: components.flatMap { $0.components })
	}
}

protocol StructDefPart: Sendable {
	var components: [any StructDefPart] { get }
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol
}

extension StructDefPart {
	var components: [any StructDefPart] { 
		return [self]
	 }
}

private struct CompositeStructDefPart: StructDefPart {
	var components: [any StructDefPart]
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
		FileDef(name + ".swift") { self }
	}
}
