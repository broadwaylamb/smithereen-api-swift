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
	Group("Objects") {
		attachment
		audio
		deactivatedStatus
		graffiti
		group
		likes
		photo
		platform
		poll
		serverRule
		serverSignupMode
		user
		video
	}
}
