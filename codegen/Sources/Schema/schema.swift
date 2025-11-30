let schema = Group {
	FileDef("Identifiers") {
		userID
		groupID
		actorID
		friendListID
		photoID
		serverRuleID
		groupLinkID
		pollID
		pollOptionID
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
	FileDef("Poll") {
		poll
	}
	FileDef("Graffiti") {
		graffiti
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
