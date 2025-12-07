let friendList = StructDef("FriendList") {
	FieldDef("id", type: .def(friendListID))
		.required()
		.id()
		.doc("Identifier of the list.")
	
	FieldDef("name", type: .string)
		.required()
		.doc("Name of the list.")
	
	FieldDef("is_system", type: .bool)
		.required()
		.doc("""
			Whether this is a public/system list. Such lists are visible to
			everyone, can’t be deleted, and and have localized names that
			can’t be edited.
			""")
}
