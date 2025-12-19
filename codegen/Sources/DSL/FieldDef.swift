import SwiftSyntax

struct FieldDef: Documentable, HasSerialName {
	var serialName: String
	var customSwiftName: String?
	var type: TypeRef
	var doc: String?
	var isIdentifier: Bool = false
	var propertyWrappers: [String] = []
	var isExcludedFromFields: Bool = false
	var isFlattened: Bool = false
	var constantValue: String? = nil

	init(_ serialName: String, type: TypeRef) {
		self.serialName = serialName
		self.type = type.optional()
		if type.optional(false) == .unixTimestamp {
			propertyWrappers.append("UnixTimestamp")
		}
	}

	func required(_ required: Bool = true) -> FieldDef {
		copyWith(self, \.type, type.optional(!required))
	}

	func id() -> FieldDef {
		copyWith(self, \.isIdentifier, true)
	}

	func excludeFromFields() -> FieldDef {
		copyWith(self, \.isExcludedFromFields, true)
	}

	func flatten() -> FieldDef {
		copyWith(self, \.isFlattened, true)
	}

	func json() -> FieldDef {
		var r = self
		r.propertyWrappers.append("EncodeAsJSONString")
		return r
	}

	func constantValue(_ value: String) -> FieldDef {
		copyWith(self, \.constantValue, value)
	}
}

@resultBuilder
struct FieldContainerBuilder {
	static func buildExpression(_ expression: any FieldContainerPart) -> any FieldContainerPart {
		return expression
	}

	static func buildBlock(_ components: any FieldContainerPart...) -> any FieldContainerPart {
		return CompositeFieldContainerPart(fields: components.flatMap { $0.fields })
	}

	static func buildArray(_ components: [any FieldContainerPart]) -> any FieldContainerPart {
		return CompositeFieldContainerPart(fields: components.flatMap { $0.fields })
	}
}

protocol FieldContainerPart: StructDefPart, ProtocolDefPart {
	var fields: [FieldDef] { get }
}

extension FieldContainerPart {
	var structComponents: [any StructDefPart] {
		return fields
	}

	var protocolComponents: [any ProtocolDefPart] {
		return fields
	}
}

extension FieldDef: FieldContainerPart {
	var fields: [FieldDef] {
		return [self]
 	}
}

private struct CompositeFieldContainerPart: FieldContainerPart {
	var fields: [FieldDef]
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		fatalError("Not applicable")
	}
}

extension FieldDef: StructDefPart, ProtocolDefPart {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printField(self)
	}
}
