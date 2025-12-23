let wall = Group("Wall") {
	RequestDef("wall.createComment", resultType: .def(wallPostID)) {
		FieldDef("post_id", type: .def(wallPostID))
			.required()
			.doc("Identifier of the post on which to comment.")
		commentCreationParameters(group: "Wall", replyToID: wallPostID)
	}
	.doc("Creates a new comment on a wall post.")
	.requiresPermissions("wall")
}
