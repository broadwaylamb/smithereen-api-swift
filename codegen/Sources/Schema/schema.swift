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
		commentID
		photoFeedEntryID
		photoTagID
	}
	Group("Objects") {
		attachment
		audio
		boardTopic
		comment
		deactivatedStatus
		friendList
		graffiti
		group
		likeInfo
		likeableObject
		photo
		photoFeedUpdate
		platform
		poll
		privacySetting
		serverSignupMode
		user
		video
		wallPost
	}

	Group("Methods") {
		friends
		groups
		likes
		newsfeed
		photos
		server
	}

	communityType
	actorField
	commentView
	error
}
