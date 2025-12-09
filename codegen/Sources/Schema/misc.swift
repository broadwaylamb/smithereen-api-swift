let userID = IdentifierStruct("UserID", rawValue: .int)
let groupID = IdentifierStruct("GroupID", rawValue: .int)
let actorID = IdentifierStruct("ActorID", rawValue: .int)
	.doc("Represents either ``UserID`` or ``GroupID``.")
let friendListID = IdentifierStruct("FriendListID", rawValue: .int)
let photoID = IdentifierStruct("PhotoID", rawValue: .string)
let albumID = IdentifierStruct("AlbumID", rawValue: .string)
let serverRuleID = IdentifierStruct("ServerRuleID", rawValue: .int)
let groupLinkID = IdentifierStruct("GroupLinkID", rawValue: .int)
let pollID = IdentifierStruct("PollID", rawValue: .int)
let pollOptionID = IdentifierStruct("PollOptionID", rawValue: .int)
let boardTopicID = IdentifierStruct(("BoardTopicID"), rawValue: .string)
let wallPostID = IdentifierStruct("WallPostID", rawValue: .int)
let photoCommentID = IdentifierStruct("PhotoCommentID", rawValue: .string)
let topicCommentID = IdentifierStruct("TopicCommentID", rawValue: .string)
let photoFeedEntryID = IdentifierStruct("PhotoFeedEntryID", rawValue: .string)

let serverRule = StructDef("ServerRule") {
	FieldDef("id", type: TypeRef(name: "ServerRuleID"))
		.required()
		.id()
	
	FieldDef("title", type: .string)
		.required()
		
	FieldDef("description", type: .string)
}

let serverSignupMode = EnumDef<String>("ServerSignupMode") {
	EnumCaseDef("open")
	EnumCaseDef("closed")
	EnumCaseDef("invite_only")
	EnumCaseDef("manual_approval")
}

let deactivatedStatus = EnumDef<String>("DeactivatedStatus") {
	EnumCaseDef("banned")
		.doc("The user's account or the group is frozen or suspended.")
	EnumCaseDef("hidden")
		.doc("""
			The server staff made this profile/group only visible to
			authenticated users.
			""")
	EnumCaseDef("deleted")
		.doc("""
			The user has deleted their own profile,
			or the group was deleted by its creator.
			""")
}
.doc("""
	For restricted users and groups, their restriction status.
	""")

let likeInfo = StructDef("LikeInfo") {
	FieldDef("count", type: .int)
		.required()
		.doc("How many users liked this object.")
	FieldDef("can_like", type: .bool)
		.required()
		.doc("Whether the current user can like this object.")
	FieldDef("user_likes", type: .bool)
		.excludeFromFields()
		.doc("Whether the current user likes this photo.")
}

let platform = EnumDef<String>("Platform") {
    EnumCaseDef("mobile", additionalRepresentation: 1)
    EnumCaseDef("desktop", additionalRepresentation: 7)
}

let communityType = EnumDef<String>("CommunityType") {
	EnumCaseDef("groups")
	EnumCaseDef("events")
}

let actorField = EnumDef<String>("ActorField") {
	let cases = (user.requestableFieldCases + group.requestableFieldCases)
		.distinct(by: \.swiftName)
	
	for `case` in cases {
		`case`
	}
}

let commentView = EnumDef<String>("CommentView") {
	EnumCaseDef("threaded")
	EnumCaseDef("two_level")
	EnumCaseDef("flat")
}
.frozen()

func deactivatedStatusField(_ entity: String) -> FieldDef {
	FieldDef("deactivated", type: .def(deactivatedStatus))
		.excludeFromFields()
		.doc("""
			For restricted \(entity)s, their restriction status.
			If this is set, none of the optional fields will be returned.
			""")
}

func activityPubIDField(_ entity: String) -> FieldDef {
	FieldDef("ap_id", type: .url)
		.excludeFromFields()
		.swiftName("activityPubID")
		.doc(
			"""
			Globally unique ActivityPub identifier for this \(entity).
			Use this to match \(entity)s across servers.

			Always non-nil for Smithereen, always nil for OpenVK
			""")
}

func statusField(_ entity: String) -> FieldDef {
	FieldDef("status", type: .string)
		.optionalFieldDoc("""
			The status string, the one that’s displayed under the \(entity)’s
			name on the web.
			""", objectName: entity.capitalized)
}

@StructDefBuilder
func profilePictureFields(_ entity: String) -> any StructDefPart {
	for size in photoSizes(50, 100, 200, 400, .max) {
		let doc = size == "max" 
			? nil 
			: "URL of a square \(size)x\(size) version of the profile picture."
		FieldDef("photo_\(size)", type: .url)
			.optionalFieldDoc(doc, objectName: entity.capitalized)
	}

	for size in photoSizes(200, 400, .max) {
		let doc = size == "max"
			? nil
			: "URL of a rectangular \(size)px wide version of the profile picture."
		FieldDef("photo_\(size)_orig", type: .url)
			.optionalFieldDoc(doc, objectName: entity.capitalized)
	}

	FieldDef("photo_id", type: .def(photoID))
		.optionalFieldDoc("""
			If this \(entity) has a “profile pictures” system photo album,
			ID of the photo used for the current profile picture in that album.
			""", objectName: entity.capitalized)
}

func photoSizes(_ s: Int...) -> [String] {
	s.map {
		if $0 == .max {
			return "max"
		} else {
			return String($0)
		}
	}
}

extension Documentable {
	func optionalFieldDoc(_ text: String?, objectName: String) -> Self {
		guard let text else { return self }
		return self.doc("""
			\(text)

			- Note: This is an **optional** field.
			Request it by passing it in `fields` to any method that returns
			``\(objectName)`` objects.
			""")
	}
}

func blurhashField() -> FieldDef {
	FieldDef("blurhash", type: .blurhash)
        .doc("The [BlurHash](https://blurha.sh/) for the thumbnail.")
}

@StructDefBuilder
func offsetAndCountParams(
	_ entity: String,
	defaultCount: Int
) -> any StructDefPart {
	FieldDef("offset", type: .int)
		.doc("Offset into the \(entity) list for pagination.")
	
	FieldDef("count", type: .int)
		.doc("How many \(entity)s to return. By default \(defaultCount).")
}

extension RequestDef {
	func withUserFields() -> RequestDef {
		withExtendedVersion(
			"WithFields",
			extendedResultType: .paginatedList(.def(user)),
		) {
			FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
				.required()
				.doc("A list of user profile fields to be returned.")
		}
	}

	func withGroupFields() -> RequestDef {
		withExtendedVersion(
			"WithFields",
			extendedResultType: .paginatedList(.def(group)), 
		) {
			FieldDef("fields", type: .array(TypeRef(name: "Group.Field")))
				.required()
				.doc("A list of group profile fields to be returned.")
		}
	}
}
