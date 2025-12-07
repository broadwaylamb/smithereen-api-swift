let groups = Group("Groups") {
	RequestDef("groups.get", resultType: .paginatedList(.def(groupID))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				User identifier for which to return groups.
				Current user ID by default, required if not using a token.
				""")
		
		let filterEnum = EnumDef<String>("Filter") {
			EnumCaseDef("admin")
				.doc("""
					Only return communities where the user is an administrator.
					""")
			EnumCaseDef("moder")
				.doc("""
					Only return communities where the user is a moderator
					or an administrator.
					""")
			EnumCaseDef("groups")
				.doc("Only return groups")
			EnumCaseDef("events")
				.doc("only return events")
		}
		.frozen()
		FieldDef("filter", type: .array(.def(filterEnum)))
			.doc("""
				A list of filters determining what kinds of communities
				to return.

				Events and filtering by admin level require a token and only
				apply for the current user and require
				the `groups:read` permission.
				""")
		filterEnum

		offsetAndCountParams("group", defaultCount: 100)
	}
	.doc("Returns the list of groups or events in which a user is a member.")
	.withGroupFields()
}
