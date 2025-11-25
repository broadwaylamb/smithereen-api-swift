let user = StructDef("User") {
	FieldDef("id", type: .userID)
		.id()
		.required()
		.doc("Unique (within the server) identifier for this user. A positive integer.")

	FieldDef("first_name", type: .string)
		.required()
		.doc("User’s first name.")

	FieldDef("last_name", type: .string)
		.excludeFromFields()
		.doc("User’s last name.")

	let deactivatedStatusDoc = """
	For restricted users, their restriction status.
	If this is set, none of the optional fields will be returned.
	"""

	FieldDef("deactivated", type: TypeRef(name: "DeactivatedStatus"))
		.excludeFromFields()
		.doc(deactivatedStatusDoc)

	EnumDef("DeactivatedStatus") {
		EnumCaseDef("banned")
			.doc("The user’s account is frozen or suspended.")
		EnumCaseDef("hidden")
			.doc("The user has deleted their own profile.")
		EnumCaseDef("deleted")
			.doc("The server staff made this profile only visible to authenticated users.")
	}
	.doc(deactivatedStatusDoc)

	FieldDef("ap_id", type: .url)
		.swiftName("activityPubID")
		.doc(
			"""
			Globally unique ActivityPub identifier for this user.
			Use this to match users across servers.

			Always non-nil for Smithereen, always nil for OpenVK
			""")
		.excludeFromFields()

	FieldDef("domain", type: .string)
		.optionalFieldDoc(
			"For a user from a remote server, the domain of their home server."
		)
	FieldDef("screen_name", type: .string)
		.optionalFieldDoc("""
			The profile URL a.k.a. the username. \
			If the user doesn’t have one set, defaults to `idXXX`.
			""")
	FieldDef("status", type: .string)
		.optionalFieldDoc("""
			The status string, the one that’s displayed under the user’s
			name on the web.
			""")

	FieldDef("url", type: .url)
		.optionalFieldDoc("""
			The URL of this user’s profile page on the web.
			For remote users, this points to their home server.
			""")

	FieldDef("nickname", type: .string)
		.optionalFieldDoc("User’s nickname or middle name")
	FieldDef("maiden_name", type: .string)
		.optionalFieldDoc("User’s maiden name.")

	FieldDef("sex", type: TypeRef(name: "Gender"))
		.optionalFieldDoc("""
			User’s preferred grammatical gender, to choose pronouns
			in strings that refer to them.
			""")
	EnumDef("Gender") {
		EnumCaseDef("other", additionalRepresentation: 0)
		EnumCaseDef("female", additionalRepresentation: 1)
		EnumCaseDef("male", additionalRepresentation: 2)
	}

	FieldDef("bdate", type: TypeRef(name: "Birthday"))
		.swiftName("birthday")
		.optionalFieldDoc("User’s birth date as `DD.MM.YYYY` or `DD.MM`.")

	FieldDef("home_town", type: .string)
		.optionalFieldDoc("User’s hometown.")
	
	let relationDoc = "User’s relationship status."

	FieldDef("relation", type: TypeRef(name: "RelationshipStatus"))
		.optionalFieldDoc(relationDoc)
	EnumDef("RelationshipStatus") {
		EnumCaseDef("single", additionalRepresentation: 1)
			.doc("Single")
		EnumCaseDef("in_relationship", additionalRepresentation: 2)
			.doc("In a relationship")
		EnumCaseDef("engaged", additionalRepresentation: 3)
			.doc("Engaged")
		EnumCaseDef("married", additionalRepresentation: 4)
			.doc("Married")
		EnumCaseDef("complicated", additionalRepresentation: 5)
			.doc("It’s complicated")
		EnumCaseDef("actively_searching", additionalRepresentation: 6)
			.doc("Actively searching")
		EnumCaseDef("in_love", additionalRepresentation: 7)
			.doc("In love")
		EnumCaseDef("in_civil_marriage", additionalRepresentation: 8)
			.doc("In civil marriage. OpenVK only, not supported in Smithereen")
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
		FieldDef("id", type: .userID)
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

	let contactFields: [(String, String)] = [
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

	for (name, doc) in contactFields {
		FieldDef(name, type: .string)
			.excludeFromFields()
			.connectionsDoc(doc)
	}

	FieldDef("git", type: .url)
		.connectionsDoc("User’s GitHub, GitLab, or other Git forge URL.")
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

	EnumDef("PoliticalViews") {
		EnumCaseDef("communist", additionalRepresentation: 1)
		EnumCaseDef("socialist", additionalRepresentation: 2)
		EnumCaseDef("moderate", additionalRepresentation: 3)
		EnumCaseDef("liberal", additionalRepresentation: 4)
		EnumCaseDef("conservative", additionalRepresentation: 5)
		EnumCaseDef("monarchist", additionalRepresentation: 6)
		EnumCaseDef("ultraconservative", additionalRepresentation: 7)
		EnumCaseDef("apathetic", additionalRepresentation: 8)
		EnumCaseDef("libertarian", additionalRepresentation: 9)
	}
	EnumDef("PeoplePriority") {
		EnumCaseDef("intellect_creativity", additionalRepresentation: 1)
		EnumCaseDef("kindness_honesty", additionalRepresentation: 2)
		EnumCaseDef("health_beauty", additionalRepresentation: 3)
		EnumCaseDef("wealth_power", additionalRepresentation: 4)
		EnumCaseDef("courage_persistence", additionalRepresentation: 5)
		EnumCaseDef("humor_life_love", additionalRepresentation: 6)
	}
	EnumDef("PersonalPriority") {
		EnumCaseDef("family_children", additionalRepresentation: 1)
		EnumCaseDef("career_money", additionalRepresentation: 2)
		EnumCaseDef("entertainment_leisure", additionalRepresentation: 3)
		EnumCaseDef("science_research", additionalRepresentation: 4)
		EnumCaseDef("improving_world", additionalRepresentation: 5)
		EnumCaseDef("personal_development", additionalRepresentation: 6)
		EnumCaseDef("beauty_art", additionalRepresentation: 7)
		EnumCaseDef("fame_influence", additionalRepresentation: 8)
	}
	EnumDef("HabitsViews") {
		EnumCaseDef("very_negative", additionalRepresentation: 1)
		EnumCaseDef("negative", additionalRepresentation: 2)
		EnumCaseDef("tolerant", additionalRepresentation: 3)
		EnumCaseDef("neutral", additionalRepresentation: 4)
		EnumCaseDef("positive", additionalRepresentation: 5)
	}

	FieldDef("online", type: .bool)
		.optionalFieldDoc("Whether the user is currently online.")
	FieldDef("online_mobile", type: .bool)
		.excludeFromFields()
		.doc("""
			Whether the user is currently online from a mobile device.
			Request by passing ``Fields/online``.
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
		.alternativeNames("blacklisted")
		.optionalFieldDoc("Whether the current user is blocked by this user.")

	FieldDef("blocked_by_me", type: .bool)
		.alternativeNames("blacklisted_by_me")
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
	EnumDef("FriendStatus") {
		EnumCaseDef("none", additionalRepresentation: 0)
			.doc("No relationship.")
		EnumCaseDef("following", additionalRepresentation: 1)
			.doc("The current user is following this user.")
		EnumCaseDef("followed_by", additionalRepresentation: 2)
			.doc("This user is following the current user.")
		EnumCaseDef("friends", additionalRepresentation: 3)
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

	EnumDef("WallMode") {
		EnumCaseDef("owner")
			.doc("Show only the user's own posts")
		EnumCaseDef("all")
			.doc("Show all posts")
	}.frozen()

	for size in photoSizes(50, 100, 200, 400, .max) {
		let doc = size == "max" 
			? nil 
			: "URL of a square \(size)x\(size) version of the profile picture."
		FieldDef("photo_\(size)", type: .url)
			.optionalFieldDoc(doc)
	}

	for size in photoSizes(200, 400, .max) {
		let doc = size == "max"
			? nil
			: "URL of a rectangular \(size)px wide version of the profile picture."
		FieldDef("photo_\(size)_orig", type: .url)
			.optionalFieldDoc(doc)
	}

	FieldDef("photo_id", type: TypeRef(name: "PhotoID"))
		.optionalFieldDoc("""
			If this user has a “profile pictures” system photo album,
			ID of the photo used for the current profile picture in that album.
			""")

	FieldDef("timezone", type: .timeZone)

	let slavicCases: [(String, String)] = [
		("nom", "nominative"),
		("gen", "genitive"),
		("dat", "dative"),
		("acc", "accusative"),
		("ins", "instrumental"),
		("abl", "prepositional"),
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
		.alternativeNames("correct_counters")
		
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
}
.generateFieldsStruct()

private func photoSizes(_ s: Int...) -> [String] {
	s.map {
		if $0 == .max {
			return "max"
		} else {
			return String($0)
		}
	}
}

extension Documentable {
	fileprivate func optionalFieldDoc(_ text: String?) -> Self {
		guard let text else { return self }
		return self.doc("""
			\(text)

			- Note: This is an **optional** field.
			Request it by passing it in `fields` to any method that returns
			``User`` objects.
			""")
	}

	fileprivate func connectionsDoc(_ text: String) -> Self {
		self.doc("""
			\(text)

			Request by passing ``Field/connections```.
			""")
	}
}