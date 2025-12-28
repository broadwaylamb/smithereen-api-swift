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
}
