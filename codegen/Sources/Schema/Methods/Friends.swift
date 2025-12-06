let friends = Group("Friends") {
	RequestDef("friends.add") {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("The identifier of the target user.")
		FieldDef("text", type: .string)
			.doc("""
				If sending a friend request, the message to send along with it.
				""")
		EnumDef<String>("Result") {
			EnumCaseDef("request_sent", additionalRepresentation: 1)
				.doc("A friend request was sent.")
			EnumCaseDef("request_accepted", additionalRepresentation: 2)
				.doc("""
					An incoming friend request was accepted, or the target user
					was following the current user and they’re now friends.
					""")
			EnumCaseDef("followed")
				.doc("""
					The current user was added as a follower of the target user
					without sending a friend request
					""")
		}
	}
	.doc("""
		Sends a friend request, accepts an incoming friend request,
		or follows a user.
		""")
	.requiresPermissions("friends")
	
	RequestDef("friends.addList", resultType: .def(friendListID)) {
		FieldDef("name", type: .string)
			.required()
			.doc("The name of the new list.")
		FieldDef("user_ids", type: .array(.def(friendListID)))
			.required()
			.doc("A list of user identifiers to be added to this list.")
	}
	.doc("""
		Creates a private friend list.

		Returns the identifier of the newly created friend list.
		""")
	.requiresPermissions("friends")
}
