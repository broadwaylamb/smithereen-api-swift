import SwiftSyntax

struct TaggedUnionDef: Documentable {
	var name: String
	var doc: String?
	var decls: [any TaggedUnionDefPart]
	var conformances: [TypeRef]
	var isFrozen: Bool = false
	var tagSerialName: String? = "type"

	static let defaultConformances: [TypeRef] = [
		.hashable,
		.codable,
		.sendable,
	]

	init(
		_ name: String,
		conformances: [TypeRef] = Self.defaultConformances,
		@TaggedUnionDefBuilder build: () -> any TaggedUnionDefPart,
	) {
		self.name = name
		self.conformances = conformances
		self.decls = build().taggedUnionComponents
	}

	var variants: [TaggedUnionVariantDef] {
		decls.compactMap { $0 as? TaggedUnionVariantDef }
	}

	func frozen() -> TaggedUnionDef {
		copyWith(self, \.isFrozen, true)
	}

	func tag(_ name: String?) -> TaggedUnionDef {
		copyWith(self, \.tagSerialName, name)
	}
}

@resultBuilder
struct TaggedUnionDefBuilder {
	static func buildExpression(_ expression: any TaggedUnionDefPart) -> any TaggedUnionDefPart {
		return expression
	}

	static func buildBlock(_ components: any TaggedUnionDefPart...) -> any TaggedUnionDefPart {
		return CompositeTaggedUnionDefPart(taggedUnionComponents: components.flatMap { $0.taggedUnionComponents })
	}

	static func buildArray(_ components: [any TaggedUnionDefPart]) -> any TaggedUnionDefPart {
		return CompositeTaggedUnionDefPart(taggedUnionComponents: components.flatMap { $0.taggedUnionComponents })
	}
}

protocol TaggedUnionDefPart: Sendable {
	var taggedUnionComponents: [any TaggedUnionDefPart] { get }
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol
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
	var taggedUnionComponents: [any TaggedUnionDefPart]
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		fatalError("Not applicable")
	}
}

struct TaggedUnionVariantDef: Documentable, HasSerialName {
	var serialName: String
	var customPayloadFieldName: String?
	var customSwiftName: String?
	var doc: String?
	var type: TypeRef
	var isFlattened = false

	var payloadFieldName: String {
		customPayloadFieldName ?? serialName
	}

	init(_ serialName: String, payloadFieldName: String? = nil, type: TypeRef) {
		self.serialName = serialName
		self.customPayloadFieldName = payloadFieldName
		self.type = type
	}

	func flatten() -> TaggedUnionVariantDef {
		copyWith(self, \.isFlattened, true)
	}
}

extension TaggedUnionVariantDef: TaggedUnionDefPart {
	var taggedUnionComponents: [any TaggedUnionDefPart] {
		[self]
	}
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printTaggedUnionVariant(self)
	}
}

extension StructDef: TaggedUnionDefPart {
	var taggedUnionComponents: [any TaggedUnionDefPart] {
		[self]
	}
}
