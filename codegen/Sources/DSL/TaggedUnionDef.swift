import SwiftSyntax

struct TaggedUnionDef: Documentable {
	var name: String
	var doc: String?
	var variants: [TaggedUnionVariantDef]

	init(_ name: String, @TaggedUnionDefBuilder build: () -> any TaggedUnionDefPart) {
		self.name = name
		self.variants = build().components
	}
}

@resultBuilder
struct TaggedUnionDefBuilder {
	static func buildExpression(_ expression: any TaggedUnionDefPart) -> any TaggedUnionDefPart {
		return expression
	}

	static func buildBlock(_ components: any TaggedUnionDefPart...) -> any TaggedUnionDefPart {
		return CompositeTaggedUnionDefPart(components: components.flatMap { $0.components })
	}

	static func buildArray(_ components: [any TaggedUnionDefPart]) -> any TaggedUnionDefPart {
		return CompositeTaggedUnionDefPart(components: components.flatMap { $0.components })
	}
}

protocol TaggedUnionDefPart: Sendable {
	var components: [TaggedUnionVariantDef] { get }
}

extension TaggedUnionDef: StructDefPart {
    func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
        visitor.printTaggedUnion(self)
    }
}

extension TaggedUnionDef: GroupPart {
	var file: FileDef? {
		FileDef(name + ".swift") { self }
	}
}

private struct CompositeTaggedUnionDefPart: TaggedUnionDefPart {
	var components: [TaggedUnionVariantDef]
}

struct TaggedUnionVariantDef: Documentable, HasSerialName {
	var serialName: String
	var customSwiftName: String?
	var doc: String?
	var type: TypeRef

	init(_ serialName: String, type: TypeRef) {
		self.serialName = serialName
		self.type = type
	}
}

extension TaggedUnionVariantDef: TaggedUnionDefPart {
	var components: [TaggedUnionVariantDef] {
		[self]
	}
}
