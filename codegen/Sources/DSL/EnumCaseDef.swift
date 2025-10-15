struct EnumCaseDef: Documentable, HasSerialName {
	var serialName: String
	var customSwiftName: String?
	var doc: String?
	var additionalRepresentation: Int?

	init(_ serialName: String, additionalRepresentation: Int? = nil) {
		self.serialName = serialName
		self.additionalRepresentation = additionalRepresentation
	}
}

extension EnumCaseDef: EnumDefPart {
	var components: [EnumCaseDef] {
		[self]
	}
}
