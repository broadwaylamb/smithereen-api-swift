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

	RequestDef("friends.delete") {
		FieldDef("user_id", type: .def(userID))

		EnumDef<String>("Result") {
			EnumCaseDef("friend_deleted", additionalRepresentation: 1)
				.doc("""
					The target user was the current user’s friend and was
					removed from the friend list.
					""")
			EnumCaseDef("unfollowed")
				.doc("""
					The current user was non-mutually following the target user,
					but there was no outgoing friend request.
					""")
			EnumCaseDef("out_request_deleted")
				.doc("""
					There was an outgoing friend request and it was deleted.
					""")
			EnumCaseDef("in_request_deleted", additionalRepresentation: 2)
				.doc("""
					There was an incoming friend request and it was deleted.
					""")
		}
	}
	.doc("""
		Unfriends or unfollows a user. If there’s an outgoing friend request,
		cancels it. If there’s an incoming friend request, rejects it,
		same as the “leave as a follower” button on the web.
		""")
	.requiresPermissions("friends")

	RequestDef("friends.deleteList", resultType: .bool) {
		FieldDef("list_id", type: .def(friendListID))
			.required()
			.doc("The identifier of the friend list to be deleted.")
	}
	.doc("Deletes a friend list. Returns `true` on success.")
	.requiresPermissions("friends")

	RequestDef("friends.edit", resultType: .bool) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier for which lists need to be updated.")

		FieldDef("list_ids", type: .array(.def(friendListID)))
			.required()
			.doc("The list of list identifiers.")
	}
	.doc("""
		Changes which lists a friend is included in. Returns `true` on success.
		""")
	.requiresPermissions("friends")

	RequestDef("friends.editList", resultType: .bool) {
		FieldDef("list_id", type: .def(friendListID))
			.required()
			.doc("The identifier of the friend list to be updated.")
		FieldDef("name", type: .string)
			.doc("""
				A new name for the list. If not specified, the name of the list
				will not be updated.
				""")
		FieldDef("user_ids", type: .array(.def(userID)))
			.doc("""
				A list of user identifiers to completely replace the existing
				ones in this list.
				""")
		FieldDef("add_user_ids", type: .array(.def(userID)))
			.doc("""
				A list of user identifiers to be added to this list.
				Only applies if ``userIDs`` was not specified.
				""")
		FieldDef("delete_user_ids", type: .array(.def(userID)))
			.doc("""
				A list of user identifiers to be removed from this list.
				Only applies if ``userIDs`` was not specified.
				""")
	}
	.doc("Updates an existing friend list. Returns `true` on success.")
	.requiresPermissions("friends")
}
