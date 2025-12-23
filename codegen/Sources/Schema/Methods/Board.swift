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
}
