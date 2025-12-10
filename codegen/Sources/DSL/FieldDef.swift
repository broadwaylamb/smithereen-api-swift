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
}

extension FieldDef: StructDefPart {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printField(self)
	}
}
