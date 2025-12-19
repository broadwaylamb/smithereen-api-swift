let schema = Group {
	FileDef("Identifiers") {
		userID
		groupID
		actorID
		friendListID
		photoID
		photoAlbumID
		serverRuleID
		groupLinkID
		pollID
		pollOptionID
		boardTopicID
		wallPostID
		commentID
		photoFeedEntryID
		photoTagID
		uploadedAttachmentID
		uploadedAttachmentHash
	}
	Group("Objects") {
		attachment
		attachmentToCreate
		audio
		boardTopic
		comment
		cropPhoto
		deactivatedStatus
		friendList
		graffiti
		group
		likeInfo
		likeableObject
		photo
		photoAlbum
		imageRect
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
	textFormat
	commentSortOrder
	error
}
