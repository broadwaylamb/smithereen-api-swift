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
		FieldDef("fields", type: .array(TypeRef(name: "Group.Field")))
			.doc("A list of ``Group`` profile fields to be returned.")
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
		FieldDef("fields", type: .array(.def(actorField)))
			.doc("""
				A list of ``User`` and ``Group`` profile fields to be
				returned.
				""")
	}
}
