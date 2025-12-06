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
		boardTopicID
		wallPostID
	}
	Group("Objects") {
		attachment
		audio
		boardTopic
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
		wallPost
	}

	Group("Methods") {
		friends
	}

	error
}
