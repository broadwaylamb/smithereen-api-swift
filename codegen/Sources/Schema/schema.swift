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
		photoCommentID
		topicCommentID
	}
	Group("Objects") {
		attachment
		audio
		boardTopic
		deactivatedStatus
		friendList
		graffiti
		group
		likeInfo
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
		groups
		likes
	}

	communityType
	actorField
	error
}
