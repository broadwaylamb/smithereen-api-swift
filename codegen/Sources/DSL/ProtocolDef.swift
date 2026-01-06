import SwiftSyntax

struct ProtocolDef: Documentable {
	var name: String
	var doc: String?
	var decls: [any ProtocolDefPart]
	var conformances: [TypeRef]
	var schemaPath: String

	init(
		_ name: String,
		conformances: [TypeRef] = [],
		schemaPath: String = #filePath,
		@ProtocolDefBuilder build: () -> any ProtocolDefPart
	) {
		self.name = name
		self.schemaPath = schemaPath
		self.decls = build().protocolComponents
		self.conformances = conformances
	}
}

@resultBuilder
struct ProtocolDefBuilder {
	static func buildExpression(_ expression: any ProtocolDefPart) -> any ProtocolDefPart {
		return expression
	}

	static func buildBlock(_ components: any ProtocolDefPart...) -> any ProtocolDefPart {
		return CompositeProtocolDefPart(protocolComponents: components.flatMap { $0.protocolComponents })
	}

	static func buildArray(_ components: [any ProtocolDefPart]) -> any ProtocolDefPart {
		return CompositeProtocolDefPart(protocolComponents: components.flatMap { $0.protocolComponents })
	}
}

protocol ProtocolDefPart: DeclarationDef {
	var protocolComponents: [any ProtocolDefPart] { get }
}

extension ProtocolDefPart {
	var protocolComponents: [any ProtocolDefPart] {
		return [self]
	}
}

private struct CompositeProtocolDefPart: ProtocolDefPart {
	var protocolComponents: [any ProtocolDefPart]
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		fatalError("Not applicable")
	}
}

extension ProtocolDef: DeclarationDef {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printProtocol(self)
	}
}

extension ProtocolDef: GroupPart {
	var file: FileDef? {
		FileDef(name + ".swift", schemaPath: schemaPath) { self }
	}
}
