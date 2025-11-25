let schema = Group {
	FileDef("Identifiers") {
		userID
		friendListID
		photoID
		serverRuleID
	}
	FileDef("Misc") {
		EnumDef("Platform") {
			EnumCaseDef("mobile", additionalRepresentation: 1)
			EnumCaseDef("desktop", additionalRepresentation: 7)
		}
		serverRule
		serverSignupMode
		deactivatedStatus
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
