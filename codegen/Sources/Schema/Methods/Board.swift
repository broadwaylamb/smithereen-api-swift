let board = Group("Board") {
	RequestDef("board.closeTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Closes a topic so that no more comments could be posted.")
	.requiresPermissions("groups")

	RequestDef("board.createComment", resultType: .def(topicCommentID)) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("Identifier of the topic on which to comment.")
		commentCreationParameters(method: "Board/CreateComment", replyToID: topicCommentID)
	}
	.doc("Creates a new comment in a topic.")
	.requiresPermissions("groups")

	RequestDef("board.createTopic", resultType: .def(boardTopicID)) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Identifier of the group where to create the topic.")
		FieldDef("title", type: .string)
			.required()
			.doc("The title of the topic.")
		postParameters(postKind: "comment")
		guidField(method: "Board/CreateTopic")
	}
	.doc("Creates a new topic in a group.")
	.requiresPermissions("groups")

	RequestDef("board.deleteComment", resultType: .void) {
		FieldDef("comment_id", type: .def(topicCommentID))
			.required()
			.doc("Identifier of the comment to delete.")
	}
	.doc("Deletes a comment in a topic.")
	.requiresPermissions("groups")

	RequestDef("board.deleteTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Deletes a topic.")
	.requiresPermissions("groups")

	RequestDef("board.editComment", resultType: .def(topicCommentID)) {
		FieldDef("comment_id", type: .def(topicCommentID))
			.required()
			.doc("The identifier of the comment to be updated.")
		postParameters(postKind: "comment")
	}
	.doc("Edits a comment in a topic.")
	.requiresPermissions("groups")

	RequestDef("board.editTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
		FieldDef("title", type: .string)
			.required()
			.doc("The new title.")
	}
	.doc("Edits the title of a topic.")
	.requiresPermissions("groups")
}
