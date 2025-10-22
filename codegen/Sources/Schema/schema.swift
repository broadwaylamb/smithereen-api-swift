let schema = Group {
	FileDef("Identifiers") {
		IdentifierStruct("UserID", rawValue: .int)
		IdentifierStruct("FriendListID", rawValue: .int)
		IdentifierStruct("PhotoID", rawValue: .string)
		IdentifierStruct("ServerRuleID", rawValue: .int)
	}
	FileDef("Misc") {
		EnumDef("Platform") {
			EnumCaseDef("mobile", additionalRepresentation: 1)
			EnumCaseDef("desktop", additionalRepresentation: 7)
		}
		serverRule
		serverSignupMode
	}
	Group("User") {
		Group("Objects") {
			user
		}
	}
	Group("Server") {
		Group("Objects") {
			serverInfo
		}
	}
}
