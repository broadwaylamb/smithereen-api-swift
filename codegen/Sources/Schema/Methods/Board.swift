let board = Group("Board") {
	apiMethod("board.closeTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Closes a topic so that no more comments could be posted.")
	.requiresPermissions("groups")

	apiMethod("board.createComment", resultType: .def(topicCommentID)) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("Identifier of the topic on which to comment.")
		commentCreationParameters(method: "Board/CreateComment", replyToID: topicCommentID)
	}
	.doc("Creates a new comment in a topic.")
	.requiresPermissions("groups")

	apiMethod("board.createTopic", resultType: .def(boardTopicID)) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Identifier of the group where to create the topic.")
		FieldDef("title", type: .string)
			.required()
			.doc("The title of the topic.")
		postParameters(postKind: "comment")
		guidField(method: "Board/CreateTopic", entity: "topic")
	}
	.doc("Creates a new topic in a group.")
	.requiresPermissions("groups")

	apiMethod("board.deleteComment", resultType: .void) {
		FieldDef("comment_id", type: .def(topicCommentID))
			.required()
			.doc("Identifier of the comment to delete.")
	}
	.doc("Deletes a comment in a topic.")
	.requiresPermissions("groups")

	apiMethod("board.deleteTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Deletes a topic.")
	.requiresPermissions("groups")

	apiMethod("board.editComment", resultType: .def(topicCommentID)) {
		FieldDef("comment_id", type: .def(topicCommentID))
			.required()
			.doc("The identifier of the comment to be updated.")
		postParameters(postKind: "comment")
	}
	.doc("Edits a comment in a topic.")
	.requiresPermissions("groups")

	apiMethod("board.editTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
		FieldDef("title", type: .string)
			.required()
			.doc("The new title.")
	}
	.doc("Edits the title of a topic.")
	.requiresPermissions("groups")

	apiMethod("board.getCommentEditSource", resultType: .def(postEditSource)) {
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

	apiMethod("board.getTopics", resultType: .paginatedList(.def(boardTopic))) {
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

		FieldDef("order", type: .def(orderDef))
			.doc("""
				Sort order for the topics. Pinned topics, if any, will always
				be returned first regardless of this parameter.

				By default ``Order/updatedDescending``.
				""")
		orderDef

		offsetAndCountParams("topic", range: 1...100, defaultCount: 40)
		commentPreviewParameters()
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
		extendedParameters()
	}

	apiMethod("board.getTopicsById", resultType: .array(.def(boardTopic))) {
		FieldDef("topic_ids", type: .array(.def(boardTopicID)))
			.required()
			.doc("A list of topic identifiers.")
		commentPreviewParameters()
	}
	.doc("""
		Returns discussion board topics by their identifiers.

		Accessing topics in private or closed groups requires the `groups:read`
		permission.
		""")
	.withExtendedVersion("Extended") {
		extendedParameters()

		StructDef("Result") {
			FieldDef("profiles", type: .array(.def(user)))
				.required()
			FieldDef("items", type: .array(.def(boardTopic)))
				.required()
		}
	}

	apiMethod("board.openTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Reopens a previously closed topic.")
	.requiresPermissions("groups")

	apiMethod("board.pinTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Pins a topic so it’s always displayed at the top of the discussion board.")
	.requiresPermissions("groups")

	apiMethod("board.unpinTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Unpins a previously pinned topic.")
	.requiresPermissions("groups")
}

@StructDefBuilder
private func commentPreviewParameters() -> any StructDefPart {
	FieldDef("preview", type: .def(topicCommentPreviewMode))
		.doc("""
			Comment preview mode.

			By default ``TopicCommentPreviewMode/none``.
			""")

	FieldDef("preview_length", type: .int)
		.doc("""
			If ``preview`` is not ``TopicCommentPreviewMode/none``, how many
			characters of the comment text to return.
			The text will be truncated on a word boundary.
			Pass 0 to return complete texts.

			By default 90.
			""")
}

@StructDefBuilder
private func extendedParameters() -> any StructDefPart {
	FieldDef("extended", type: .bool)
		.required()
		.constantValue("true")
	userFieldsParam()
}
