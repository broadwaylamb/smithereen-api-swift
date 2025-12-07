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

	RequestDef("groups.getById", resultType: .array(.def(group))) {
		FieldDef("group_ids", type: .array(.def(groupID)))
			.required()
			.doc("A list of group identifiers.")
		FieldDef("fields", type: .array(TypeRef(name: "Group.Field")))
			.doc("A list of group profile fields to return.")
	}
	.doc("Returns information about groups.")

	RequestDef("groups.getInvites", resultType: .paginatedList(.def(group))) {
		let typeEnum = EnumDef<String>("CommunityType") {
			EnumCaseDef("groups")
			EnumCaseDef("events")
		}
		.frozen()
		FieldDef("type", type: .def(typeEnum))
			.doc("""
				Whether to return invitations to groups or to events.

				By default ``CommunityType/groups``.
				""")
		typeEnum

		offsetAndCountParams("invitation", defaultCount: 20)

		FieldDef("extended", type: .bool)
			.doc("Whether to also return users that sent the invitations.")
		
		FieldDef("fields", type: .array(.def(actorField)))
			.doc("""
				A list of group profile fields to return.

				If ``extended`` is `true`, also user profile fields for
				the inviters.
				""")
	}
	.doc("Returns the group invitations for the current user.")
	.requiresPermissions("groups")

	RequestDef("groups.getMembers") {
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

		offsetAndCountParams("member", defaultCount: 100)

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

	FileDef("Groups.IsMember", additionalImports: ["Hammond"]) {
		let isMemberDoc = 
			"Checks whether a user is a member of a group or an event."
		let isMemberGroupIDField = FieldDef("group_id", type: .def(groupID))
			.required()
			.doc("Group identifier.")
		RequestDef(
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
		RequestDef(
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

	RequestDef("groups.join", resultType: .bool) {
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

		Returns `true` on success.
		""")
	.requiresPermissions("groups")
}
