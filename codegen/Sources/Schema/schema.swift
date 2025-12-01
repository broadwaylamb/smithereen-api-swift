let schema = Group {
	FileDef("Identifiers") {
		userID
		groupID
		actorID
		friendListID
		photoID
		albumID
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
		likes
	}
	photo
	poll
	graffiti
	video
	audio
	attachment
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
