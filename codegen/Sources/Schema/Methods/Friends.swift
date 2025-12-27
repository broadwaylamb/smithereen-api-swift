let friends = Group("Friends") {
	apiMethod("friends.add") {
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

	apiMethod("friends.addList", resultType: .def(friendListID)) {
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
				is ``State/followedBy``.
				""")
	}
	apiMethod("friends.areFriends", resultType: .array(.def(friendshipInfo))) {
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

	apiMethod("friends.delete") {
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

	apiMethod("friends.deleteList", resultType: .void) {
		FieldDef("list_id", type: .def(friendListID))
			.required()
			.doc("The identifier of the friend list to be deleted.")
	}
	.doc("Deletes a friend list.")
	.requiresPermissions("friends")

	apiMethod("friends.edit", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier for which lists need to be updated.")

		FieldDef("list_ids", type: .array(.def(friendListID)))
			.required()
			.doc("The list of list identifiers.")
	}
	.doc("""
		Changes which lists a friend is included in.
		""")
	.requiresPermissions("friends")

	apiMethod("friends.editList", resultType: .void) {
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
	.doc("Updates an existing friend list.")
	.requiresPermissions("friends")

	apiMethod("friends.get", resultType: .paginatedList(.def(userID))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				The identifier of the user whose friend list needs to be returned.
				If an access token is used, defaults to the current user’s ID.
				Required when called without an access token.
				""")

		let orderEnum = EnumDef<String>("Order") {
			EnumCaseDef("hints")
				.doc("""
					Order by how often the user interacts with each friend.
					Requires `friends:read` and only works for the current user.
					""")
			EnumCaseDef("random")
				.doc("Order randomly.")
			EnumCaseDef("id")
				.doc("Order by user identifiers.")
			EnumCaseDef("recent")
				.doc("""
					Order by when each friend was added, most recent first.
					Requires `friends:read` and only works for the current user.
					""")
		}
		.frozen()
		FieldDef("order", type: .def(orderEnum))
			.doc("""
				In which order to return the friends. By default ``Order/id``.
				""")
		orderEnum

		FieldDef("list_id", type: .def(friendListID))
			.doc("""
				Only return friends in the specified list.
				For private lists, only works for the current user and only with
				a token that has the `friends:read` permission.
				""")

		offsetAndCountParams("friend", defaultCount: 100)
	}
	.doc("Returns the friend list of a user.")
	.withUserFields()

	apiMethod("friends.getLists", resultType: .array(.def(friendList))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				User identifier whose friend lists need to be returned.
				Required if not using a token.
				If using a token, defaults to the current user.
				""")
	}

	apiMethod("friends.getMutual", resultType: .array(.def(userID))) {
		FieldDef("source_user_id", type: .def(userID))
			.doc("""
				Identifier of the user whose friend list needs to be intersected
				with ``targetUserID``. By default, the current user ID.
				""")
		FieldDef("target_user_id", type: .def(userID))
			.required()
			.doc("""
				Identifier of the user with whom mutual friends need to be
				found.
				""")

		let orderEnum = EnumDef<String>("Order") {
			EnumCaseDef("random")
				.doc("Order randomly.")
			EnumCaseDef("id")
				.doc("Order by user identifiers.")
		}
		.frozen()
		FieldDef("order", type: .def(orderEnum))
			.doc("""
				In which order to return the friends. By default ``Order/id``.
				""")
		orderEnum

		offsetAndCountParams("friend", defaultCount: 100)
	}
	.doc("Returns the list of mutual friends between two users.")
	.requiresPermissions("friends:read")
	.withUserFields()

	apiMethod("friends.getOnline", resultType: .paginatedList(.def(userID))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				The identifier of the user whose friend list needs to be
				returned. If an access token is used, defaults to the current
				user’s ID. Required when called without an access token.
				""")

		let orderEnum = EnumDef<String>("Order") {
			EnumCaseDef("hints")
				.doc("""
					Order by how often the user interacts with each friend.
					Requires a token and only works for the current user.
					""")
			EnumCaseDef("random")
				.doc("Order randomly.")
			EnumCaseDef("id")
				.doc("Order by user identifiers.")
		}
		.frozen()

		FieldDef("order", type: .def(orderEnum))
			.doc(
				"In which order to return the friends. By default ``Order/id``."
			)
		orderEnum

		FieldDef("list_id", type: .def(friendListID))
			.doc("""
				Only return friends in the specified list. For private lists,
				only works for the current user and only with a token that has
				the `friends:read` permission.
				""")

		offsetAndCountParams("friend", defaultCount: 100)
	}
	.doc("Returns the friends of a user that are online right now.")
	.withUserFields()


	let friendRequestStruct = StructDef("FriendRequest") {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				If no ``Friends/GetRequests/Extended/fields`` are specified,
				the user identifier.
				""")
		FieldDef("user", type: .def(user))
			.doc("""
				If ``Friends/GetRequests/Extended/fields`` are specified,
				a ``User`` object.
				""")
		FieldDef("message", type: .string)
			.doc("""
				If ``Friends/GetRequests/Extended/extended`` is `true`,
				and this friend request was sent with a message, that message.
				""")

		let mutualStruct = StructDef("Mutual") {
			FieldDef("count", type: .int)
				.required()
				.doc("The total number of mutual friends.")
			FieldDef("users", type: .array(.def(userID)))
				.required()
				.doc("Up to 10 user IDs of mutual friends.")
		}
		FieldDef("mutual", type: .def(mutualStruct))
			.doc("""
				If ``Friends/GetRequests/Extended/needMutual`` is `true`,
				an object describing the mutual friends with this user.
				""")
		mutualStruct
	}
	apiMethod("friends.getRequests", resultType: .paginatedList(.def(userID))) {
		offsetAndCountParams("friend request", defaultCount: 20)
	}
	.doc("Returns the current user’s incoming friend requests.")
	.requiresPermissions("friends:read")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(.def(friendRequestStruct))
	) {
		FieldDef("extended", type: .bool)
			.doc("""
				Whether to return the messages specified by the users who sent
				the friend requests.
				By default `false`.
				""")
		FieldDef("need_mutual", type: .bool)
			.doc("""
				Whether to return information about mutual friends for each
				friend request.
				""")
		FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
			.doc("A list of user profile fields to be returned.")

		friendRequestStruct
	}
}
