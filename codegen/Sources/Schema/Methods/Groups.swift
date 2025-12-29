let groups = Group("Groups") {
	apiMethod("groups.acceptUser", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier.")
	}
	.doc("""
		Accepts a pending request to join a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.banDomain", resultType: .void) {
		FieldDef("domain", type: .string)
			.required()
			.doc("The domain name of the server to block.")
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Blocks a remote server in a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.banUser", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier.")
	}
	.doc("""
		Blocks a user from participating in a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.get", resultType: .paginatedList(.def(groupID))) {
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

		offsetAndCountParams("group", range: 1...1000, defaultCount: 100)
	}
	.doc("Returns the list of groups or events in which a user is a member.")
	.withGroupFields()

	apiMethod("groups.getBannedDomains", resultType: .paginatedList(.string)) {
		offsetAndCountParams("domain", range: 1...1000, defaultCount: 100)
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Returns the list of remote server domains blocked in a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.getBannedUsers", resultType: .paginatedList(.def(user))) {
		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
		userFieldsParam()
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Returns the list of users blocked in a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.getById", resultType: .array(.def(group))) {
		FieldDef("group_ids", type: .array(.def(groupID)))
			.required()
			.doc("A list of group identifiers.")
		groupFieldsParam()
	}
	.doc("Returns information about groups.")

	apiMethod("groups.getInvitedUsers", resultType: .paginatedList(.def(user))) {
		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
		userFieldsParam()
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Returns the list of users who have a pending invitation to a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.getInvites", resultType: .paginatedList(.def(group))) {
		FieldDef("type", type: .def(communityType))
			.doc("""
				Whether to return invitations to groups or to events.

				By default ``CommunityType/groups``.
				""")

		offsetAndCountParams("invitation", range: 1...500, defaultCount: 20)
		groupFieldsParam()
	}
	.doc("Returns the group invitations for the current user.")
	.requiresPermissions("groups")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(group),
			extras: .paginatedListExtrasProfiles,
		),
	) {
		FieldDef("extended", type: .bool)
			.required()
			.constantValue("true")
		actorFieldsParam()
	}

	apiMethod("groups.getMembers") {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")

		let sortingEnum = EnumDef<String>("Sorting") {
			EnumCaseDef("id_asc")
				.swiftName("idAscending")
				.doc("By identifiers, ascending.")
			EnumCaseDef("id_desc")
				.swiftName("idDescending")
				.doc("By identifiers, descending.")
			EnumCaseDef("random")
				.doc("""
					Random. The ``offset`` parameter is ignored in this mode.
					""")
			EnumCaseDef("time_asc")
				.swiftName("timeAscending")
				.doc("""
					By join time, ascending (only available when called with
					an access token of a group manager).
					""")
			EnumCaseDef("time_desc")
				.swiftName("timeDescending")
				.doc("""
					By join time, descending (only available when called with
					an access token of a group manager).
					""")
		}
		.frozen()
		FieldDef("sort", type: .def(sortingEnum))
			.doc("""
				How to sort the returned users.
				By default ``Sorting/idAscending``.
				""")
		sortingEnum

		offsetAndCountParams("member", range: 1...1000, defaultCount: 100)

		let filterEnum = EnumDef<String>("Filter") {
			EnumCaseDef("friends")
				.doc("""
					Only return current user’s friends who are members of
					this group.
					""")
			EnumCaseDef("unsure")
				.doc("Only return event attendees who aren’t sure.")
			EnumCaseDef("managers")
				.doc("""
					Only return group managers and their roles (only available
					when called with an access token of a group manager).
					``offset`` and ``count`` parameters are ignored in this
					mode.
					""")
			EnumCaseDef("unsure_friends")
				.doc("""
					Only return current user’s friends who aren’t sure that
					they’ll attend this event.
					""")
		}
		.frozen()
		FieldDef("filter", type: .def(filterEnum))
			.doc("""
				How to filter the group members.
				By default, all members are returned for groups,
				and “sure” attendees for events.
				""")
		filterEnum
	}
	.doc("Returns the list of group members.")
	.withUserFields()

	apiMethod("groups.getRequests", resultType: .paginatedList(.def(user))) {
		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
		userFieldsParam()
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Returns the list of users who requested to join a closed group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")

	FileDef("Groups.IsMember", additionalImports: ["Hammond"]) {
		let isMemberDoc =
			"Checks whether a user is a member of a group or an event."
		let isMemberGroupIDField = FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
		apiMethod(
			"groups.isMember",
			swiftName: "Groups.IsMemberSingleUser",
			resultType: .bool
		) {
			isMemberGroupIDField
			FieldDef("user_id", type: .def(userID))
				.required()
				.doc("User identifier to check.")
		}
		.doc(isMemberDoc)

		let membershipStruct = StructDef("Membership") {
			FieldDef("user_id", type: .def(userID))
				.required()
			FieldDef("member", type: .bool)
				.required()
			FieldDef("request", type: .bool)
				.doc("""
					Whether there’s a pending join request from this user
					(only returned with a token with `groups:read` permission,
					for group admins or moderators).
					""")
			FieldDef("invitation", type: .bool)
				.doc("""
					Whether this user is invited into this group or event
					(only returned with a token with `groups:read` permission,
					for group admins or moderators).
					""")
			FieldDef("can_invite", type: .bool)
				.doc("""
					Whether the current user can invite this user to this group or
					event.
					""")
		}
		apiMethod(
			"groups.isMember",
			swiftName: "Groups.IsMemberMultipleUsers",
			resultType: .array(.def(membershipStruct)),
		) {
			isMemberGroupIDField
			FieldDef("user_ids", type: .array(.def(userID)))
				.required()
				.doc("Up to 500 user identifiers.")
			FieldDef("extended", type: .bool)
				.doc("""
					Whether to also return information about join requests and
					invitations.

					By default `false`.
					""")

			membershipStruct
		}
		.doc(isMemberDoc)
	}

	apiMethod("groups.join", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("The group identifier.")
		FieldDef("not_sure", type: .bool)
			.doc("""
				If this group is an event, whether the user is unsure they’ll
				be able to addend this event.
				""")
	}
	.doc("""
		Joins a group.

		If there’s an invitation, accepts it as well.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.leave", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("The group identifier.")
	}
	.doc("""
		Leaves a group or rejects an invitation.
		""")
	.requiresPermissions("groups")

	apiMethod("groups.removeUser", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier.")
	}
	.doc("""
		Removes a user from a group, rejects a pending join request,
		or cancels an invitation.

		The current user must be at least a moderator in the group.
		""")

	apiMethod("groups.search", resultType: .paginatedList(.def(group))) {
		FieldDef("q", type: .string)
			.swiftName("query")
			.required()
			.doc("The search query.")

		FieldDef("type", type: .def(communityType))
			.doc("""
				Whether to search for groups or to events.
				By default ``CommunityType/groups``.
				""")

		offsetAndCountParams("group", range: 1...100, defaultCount: 100)
		groupFieldsParam()
	}
	.doc("Searches groups or events.")

	apiMethod("groups.unbanDomain", resultType: .void) {
		FieldDef("domain", type: .string)
			.required()
			.doc("The domain name of the server to block.")
		FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
	}
	.doc("""
		Unblocks a previously blocked remote server in a group.

		The current user must be at least a moderator in the group.
		""")
	.requiresPermissions("groups")
}
