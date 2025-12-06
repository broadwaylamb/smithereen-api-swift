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

	let friendshipInfo = StructDef("FriendshipInfo") {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier.")
		let state = EnumDef<String>("State") {
			EnumCaseDef("none", additionalRepresentation: 0)
				.doc("No relationship.")
			EnumCaseDef("following", additionalRepresentation: 1)
				.doc("Current user is following this user.")
			EnumCaseDef("followed_by", additionalRepresentation: 2)
				.doc("This user is following the current user.")
			EnumCaseDef("friends", additionalRepresentation: 3)
				.doc("Users are friends (they follow each other).")
			EnumCaseDef("follow_requested")
				.doc("""
					Only for remote users – current user tried to follow this
					user, but their server hasn’t yet accepted that request
					""")
		}
		FieldDef("friend_status", type: .def(state))
			.required()
			.doc("The relationship between this user and the current user.")
		state
		FieldDef("is_request_unread", type: .bool)
			.doc("""
				Whether there’s an incoming friend request from this user.
				Only returned when ``extended`` is `true` and ``friendStatus``
				is ``followedBy``.
				""")
	}
	RequestDef("friends.areFriends", resultType: .array(.def(friendshipInfo))) {
		FieldDef("user_ids", type: .array(.def(userID)))
			.required()
			.doc("""
				The list of user identifiers to retrieve friendship states for.
				""")
		
		FieldDef("extended", type: .bool)
			.required()
			.doc("Whether to return ``FriendshipInfo/isRequestUnread``.")
		
		friendshipInfo
	}
	.doc("""
		Returns information about friendship states and friend requests related
		to the specified users.
		""")
	.requiresPermissions("friends:read")
}
