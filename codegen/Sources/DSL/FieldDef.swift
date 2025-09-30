import SwiftSyntax

struct FieldDef: Documentable, HasSerialName {
	var serialName: String
	var customSwiftName: String?
	var type: TypeRef
	var doc: String?
	var isIdentifier: Bool = false
	var propertyWrappers: [String] = []
	var alternativeSerialNames: [String] = []

	init(_ serialName: String, type: TypeRef) {
		self.serialName = serialName
		self.type = type.optional()
		if type.optional(false) == .bool {
			propertyWrappers.append("LenientBool")
		}
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

	func alternativeNames(_ names: String...) -> FieldDef {
		copyWith(self, \.alternativeSerialNames, names)
	}
}

extension FieldDef: StructDefPart {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printField(self)
	}
}
