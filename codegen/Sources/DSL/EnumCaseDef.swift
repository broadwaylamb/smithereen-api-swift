struct EnumCaseDef<RawValue: Sendable>: Documentable {
	var rawValue: RawValue
	var swiftName: String
	var doc: String?
	var additionalRepresentation: Int?

	init(_ rawValue: RawValue, swiftName: String) {
		self.rawValue = rawValue
		self.swiftName = swiftName
	}
}

extension EnumCaseDef<String>: HasSerialName {
	var serialName: String {
		rawValue
	}

	var customSwiftName: String? {
		get {
			swiftName
		}
		set {
			swiftName = newValue ?? rawValue.convertFromSnakeCase()
		}
	}

	init(_ rawValue: String, additionalRepresentation: Int? = nil) {
		self.rawValue = rawValue
		self.swiftName = rawValue.convertFromSnakeCase()
		self.additionalRepresentation = additionalRepresentation
	}
}

extension EnumCaseDef: EnumDefPart {
	var components: [EnumCaseDef] {
		[self]
	}
}

extension EnumCaseDef<String>: StringEnumDefPart {}
extension EnumCaseDef<Int>: IntEnumDefPart {}
