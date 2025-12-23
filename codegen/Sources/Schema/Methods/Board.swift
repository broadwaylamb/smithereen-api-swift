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

	RequestDef("board.getCommentEditSource", resultType: .def(postEditSource)) {
		FieldDef("comment_id", type: .def(topicCommentID))
			.required()
			.doc("""
				The identifier of the comment for which the source needs to be
				returned.
				""")
	}

	commentsRequest(
		"board.getComments",
		commentID: topicCommentID,
		comment: topicComment,
		targetField: FieldDef("topic_id", type: .def(boardTopicID))
			.doc("The identifier of the topic.")
	)

	RequestDef("board.getTopics", resultType: .paginatedList(.def(boardTopic))) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("The group for which topics need to be returned.")

		let orderDef = EnumDef<String>("Order") {
			EnumCaseDef("updated_desc", swiftName: "updatedDescending")
				.doc("By last post time, newest to oldest.")
			EnumCaseDef("created_desc", swiftName: "createdDescending")
				.doc("By creation time, newest to oldest.")
			EnumCaseDef("updated_asc", swiftName: "updatedAscending")
				.doc("By last post time, oldest to newest.")
			EnumCaseDef("created_asc", swiftName: "createdAscending")
				.doc("By creation time, oldest to newest.")
		}
		.frozen()
		FieldDef("order", type: .def(orderDef))
			.doc("""
				Sort order for the topics. Pinned topics, if any, will always
				be returned first regardless of this parameter.

				By default ``Order/updatedDescending``.
				""")
		orderDef

		offsetAndCountParams("topic", defaultCount: 40)

		let previewModeDef = EnumDef<String>("CommentPreviewMode") {
			EnumCaseDef("first")
				.doc("""
					Return the text of the first comment in
					``BoardTopic/commentPreview`` for each topic
					""")
			EnumCaseDef("last")
				.doc("""
					Return the text of the last comment in
					``BoardTopic/commentPreview`` for each topic
					""")
			EnumCaseDef("none")
				.doc("Do not return ``BoardTopic/commentPreview``.")
		}
		.frozen()

		FieldDef("preview", type: .def(previewModeDef))
			.doc("""
				Comment preview mode.

				By default ``CommentPreviewMode/none``.
				""")

		FieldDef("preview_length", type: .int)
			.doc("""
				If ``preview`` is not ``CommentPreviewMode/none``, how many
				characters of the comment text to return.
				The text will be truncated on a word boundary.
				Pass 0 to return complete texts.

				By default 90.
				""")
	}
	.doc("""
		Returns the list of topics in a group’s discussion board.

		Accessing topics in private or closed groups requires the `groups:read`
		permission.
		""")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(boardTopic),
			extras: .paginatedListExtrasProfiles)
	) {
		FieldDef("extended", type: .bool)
			.required()
			.constantValue("true")
		FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
			.doc("A list of ``User`` profile fields to be returned.")
	}
}
