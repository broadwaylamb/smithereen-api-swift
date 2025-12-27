let users = Group("Users") {
	apiMethod("users.get", resultType: .array(.def(user))) {
		FieldDef("user_ids", type: .array(.def(userID)))
			.doc("""
				A list of user IDs or screen names.
				If the method is called with an access token,
				defaults to the current user’s ID.
				Required if no token is used.
				""")
		FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
			.doc("A list of user profile fields to be returned.")
		let caseDef = EnumDef<String>("RelationCase") {
			EnumCaseDef("def", swiftName: "default")
				.doc("The default case used in the web interface with the current language.")
			EnumCaseDef("nom", swiftName: "nominative")
			EnumCaseDef("gen", swiftName: "genitive")
			EnumCaseDef("dat", swiftName: "dative")
			EnumCaseDef("acc", swiftName: "accusative")
			EnumCaseDef("ins", swiftName: "instrumental")
			EnumCaseDef("pre", swiftName: "prepositional")
		}
		.frozen()
		FieldDef("relation_case", type: .def(caseDef))
			.doc("""
				For Slavic languages and when the ``User/Field/relation``
				field is requested, the grammatical case for
				the relationship partner’s name.
				""")
		caseDef
	}
	.doc("Returns information about users.")

	apiMethod("users.getFollowers", resultType: .paginatedList(.def(userID))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				ID of the user whose followers you’re requesting.
				If the method is called with an access token, defaults to
				the current user’s ID. Required if no token is used.
				""")
			offsetAndCountParams("follower", defaultCount: 100)
	}
	.doc("Returns the list of a user’s followers.")
	.withUserFields()

	apiMethod("users.getSubscriptions", resultType: .paginatedList(.def(userID))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				ID of the user whose subscriptions you’re requesting.
				If the method is called with an access token,
				defaults to the current user’s ID. Required if no token is used.
				""")
			offsetAndCountParams("follower", defaultCount: 100)
	}
	.doc("Returns the list of users followed by a user.")
	.withUserFields()

	apiMethod("users.search", resultType: .paginatedList(.def(userID))) {
		FieldDef("q", type: .string)
			.swiftName("query")
			.required()
			.doc("The search query.")
		FieldDef("count", type: .int)
			.doc("""
				How many search results to return, from 1 to 100.

				By default 100.
				""")
	}
	.doc("Returns a list of users matching search criteria.")
	.withUserFields()
}
