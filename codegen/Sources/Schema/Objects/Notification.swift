private let userIDs = StructDef("UserIDs") {
	FieldDef("count", type: .int)
		.required()
		.doc("How many users there are total.")

	FieldDef("items", type: .array(.def(userID)))
		.required()
		.doc("Identifiers of the most recent 10 users.")
}

let notification = StructDef("Notification") {
	FieldDef("id", type: .def(notificationID))
		.required()
		.id()
		.doc("""
			Identifier of this notification.
			The newer the notification, the greater the identifier.
			""")

	userIDs

	let wallPostVariant = TaggedUnionVariantDef(
		"wall_post",
		payloadFieldName: "wall_post_id",
		type: .def(wallPostID),
	)
	let wallCommentVariant = TaggedUnionVariantDef(
		"wall_comment",
		payloadFieldName: "wall_comment_id",
		type: .def(wallPostID),
	)
	let photoCommentVariant = TaggedUnionVariantDef(
		"photo_comment",
		payloadFieldName: "photo_comment_id",
		type: .def(photoCommentID),
	)
	let boardCommentVariant = TaggedUnionVariantDef(
		"board_comment",
		payloadFieldName: "board_comment_id",
		type: .def(topicCommentID),
	)
	let photoVariant = TaggedUnionVariantDef(
		"photo",
		payloadFieldName: "photo_id",
		type: .def(photoID),
	)

	let boardTopicVariant = TaggedUnionVariantDef(
		"board_topic",
		payloadFieldName: "board_topic_id",
		type: .def(boardTopicID),
	)

	let commentFeedbackDef = TaggedUnionDef("CommentFeedback") {
		wallCommentVariant
		photoCommentVariant
		boardCommentVariant
	}
	.doc("The new comment that this notification is about.")
	commentFeedbackDef

	let mentionFeedbackDef = TaggedUnionDef("MentionFeedback") {
		wallPostVariant
		wallCommentVariant
		photoCommentVariant
		boardCommentVariant
	}
	.doc("The new post or comment that this notification is about.")
	mentionFeedbackDef

	let wallPostFeedbackDef = TaggedUnionDef("WallPostFeedback") {
		wallPostVariant
	}
	.doc("The new post that this notification is about.")
	wallPostFeedbackDef

	let commentObjectDef = TaggedUnionDef("CommentObject") {
		wallPostVariant
		boardCommentVariant
		photoVariant
	}
	.doc("The current user's object that on which someone commented.")

	commentObjectDef

	let replyObjectDef = TaggedUnionDef("ReplyObject") {
		wallCommentVariant
		photoCommentVariant
		boardCommentVariant
	}
	.doc("The current user's comment to which someone replied.")
	replyObjectDef

	let likeObjectDef = TaggedUnionDef("LikeObject") {
		wallPostVariant
		wallCommentVariant
		photoCommentVariant
		boardCommentVariant
		photoVariant
	}
	.doc("The current user's object that someone liked.")
	likeObjectDef

	let repostObjectDef = TaggedUnionDef("RepostObject") {
		wallPostVariant
		wallCommentVariant
	}
	.doc("The current user's wall post or comment that someone reposted.")
	repostObjectDef

	let parentDef = TaggedUnionDef("Parent") {
		wallPostVariant
		photoVariant
		boardTopicVariant
	}
	parentDef

	let payloadDef = TaggedUnionDef("Payload") {
		TaggedUnionVariantDef("comment") {
			userIDField()
			feedbackField(commentFeedbackDef)
			objectField(commentObjectDef)
		}
		.doc("""
			Someone commented on a piece of content created by
			the current user.
			""")
		TaggedUnionVariantDef("reply") {
			userIDField()
			feedbackField(commentFeedbackDef)
			objectField(replyObjectDef)
		}
		.doc("Someone replied to a current user's comment.")
		TaggedUnionVariantDef("mention") {
			userIDField()
			feedbackField(mentionFeedbackDef)
		}
		.doc("Someone mentioned the current user.")
		TaggedUnionVariantDef("repost") {
			// Groupable
			userIDsField()
			objectField(repostObjectDef)
		}
		.doc("Someone reposted a current user's post or comment.")
		TaggedUnionVariantDef("like") {
			// Groupable
			userIDsField()
			objectField(likeObjectDef)
		}
		.doc("""
			Someone liked a piece of content created by
			the current user.
			""")
		TaggedUnionVariantDef("wall_post") {
			userIDField()
			feedbackField(wallPostFeedbackDef)
		}
		.doc("Someone posted on the current user's wall.")
		TaggedUnionVariantDef("invite_signup") {
			// Groupable
			userIDsField()
		}
		.doc("""
			Someone signed up using an invitation from
			the current user.
			""")
		TaggedUnionVariantDef("follow") {
			// Groupable
			userIDsField()
		}
		.doc("Someone started following the current user.")
		TaggedUnionVariantDef("friend_accept") {
			// Groupable
			userIDsField()
		}
		.doc("Someone accepted a current user's friend request.")
	}
	FieldDef("payload", type: .def(payloadDef))
		.required()
		.flatten()
	payloadDef

	FieldDef("parent", type: .def(parentDef))
		.doc("""
			For like and repost of a comment, and for reply:
			the parent object for the entire comment thread.
			""")

	FieldDef("date", type: .unixTimestamp)
		.required()
		.doc("The time  when this notification was created.")
}

private func userIDField() -> FieldDef {
	FieldDef("user_id", type: .def(userID))
		.required()
		.doc("The identifier of the user that did the action.")
}

private func userIDsField() -> FieldDef {
	FieldDef("user_ids", type: .def(userIDs))
		.required()
		.doc("Information about users that did the action.")
}

private func feedbackField(_ type: TaggedUnionDef) -> FieldDef {
	FieldDef("feedback", type: .def(type))
		.required()
}

private func objectField(_ type: TaggedUnionDef) -> FieldDef {
	FieldDef("object", type: .def(type))
		.required()
}
