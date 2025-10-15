import SwiftSyntax

struct EnumDef: Documentable {
	var name: String
	var doc: String?
	var cases: [EnumCaseDef]
	var isFrozen: Bool = false

	init(_ name: String, @EnumDefBuilder build: () -> any EnumDefPart) {
		self.name = name
		self.cases = build().components
	}

	func frozen() -> EnumDef {
		copyWith(self, \.isFrozen, true)
	}
}

@resultBuilder
struct EnumDefBuilder {
	static func buildExpression(_ expression: any EnumDefPart) -> any EnumDefPart {
		return expression
	}

	static func buildBlock(_ components: any EnumDefPart...) -> any EnumDefPart {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}

	static func buildArray(_ components: [any EnumDefPart]) -> any EnumDefPart {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}
}

protocol EnumDefPart: Sendable {
	var components: [EnumCaseDef] { get }
}

extension EnumDef: StructDefPart {
    func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
        visitor.printEnum(self)
    }
}

private struct CompositeEnumDefPart: EnumDefPart {
	var components: [EnumCaseDef]
}
