let user = StructDef("User") {
	FieldDef("id", type: .def(userID))
		.id()
		.required()
		.doc("Unique (within the server) identifier for this user. A positive integer.")

	FieldDef("first_name", type: .string)
		.required()
		.doc("User’s first name.")

	FieldDef("last_name", type: .string)
		.excludeFromFields()
		.doc("User’s last name.")

	deactivatedStatusField("user")
	activityPubIDField("user")

	FieldDef("domain", type: .string)
		.optionalFieldDoc(
			"For a user from a remote server, the domain of their home server."
		)
	FieldDef("screen_name", type: .string)
		.optionalFieldDoc("""
			The profile URL a.k.a. the username.
			If the user doesn’t have one set, defaults to `idXXX`.
			""")
	statusField("user")

	FieldDef("url", type: .url)
		.optionalFieldDoc("""
			The URL of this user’s profile page on the web.
			For remote users, this points to their home server.
			""")

	FieldDef("nickname", type: .string)
		.optionalFieldDoc("User’s nickname or middle name")
	FieldDef("maiden_name", type: .string)
		.optionalFieldDoc("User’s maiden name.")

	let genderDef = EnumDef<String>("Gender") {
		EnumCaseDef("other")
			.doc("They/them.")
		EnumCaseDef("female")
			.doc("She/her.")
		EnumCaseDef("male")
			.doc("He/him.")
	}
	.frozen()

	FieldDef("sex", type: .def(genderDef))
		.optionalFieldDoc("""
			User’s preferred grammatical gender, to choose pronouns
			in strings that refer to them.
			""")
	genderDef

	FieldDef("bdate", type: TypeRef(name: "Birthday"))
		.swiftName("birthday")
		.optionalFieldDoc("User’s birth date as `DD.MM.YYYY` or `DD.MM`.")

	FieldDef("home_town", type: .string)
		.optionalFieldDoc("User’s hometown.")

	let relationDoc = "User’s relationship status."

	FieldDef("relation", type: TypeRef(name: "RelationshipStatus"))
		.optionalFieldDoc(relationDoc)
	EnumDef<String>("RelationshipStatus") {
		EnumCaseDef("single")
			.doc("Single")
		EnumCaseDef("in_relationship")
			.doc("In a relationship")
		EnumCaseDef("engaged")
			.doc("Engaged")
		EnumCaseDef("married")
			.doc("Married")
		EnumCaseDef("complicated")
			.doc("It’s complicated")
		EnumCaseDef("actively_searching")
			.doc("Actively searching")
		EnumCaseDef("in_love")
			.doc("In love")
	}
	.doc(relationDoc)

	let relationPartnerDoc = """
		User’s relationship partner.
		Returned when the ``Field/relation`` field is requested.
		"""

	FieldDef("relation_partner", type: TypeRef(name: "RelationshipPartner"))
		.excludeFromFields()
		.doc(relationPartnerDoc)
	StructDef("RelationshipPartner") {
		FieldDef("id", type: .def(userID))
			.required()
			.doc("Partner’s ID.")
		FieldDef("first_name", type: .string)
			.required()
			.doc("Partner’s first name.")
		FieldDef("last_name", type: .string)
			.doc("Partner’s last name.")
	}
	.doc(relationPartnerDoc)

	FieldDef("custom", type: .array(TypeRef(name: "CustomProfileField")))
		.swiftName("customProfileFields")
		.optionalFieldDoc("""
			User-defined profile fields that some fediverse software
			like Mastodon allows specifying.
			""")
	StructDef("CustomProfileField") {
		FieldDef("name", type: .string)
			.required()
			.doc("The field name specified by the user.")
		FieldDef("value", type: .string)
			.required()
			.doc("The field value as HTML.")
	}

	FieldDef("city", type: .string)
		.doc("User’s current city.")

	let connectionsStruct = StructDef("Connections") {
		let fields: [(String, String)] = [
			("matrix", "User’s Matrix username."),
			("xmpp", "User’s XMPP/Jabber handle."),
			("telegram", "User’s Telegram username."),
			("signal", "User’s Signal username or URL."),
			("twitter", "User’s Twitter username."),
			("instagram", "User’s Instagram username."),
			("facebook", "User’s Facebook username."),
			("vkontakte", "User’s VKontakte username."),
			("snapchat", "User’s Snapchat username."),
			("discord", "User’s Discord username."),
			("mastodon", "User’s Mastodon username."),
			("pixelfed", "User’s Pixelfed username."),
			("phone_number", "User’s phone number."),
			("email", "User’s email address."),
		]
		for (field, doc) in fields {
			FieldDef(field, type: .string)
				.doc(doc)
		}

		FieldDef("git", type: .url)
			.doc("GitHub, GitLab, or other Git forge URL.")
	}
	.doc("User’s contact information.")

	FieldDef("connections", type: .def(connectionsStruct))
		.optionalFieldDoc(connectionsStruct.doc)
	connectionsStruct

	FieldDef("site", type: .url)
		.optionalFieldDoc("User’s personal website.")

	let aboutFields: [(String, String)] = [
		("activities", "User’s activities."),
		("interests", "User’s interests."),
		("music", "User’s favorite music."),
		("movies", "User’s favorite movies."),
		("tv", "User’s favorite TV shows."),
		("books", "User’s favorite books."),
		("games", "User’s favorite games."),
		("quotes", "User’s favorite quotes."),
		("about", "User’s about field as HTML."),
	]

	for (name, doc) in aboutFields {
		FieldDef(name, type: .string)
			.optionalFieldDoc(doc)
	}

	let personalDoc = "User’s personal views."

	FieldDef("personal", type: TypeRef(name: "PersonalViews"))
		.optionalFieldDoc(personalDoc)

	StructDef("PersonalViews") {
		FieldDef("political", type: TypeRef(name: "PoliticalViews"))
			.doc("Political views.")
		FieldDef("religion", type: .string)
			.doc("Religious views.")
		FieldDef("inspired_by", type: .string)
			.doc("Sources of inspiration.")
		FieldDef("people_main", type: TypeRef(name: "PeoplePriority"))
			.doc("What this user considers important in others.")
		FieldDef("life_main", type: TypeRef(name: "PersonalPriority"))
			.doc("What this user considers personal priority.")
		FieldDef("smoking", type: TypeRef(name: "HabitsViews"))
			.doc("Views on smoking.")
		FieldDef("alcohol", type: TypeRef(name: "HabitsViews"))
			.doc("Views on alcohol.")
	}
	.doc(personalDoc)

	EnumDef<String>("PoliticalViews") {
		EnumCaseDef("communist")
		EnumCaseDef("socialist")
		EnumCaseDef("moderate")
		EnumCaseDef("liberal")
		EnumCaseDef("conservative")
		EnumCaseDef("monarchist")
		EnumCaseDef("ultraconservative")
		EnumCaseDef("apathetic")
		EnumCaseDef("libertarian")
	}
	EnumDef<String>("PeoplePriority") {
		EnumCaseDef("intellect_creativity")
		EnumCaseDef("kindness_honesty")
		EnumCaseDef("health_beauty")
		EnumCaseDef("wealth_power")
		EnumCaseDef("courage_persistence")
		EnumCaseDef("humor_life_love")
	}
	EnumDef<String>("PersonalPriority") {
		EnumCaseDef("family_children")
		EnumCaseDef("career_money")
		EnumCaseDef("entertainment_leisure")
		EnumCaseDef("science_research")
		EnumCaseDef("improving_world")
		EnumCaseDef("personal_development")
		EnumCaseDef("beauty_art")
		EnumCaseDef("fame_influence")
	}
	EnumDef<String>("HabitsViews") {
		EnumCaseDef("very_negative")
		EnumCaseDef("negative")
		EnumCaseDef("tolerant")
		EnumCaseDef("neutral")
		EnumCaseDef("positive")
	}

	FieldDef("online", type: .bool)
		.optionalFieldDoc("Whether the user is currently online.")
	FieldDef("online_mobile", type: .bool)
		.excludeFromFields()
		.doc("""
			Whether the user is currently online from a mobile device.
			Request by passing ``Field/online``.
			""")

	let lastSeenDoc = """
		If the user is currently offline, information about when they
		were last online.
		"""

	FieldDef("last_seen", type: TypeRef(name: "LastSeen"))
		.optionalFieldDoc(lastSeenDoc)
	StructDef("LastSeen") {
		FieldDef("time", type: .unixTimestamp)
			.required()
			.doc("Last seen time.")
		FieldDef("platform", type: TypeRef(name: "Platform"))
			.required()
			.doc("What kind of device the user last used to go online.")
	}
	.doc(lastSeenDoc)

	FieldDef("blocked", type: .bool)
		.optionalFieldDoc("Whether the current user is blocked by this user.")

	FieldDef("blocked_by_me", type: .bool)
		.optionalFieldDoc("Whether this user is blocked by the current user.")

	FieldDef("can_post", type: .bool)
		.optionalFieldDoc("Whether the current user can post on this user’s wall.")
	FieldDef("can_see_all_posts", type: .bool)
		.optionalFieldDoc("""
			Whether the current user is allowed see all posts on this user’s
			wall, or only this user’s own posts.
			""")
	FieldDef("can_send_friend_request", type: .bool)
		.optionalFieldDoc("""
			If `true`, you can send a friend request to this user.
			If `false`, you can only follow them.
			""")
	FieldDef("can_write_private_message", type: .bool)
		.optionalFieldDoc("""
			Whether the current user is allowed send private messages to this
			user.
			""")

	FieldDef("mutual_count", type: .int)
		.optionalFieldDoc("""
			The number of mutual friends between this user and the current user.
			""")

	FieldDef("friend_status", type: TypeRef(name: "FriendStatus"))
		.optionalFieldDoc("The relationship between this user and the current user.")
	EnumDef<String>("FriendStatus") {
		EnumCaseDef("none")
			.doc("No relationship.")
		EnumCaseDef("following")
			.doc("The current user is following this user.")
		EnumCaseDef("followed_by")
			.doc("This user is following the current user.")
		EnumCaseDef("friends")
			.doc("The users are friends (they follow each other).")
		EnumCaseDef("follow_requested")
			.doc("""
				Only for remote users – the current user tried to follow this
				user, but their server hasn’t yet accepted that request
				""")
	}

	FieldDef("is_friend", type: .bool)
		.optionalFieldDoc("Whether this user and the current user are friends.")
	FieldDef("is_favorite", type: .bool)
	FieldDef("lists", type: TypeRef(name: "[FriendListID]"))
		.optionalFieldDoc("""
			The current user’s friend list IDs that this user is in.
			Private lists are excluded unless the token has the `friends:read`
			permission.
			""")
	FieldDef("is_hidden_from_feed", type: .bool)
		.optionalFieldDoc("""
			Whether this user is hidden from the current user’s friends news feed.
			""")

	FieldDef("followers_count", type: .int)
	FieldDef("is_no_index", type: .bool)
		.optionalFieldDoc("""
			Whether this user prefers their profile to not be indexed by search
			engines.
			""")
	FieldDef("wall_default", type: TypeRef(name: "WallMode"))
		.optionalFieldDoc("How this user’s wall should be displayed by default.")

	EnumDef<String>("WallMode") {
		EnumCaseDef("owner")
			.doc("Show only the user's own posts")
		EnumCaseDef("all")
			.doc("Show all posts")
	}.frozen()

	profilePictureFields("user")

	FieldDef("timezone", type: .timeZone)

	let slavicCases: [(String, String)] = [
		("nom", "nominative"),
		("gen", "genitive"),
		("dat", "dative"),
		("acc", "accusative"),
		("ins", "instrumental"),
		("pre", "prepositional"),
	]
	for (`case`, caseDoc) in slavicCases {
		FieldDef("first_name_\(`case`)", type: .string)
			.optionalFieldDoc("First name in \(caseDoc) case")
		FieldDef("nickname_\(`case`)", type: .string)
			.optionalFieldDoc("Middle name in \(caseDoc) case")
		FieldDef("last_name_\(`case`)", type: .string)
			.optionalFieldDoc("Last name name in \(caseDoc) case")
	}

	FieldDef("counters", type: TypeRef(name: "Counters"))

	StructDef("Counters") {
		let fields = [
			"albums",
			"photos",
			"friends",
			"groups",
			"online_friends",
			"mutual_friends",
			"user_photos",
			"followers",
			"subscriptions",
		]
		for name in fields {
			FieldDef(name, type: .int).required()
		}
	}

	let roleEnum = EnumDef<String>("GroupRole") {
		EnumCaseDef("creator")
		EnumCaseDef("administrator")
		EnumCaseDef("moderator")
	}
	FieldDef("role", type: .def(roleEnum))
		.excludeFromFields()
		.doc("""
			Returned by the ``Groups/GetMembers`` method.
			""")
	roleEnum

	StructDef("GroupAdmin") {
		FieldDef("id", type: .def(userID))
			.required()
		FieldDef("role", type: .def(roleEnum))
			.required()
	}
}
.generateFieldsStruct()

extension Documentable {
	fileprivate func optionalFieldDoc(_ text: String?) -> Self {
		optionalFieldDoc(text, objectName: "User")
	}
}
