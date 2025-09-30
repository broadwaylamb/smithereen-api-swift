let user = StructDef("User") {
	FieldDef("id", type: .userID)
		.id()
		.required()

	FieldDef("first_name", type: .string)
		.required()

	FieldDef("last_name", type: .string)

	FieldDef("deactivated", type: TypeRef(name: "DeactivatedStatus"))

	EnumDef("DeactivatedStatus") {
		EnumCaseDef("banned")
		EnumCaseDef("hidden")
		EnumCaseDef("deleted")
	}

	FieldDef("ap_id", type: .url)
		.swiftName("activityPubID")
		.doc("Always non-nil for Smithereen, always nil for OpenVK")

	FieldDef("domain", type: .string)
	FieldDef("screen_name", type: .string)
	FieldDef("status", type: .string)
	FieldDef("url", type: .url)

	FieldDef("nickname", type: .string)
	FieldDef("maiden_name", type: .string)

	FieldDef("sex", type: TypeRef(name: "Gender"))
	EnumDef("Gender") {
		EnumCaseDef("other", additionalRepresentation: 0)
		EnumCaseDef("female", additionalRepresentation: 1)
		EnumCaseDef("male", additionalRepresentation: 2)
	}

	FieldDef("bdate", type: TypeRef(name: "Birthday"))
		.swiftName("birthday")

	FieldDef("home_town", type: .string)

	FieldDef("relation", type: TypeRef(name: "RelationshipStatus"))
	EnumDef("RelationshipStatus") {
		EnumCaseDef("single", additionalRepresentation: 1)
		EnumCaseDef("in_relationship", additionalRepresentation: 2)
		EnumCaseDef("engaged", additionalRepresentation: 3)
		EnumCaseDef("married", additionalRepresentation: 4)
		EnumCaseDef("complicated", additionalRepresentation: 5)
		EnumCaseDef("actively_searching", additionalRepresentation: 6)
		EnumCaseDef("in_love", additionalRepresentation: 7)
		EnumCaseDef("in_civil_marriage", additionalRepresentation: 8)
			.doc("OpenVK only, not supported in Smithereen")
	}

	FieldDef("relation_partner", type: TypeRef(name: "RelationshipPartner"))
	StructDef("RelationshipPartner") {
		FieldDef("id", type: .userID).required()
		FieldDef("name", type: .string).required()
	}

	FieldDef("custom", type: TypeRef(name: "[CustomProfileField]"))
		.swiftName("customProfileFields")
	StructDef("CustomProfileField") {
		FieldDef("name", type: .string).required()
		FieldDef("value", type: .string).required()
	}

	FieldDef("city", type: .string)

	let contactFields: [String] = [
		"matrix",
		"xmpp",
		"telegram",
		"signal",
		"twitter",
		"instagram",
		"facebook",
		"vkontakte",
		"snapchat",
		"discord",
		"mastodon",
		"pixelfed",
		"phone_number",
		"email",
	]

	for name in contactFields {
		FieldDef(name, type: .string)
	}

	FieldDef("git", type: .url)
	FieldDef("site", type: .url)

	let aboutFields: [String] = [
		"activities",
		"interests",
		"music",
		"movies",
		"tv",
		"books",
		"games",
		"quotes",
		"about",
	]

	for name in aboutFields {
		FieldDef(name, type: .string)
	}

	FieldDef("personal", type: TypeRef(name: "PersonalViews"))
	StructDef("PersonalViews") {
		FieldDef("political", type: TypeRef(name: "PoliticalViews"))
		FieldDef("religion", type: .string)
		FieldDef("inspired_by", type: .string)
		FieldDef("people_main", type: TypeRef(name: "PeoplePriority"))
		FieldDef("life_main", type: TypeRef(name: "PersonalPriority"))
		FieldDef("smoking", type: TypeRef(name: "HabitsViews"))
		FieldDef("alcohol", type: TypeRef(name: "HabitsViews"))
	}
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
	FieldDef("online_mobile", type: .bool)

	FieldDef("last_seen", type: TypeRef(name: "LastSeen"))
	StructDef("LastSeen") {
		FieldDef("time", type: .unixTimestamp).required()
		FieldDef("platform", type: TypeRef(name: "Platform")).required()
	}

	FieldDef("blocked", type: .bool)
		.alternativeNames("blacklisted")

	FieldDef("blocked_by_me", type: .bool)
		.alternativeNames("blacklisted_by_me")

	FieldDef("can_post", type: .bool)
	FieldDef("can_see_all_posts", type: .bool)
	FieldDef("can_send_friend_request", type: .bool)
	FieldDef("can_write_private_message", type: .bool)

	FieldDef("mutual_count", type: .int)

	FieldDef("friend_status", type: TypeRef(name: "FriendStatus"))
	EnumDef("FriendStatus") {
		EnumCaseDef("none", additionalRepresentation: 0)
		EnumCaseDef("following", additionalRepresentation: 1)
		EnumCaseDef("followed_by", additionalRepresentation: 2)
		EnumCaseDef("friends", additionalRepresentation: 3)
		EnumCaseDef("follow_requested")
	}

	FieldDef("is_friend", type: .bool)
	FieldDef("is_favorite", type: .bool)
	FieldDef("lists", type: TypeRef(name: "[FriendListID]"))
	FieldDef("is_hidden_from_feed", type: .bool)

	FieldDef("followers_count", type: .int)
	FieldDef("is_no_index", type: .bool)
	FieldDef("wall_default", type: TypeRef(name: "WallMode"))

	EnumDef("WallMode") {
		EnumCaseDef("owner")
		EnumCaseDef("all")
	}.frozen()

	for size in photoSizes(50, 100, 200, 400, .max) {
		FieldDef("photo_\(size)", type: .url)
	}

	for size in photoSizes(200, 400, .max) {
		FieldDef("photo_\(size)_orig", type: .url)
	}

	FieldDef("photo_id", type: TypeRef(name: "PhotoID"))

	FieldDef("timezone", type: .timeZone)

	let slavicCases = ["nom", "gen", "dat", "acc", "ins", "abl"]
	for `case` in slavicCases {
		FieldDef("first_name_\(`case`)", type: .string)
		FieldDef("nickname_\(`case`)", type: .string)
		FieldDef("last_name_\(`case`)", type: .string)
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

private func photoSizes(_ s: Int...) -> [String] {
	s.map {
		if $0 == .max {
			return "max"
		} else {
			return String($0)
		}
	}
}
