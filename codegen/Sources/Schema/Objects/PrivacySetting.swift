let privacySetting = StructDef("PrivacySetting") {
	let ruleDef = EnumDef<String>("Rule") {
		EnumCaseDef("everyone")
			.doc("Everyone has access.")
		EnumCaseDef("friends")
			.doc("Only current user’s friends have access.")
		EnumCaseDef("friends_of_friends")
			.doc("Only current user’s friends and their friends have access.")
		EnumCaseDef("followers")
			.doc(("Only current user’s followers have access."))
		EnumCaseDef("following")
			.doc("Only users following the current user have access.")
		EnumCaseDef("none")
			.doc("No one has access.")
	}
	FieldDef("rule", type: .def(ruleDef))
		.required()
		.doc("The base rule of this privacy setting.")
	ruleDef

	FieldDef("allow_users", type: .array(.def(userID)))
		.required()
		.doc("""
			Identifiers of the current user’s friends who have access even if
			the base rule would not allow it.
			""")

	FieldDef("allow_lists", type: .array(.def(friendListID)))
		.required()
		.doc("""
			Identifiers of the current user’s friend lists whose members have
			access even if the base rule would not allow it.
			""")

	FieldDef("except_users", type: .array(.def(userID)))
		.required()
		.doc("""
			Identifiers of the current user’s friends who do **not** have access
			even if the base rule would allow it.
			""")

	FieldDef("except_lists", type: .array(.def(friendListID)))
		.required()
		.doc("""
			Identifiers of the current user’s friend lists whose members do
			**not** have access even if the base rule would allow it.
			""")

	IdentifierStruct("Key", rawValue: .string)

	EnumDef<String>("FeedType") {
		EnumCaseDef("photo")
			.doc("New photos added to albums.")
		EnumCaseDef("photo_tag")
			.doc("New photo tags.")
		EnumCaseDef("friend")
			.doc("New friends.")
		EnumCaseDef("group")
			.doc("Groups joined or created.")
		EnumCaseDef("event")
			.doc("Events joined or created.")
		EnumCaseDef("board")
			.doc("New discussion board topics in groups.")
		EnumCaseDef("relation")
			.doc("Relationship status changes.")
	}
	.doc("Which updates show up in followers' news feeds.")
}
.doc("A privacy setting configurable by the current user.")
