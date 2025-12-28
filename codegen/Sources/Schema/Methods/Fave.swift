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
}
