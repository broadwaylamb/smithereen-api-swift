let group = StructDef("Group") {
	FieldDef("id", type: .def(groupID))
		.id()
		.required()
		.doc("Unique (within the server) identifier for this group.")
	
	FieldDef("name", type: .string)
		.required()
		.doc("The name of this group or event.")
	
	deactivatedStatusField("group")
	activityPubIDField("group")

	let accessTypeEnum = EnumDef<String>("AccessType") {
		EnumCaseDef("open", additionalRepresentation: 0)
			.doc("This is an open group or event, anyone can join.")
		EnumCaseDef("closed", additionalRepresentation: 1)
			.doc("""
				Anyone can see the group’s profile, and new members are manually
				approved by the group managers or invited by existing members.
				Only members can see the content. For groups only.
				""")
		EnumCaseDef("private", additionalRepresentation: 2)
			.doc("""
				Only members can see this group or event.
				Only managers can invite new members, and the only way to join
				is by invitation.
				""")
	}
	.doc("""
		Determines how new members can join this group and what is visible
		to non-members.
		""")

	FieldDef("access_type", type: .def(accessTypeEnum))
		.alternativeNames("is_closed")
		.required()
		.doc(accessTypeEnum.doc)
	accessTypeEnum

	let groupTypeEnum = EnumDef<String>("GroupType") {
		EnumCaseDef("group")
		EnumCaseDef("event")
	}
	
	FieldDef("type", type: .def(groupTypeEnum))
		.required()
		.doc("The type of this community.")
	groupTypeEnum

	FieldDef("domain", type: .string)
		.optionalFieldDoc(
			"For a group from a remote server, the domain of its home server."
		)
	
	FieldDef("screen_name", type: .string)
		.optionalFieldDoc("""
			The profile URL a.k.a. the username.
			If the community doesn’t have one set, defaults to `clubXXX`
			for groups and `eventXXX` for events.
			""")
	
	statusField("group")

	FieldDef("url", type: .url)
		.optionalFieldDoc("""
			The URL of this group’s profile page on the web.
			For remote groups, this points to its home server.
			""")
	
	FieldDef("is_admin", type: .bool)
		.optionalFieldDoc("Whether the current user can manage this group.")
	
	let adminLevelEnum = EnumDef<String>("AdminLevel") {
		EnumCaseDef("moderator")
		EnumCaseDef("admin")
		EnumCaseDef("owner")
	}

	FieldDef("admin_level", type: .def(adminLevelEnum))
		.optionalFieldDoc(
			"The privilege level of the current user, if `isAdmin` is `true`."
		)
	adminLevelEnum

	FieldDef("is_member", type: .bool)
		.optionalFieldDoc(
			"Whether the current user is a member of this group."
		)
	
	profilePictureFields("group")

	FieldDef("can_create_topic", type: .bool)
		.optionalFieldDoc("""
			Whether the current user can create new discussion board topics
			in this group.
			""")
		
	FieldDef("can_post", type: .bool)
		.optionalFieldDoc("""
			Whether the current user can create new posts on this group’s wall.
			""")
	
	FieldDef("management", type: TypeRef(name: "[ManagementItem]"))
		.optionalFieldDoc("""
			Information about users who manage this group.
			Only returned when a single group is requested.
			""")
	StructDef("ManagementItem") {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("User identifier.")
		FieldDef("description", type: .string)
			.doc("Description to be shown alongside the name.")
	}

	let countersStruct = StructDef("Counters") {
		let fields = [
			("photos", "How many photos there are in the group."),
			("albums", "How many photo albums there are in the group."),
			("topics", "How many topics there are in the group’s discussion board."),
		]
		for (name, doc) in fields {
			FieldDef(name, type: .int)
				.required()
				.doc(doc)
		}
	}
	.doc("""
		Information about how many of each of the types of content there are
		in this group. Only returned when a single group is requested.
		""")

	FieldDef("counters", type: .def(countersStruct))
		.optionalFieldDoc(countersStruct.doc)
	countersStruct

	FieldDef("description", type: .string)
		.optionalFieldDoc("The description text of this group, as HTML.")
	
	FieldDef("has_photo", type: .bool)
		.optionalFieldDoc("Whether this group has a profile picture.")
	
	FieldDef("is_favorite", type: .bool)
		.optionalFieldDoc("""
			Whether this group is in the current user’s bookmarks.
			Requires the `likes:read` permission.
			""")
	
	let linkStruct = StructDef("Link") {
		FieldDef("id", type: .def(groupLinkID))
			.id()
			.required()
			.doc("Identifier of this link.")
		FieldDef("url", type: .url)
			.required()
			.doc("The URL of this link.")
		FieldDef("name", type: .string)
			.required()
			.doc("The title of this link.")
		FieldDef("description", type: .string)
			.required()
			.doc("The description of this link.")
		
		for size in photoSizes(50, 100, 200) {
			FieldDef("photo_\(size)", type: .url)
				.doc("\(size)x\(size) preview image URL.")
		}

		// TODO: Object type and object ID
	}
	.doc("""
		Information from the “Links” block in this group.
		Only returned when a single group is requested.
		""")
	FieldDef("links", type: .array(.def(linkStruct)))
		.optionalFieldDoc(linkStruct.doc)
	linkStruct

	let membershipStatusEnum = EnumDef<String>("MembershipStatus") {
		EnumCaseDef("none")
			.doc("This user is not a member of this group.")
		EnumCaseDef("member")
			.doc("This user is a member of this group.")
		EnumCaseDef("tentative")
			.doc("This user is not sure that they will attend this event.")
		EnumCaseDef("requested")
			.doc("""
				This user has requested to join this group, but the request
				hasn’t yet been reviewed by the management.
				""")
		EnumCaseDef("invited")
			.doc("A friend invited this user to this group.")
	}
	FieldDef("member_status", type: .def(membershipStatusEnum))
		.optionalFieldDoc(
			"The membership status of the current user in this group."
		)
	membershipStatusEnum

	FieldDef("place", type: .string)
		.optionalFieldDoc("""
			The name of the place and/or address where this event will take
			place.
			""")
	
	FieldDef("site", type: .string)
		.optionalFieldDoc("The website URL from the group’s profile.")
	
	FieldDef("start_date", type: .unixTimestamp)
		.optionalFieldDoc("The time when the event starts.")
	
	FieldDef("finish_date", type: .unixTimestamp)
		.optionalFieldDoc("The time when the event ends.")
}
.generateFieldsStruct()

extension Documentable {
	fileprivate func optionalFieldDoc(_ text: String?) -> Self {
		optionalFieldDoc(text, objectName: "Group")
	}
}
