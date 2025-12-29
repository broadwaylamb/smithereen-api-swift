let wall = Group("Wall") {
	apiMethod("wall.createComment", resultType: .def(wallPostID)) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("Identifier of the post on which to comment.")
		commentCreationParameters(method: "Wall/CreateComment", replyToID: wallPostID)
	}
	.doc("Creates a new comment on a wall post.")
	.requiresPermissions("wall")

	apiMethod("wall.delete", resultType: .void) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("The identifier of the post which you’re deleting.")
	}
	.doc("Deletes a wall post or comment.")
	.requiresPermissions("wall")

	apiMethod("wall.edit", resultType: .def(wallPostID)) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("The identifier of the post to be updated.")
		postParameters(postKind: "post")
	}
	.doc("Edits a wall post or comment.")
	.requiresPermissions("wall")

	apiMethod("wall.get", resultType: .paginatedList(.def(wallPost))) {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				The ID of the user or the group whose wall posts need
				to be returned.

				By default the current user.
				""")
		offsetAndCountParams("post", range: 1...100, defaultCount: 20)

		let filterDef = EnumDef<String>("Filter") {
			EnumCaseDef("owner")
				.doc("Only posts made by the wall owner.")
			EnumCaseDef("others")
				.doc("Only posts made by users other than the wall owner.")
			EnumCaseDef("all")
				.doc("All posts (``owner`` + ``others``)")
		}
		.frozen()
		FieldDef("filter", type: .def(filterDef))
			.doc("Which posts to return. By default ``Filter/all``.")
		filterDef

		repostHistoryDepth()
	}
	.doc("Returns the posts on a user’s or group’s wall.")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(wallPost),
			extras: .paginatedListExtrasProfilesAndGroups,
		)
	) {
		extendedParameters()
	}

	apiMethod("wall.getById", resultType: .array(.def(wallPost))) {
		FieldDef("posts", type: .array(.def(wallPostID)))
			.required()
			.doc("A list of post IDs")
		repostHistoryDepth()
	}
	.doc("Returns wall posts by their IDs.")
	.withExtendedVersion("Extended") {
		extendedParameters()

		StructDef("Result") {
			FieldDef("profiles", type: .array(.def(user)))
				.required()
			FieldDef("groups", type: .array(.def(group)))
				.required()
			FieldDef("items", type: .array(.def(wallPost)))
				.required()
		}
	}

	commentsRequest(
		"wall.getComments",
		commentID: wallPostID,
		comment: wallPost,
		targetField: FieldDef("post_id", type: .def(wallPostID))
			.doc("The identifier of the post."),
	)

	apiMethod("wall.getEditSource", resultType: .def(postEditSource)) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("""
				The identifier of the post for which the source needs
				to be returned.
				""")
	}
	.doc("""
		Returns the source of the text and attachments of a post or
		a comment, as submitted when creating it, so they could be used
		for editing.
		""")
	.requiresPermissions("wall")

	apiMethod("wall.getReposts", resultType: .paginatedList(.def(wallPost))) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("The post identifier.")

		offsetAndCountParams("post", range: 1...100, defaultCount: 20)
		repostHistoryDepth()
	}
	.doc("Returns the list of reposts for a wall post or comment.")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(wallPost),
			extras: .paginatedListExtrasProfilesAndGroups,
		)
	) {
		extendedParameters()
	}

	apiMethod("wall.pin", resultType: .void) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("Identifier of the post to pin.")
	}
	.doc("Pins a post so it appears at the top of the owner’s wall.")
	.requiresPermissions("wall")

	apiMethod("wall.post", resultType: .def(wallPostID)) {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				User or group ID on whose wall the post is to be created.
				By default the current user.
				""")
		postParameters(postKind: "post")
		guidField(method: "Wall/Post", entity: "post")
	}
	.doc("Creates a new wall post.")
	.requiresPermissions("wall")

	apiMethod("wall.repost", resultType: .def(wallPostID)) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("The identifier of the post or comment to be reposted.")
		postParameters(postKind: "repost")
		guidField(method: "Wall/Repost", entity: "post")
	}

	apiMethod("wall.unpin", resultType: .void) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("Identifier of the post to unpin.")
	}
	.doc("Unpins a previously pinned wall post.")
	.requiresPermissions("wall")
}

private func repostHistoryDepth() -> FieldDef {
	FieldDef("repost_history_depth", type: .int)
		.doc("""
			Determines the size of the ``WallPost/repostHistory`` array.
			For example, if a post is a repost of another repost,
			with ``repostHistoryDepth`` = 1, only the first repost
			will be returned.

			From 0 to 10. By default 2.
			""")
}

@StructDefBuilder
private func extendedParameters() -> any StructDefPart {
	FieldDef("extended", type: .bool)
		.required()
		.constantValue("true")
	actorFieldsParam()
}
