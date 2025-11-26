let schema = Group {
	FileDef("Identifiers") {
		userID
		groupID
		friendListID
		photoID
		serverRuleID
		groupLinkID
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
	Group("Groups") {
		Group("Objects") {
			group
		}
	}
	Group("Server") {
		Group("Objects") {
			serverInfo
		}
	}
}
