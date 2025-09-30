let schema = Group {
	FileDef("Identifiers") {
		IdentifierStruct("UserID", rawValue: .int)
		IdentifierStruct("FriendListID", rawValue: .int)
		IdentifierStruct("PhotoID", rawValue: .string)
	}
	FileDef("Misc") {
		EnumDef("Platform") {
			EnumCaseDef("mobile", additionalRepresentation: 1)
			EnumCaseDef("desktop", additionalRepresentation: 7)
		}
	}
	Group("User") {
		Group("Objects") {
			user
		}
	}
}
