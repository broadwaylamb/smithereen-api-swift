import SwiftSyntax

struct EnumDef<RawValue: Sendable>: Documentable {
	var name: String
	var doc: String?
	var cases: [EnumCaseDef<RawValue>]
	var isFrozen: Bool = true
	var schemaPath: String

	init(
		_ name: String,
		schemaPath: String = #filePath,
		@EnumDefBuilder<RawValue> build: () -> CompositeEnumDefPart<RawValue>
	) {
		self.name = name
		self.schemaPath = schemaPath
		self.cases = build().components
	}

	func nonexhaustive() -> EnumDef {
		copyWith(self, \.isFrozen, false)
	}
}

@resultBuilder
struct EnumDefBuilder<RawValue: Sendable> {
	static func buildExpression<T : EnumDefPart>(_ expression: T) -> T {
		return expression
	}
}

extension EnumDefBuilder<String> {
	static func buildBlock(_ components: any StringEnumDefPart...) -> CompositeEnumDefPart<String> {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}

	static func buildArray(_ components: [any StringEnumDefPart]) -> CompositeEnumDefPart<String> {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}
}

extension EnumDefBuilder<Int> {
	static func buildBlock(_ components: any IntEnumDefPart...) -> CompositeEnumDefPart<Int> {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}

	static func buildArray(_ components: [any IntEnumDefPart]) -> CompositeEnumDefPart<Int> {
		return CompositeEnumDefPart(components: components.flatMap { $0.components })
	}
}

protocol EnumDefPart<RawValue>: Sendable {
	associatedtype RawValue: Sendable
	var components: [EnumCaseDef<RawValue>] { get }
}

protocol StringEnumDefPart: EnumDefPart<String> {}
protocol IntEnumDefPart: EnumDefPart<Int> {}

extension EnumDef: StructDefPart {
    func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
        visitor.printEnum(self)
    }
}

struct CompositeEnumDefPart<RawValue: Sendable>: EnumDefPart {
	var components: [EnumCaseDef<RawValue>]
}

extension CompositeEnumDefPart<String> : StringEnumDefPart {}
extension CompositeEnumDefPart<Int> : IntEnumDefPart {}

extension EnumDef: GroupPart {
    var file: FileDef? {
        FileDef(name + ".swift", schemaPath: schemaPath) { self }
    }
}
