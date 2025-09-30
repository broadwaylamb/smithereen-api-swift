import SwiftSyntax

struct EnumDef: Documentable {
	var name: String
	var doc: String?
	var cases: [EnumCaseDef]
	var isFrozen: Bool = false

	init(_ name: String, @EnumDefBuilder build: () -> [EnumCaseDef]) {
		self.name = name
		self.cases = build()
	}

	func frozen() -> EnumDef {
		copyWith(self, \.isFrozen, true)
	}
}

@resultBuilder
struct EnumDefBuilder {
	static func buildBlock(_ components: EnumCaseDef...) -> [EnumCaseDef] {
		return components
	}
}

extension EnumDef: StructDefPart {
    func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
        visitor.printEnum(self)
    }
}
