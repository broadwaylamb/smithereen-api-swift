let fave = Group("Fave") {
	apiMethod("fave.addGroup", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Identifier of the target group.")
	}
	.doc("Adds a group to the current user’s bookmarks.")
	.requiresPermissions("likes")

	apiMethod("fave.addUser", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("Identifier of the target user.")
	}
	.doc("Adds a user to the current user’s bookmarks.")
	.requiresPermissions("likes")

	apiMethod("fave.getGroups", resultType: .paginatedList(.def(group))) {
		offsetAndCountParams("group", range: 1...1000, defaultCount: 100)
		groupFieldsParam()
	}
	.doc("Returns the current user’s bookmarked groups and events.")
	.requiresPermissions("likes:read")

	apiMethod("fave.getPhotos", resultType: .paginatedList(.def(photo))) {
		offsetAndCountParams("photo", range: 1...1000, defaultCount: 50)
		FieldDef("extended", type: .bool)
			.doc("""
				Whether to return extra fields about likes, comments,
				and tags for each photo.

				By default `false`.
				""")
	}
	.doc("Returns the list of photos liked by the current user.")
	.requiresPermissions("likes:read")

	apiMethod("fave.getPosts", resultType: .paginatedList(.def(wallPost))) {
		offsetAndCountParams("post", range: 1...100, defaultCount: 50)
	}
	.doc("Returns the list of posts liked by the current user.")
	.requiresPermissions("likes:read")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(wallPost),
			extras: .paginatedListExtrasProfilesAndGroups,
		),
	) {
		FieldDef("extended", type: .bool)
			.required()
			.constantValue("true")
		actorFieldsParam()
	}

	apiMethod("fave.getUsers", resultType: .paginatedList(.def(user))) {
		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
		userFieldsParam()
	}
	.doc("Returns the current user’s bookmarked users.")
	.requiresPermissions("likes:read")

	apiMethod("fave.removeGroup", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Identifier of the target group.")
	}
	.doc("Removes a group from the current user’s bookmarks.")
	.requiresPermissions("likes")

	apiMethod("fave.removeUser", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("Identifier of the target user.")
	}
	.doc("Removes a user from the current user’s bookmarks.")
	.requiresPermissions("likes")
}
