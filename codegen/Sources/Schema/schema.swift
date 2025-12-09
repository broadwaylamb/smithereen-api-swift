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
		photoFeedEntryID
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
		photoFeedUpdate
		platform
		poll
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
