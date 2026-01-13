let userID = IdentifierStruct("UserID", rawValue: .uint32)
let groupID = IdentifierStruct("GroupID", rawValue: .uint32)
let applicationID = IdentifierStruct("ApplicationID", rawValue: .uint64)
let actorID = IdentifierStruct("ActorID", rawValue: .int32)
	.doc("Represents either ``UserID`` or ``GroupID``.")
let friendListID = IdentifierStruct("FriendListID", rawValue: .uint32)
let photoID = IdentifierStruct("PhotoID", rawValue: .string)
let photoAlbumID = IdentifierStruct("PhotoAlbumID", rawValue: .string)
let serverRuleID = IdentifierStruct("ServerRuleID", rawValue: .int)
let groupLinkID = IdentifierStruct("GroupLinkID", rawValue: .uint64)
let pollID = IdentifierStruct("PollID", rawValue: .uint64)
let pollOptionID = IdentifierStruct("PollOptionID", rawValue: .uint64)
let boardTopicID = IdentifierStruct(("BoardTopicID"), rawValue: .string)
let wallPostID = IdentifierStruct("WallPostID", rawValue: .uint64)
	.doc("An identifier of a wall post or a comment on a wall post.")
let wordFilterID = IdentifierStruct("WordFilterID", rawValue: .uint64)
let photoCommentID = IdentifierStruct("PhotoCommentID", rawValue: .string)
	.doc("And identifier of a comment on a photo in a photo album.")
let topicCommentID = IdentifierStruct("TopicCommentID", rawValue: .string)
	.doc("And identifier of a comment in a discussion board topic.")
let photoFeedEntryID = IdentifierStruct("PhotoFeedEntryID", rawValue: .string)
let photoTagID = IdentifierStruct("PhotoTagID", rawValue: .uint64)
let messageID = IdentifierStruct("MessageID", rawValue: .string)
	.doc("And identifier of a private message.")
let notificationID = IdentifierStruct("NotificationID", rawValue: .uint64)
let uploadedImageID = IdentifierStruct("UploadedImageID", rawValue: .string)
	.doc("""
		The identifier returned by the upload endpoint after
		[uploading the image](https://smithereen.software/docs/api/uploads).
		""")
let uploadedImageHash = IdentifierStruct("UploadedImageHash", rawValue: .string)
	.doc("""
		The hash returned by the upload endpoint after
		[uploading the image](https://smithereen.software/docs/api/uploads).
		""")
let accessToken = IdentifierStruct("AccessToken", rawValue: .string)
	.doc("An access token for performing actions on behalf of a user.")
let imageFormat = EnumDef<String>("ImageFormat") {
	EnumCaseDef("webp")
	EnumCaseDef("jpeg")
}
.doc("In which format you would like images to be returned.")

let serverSignupMode = EnumDef<String>("ServerSignupMode") {
	EnumCaseDef("open")
		.doc("Anyone can freely register on their own.")
	EnumCaseDef("closed")
		.doc("This server does not accept new users.")
	EnumCaseDef("invite_only")
		.doc("""
			New users can only register by an invitation from an existing user.
			""")
	EnumCaseDef("manual_approval")
		.doc("""
			New users can submit requests to the server staff and can only
			register after their request has been accepted.
			""")
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
    EnumCaseDef("mobile")
    EnumCaseDef("desktop")
}

let communityType = EnumDef<String>("CommunityType") {
	EnumCaseDef("groups")
	EnumCaseDef("events")
}

let imageRect = StructDef("ImageRect") {
	FieldDef("x1", type: .double)
		.required()
		.doc("The X coordinate of the top left corner, from 0 to 1.")
	FieldDef("y1", type: .double)
		.required()
		.doc("The Y coordinate of the top left corner, from 0 to 1.")
	FieldDef("x2", type: .double)
		.required()
		.doc("The X coordinate of the bottom right corner, from 0 to 1.")
	FieldDef("y2", type: .double)
		.required()
		.doc("The Y coordinate of the bottom right corner, from 0 to 1.")
}

let wordFilterContext = EnumDef<String>("WordFilterContext") {
	EnumCaseDef("friends")
		.doc("The default (friends) news feed.")
	EnumCaseDef("groups")
		.doc("The groups news feed.")
}

let actorField = EnumDef<String>("ActorField") {
	let cases = (user.requestableFieldCases + group.requestableFieldCases)
		.distinct(by: \.swiftName)

	for `case` in cases {
		`case`
	}
}
.nonexhaustive()

let commentView = EnumDef<String>("CommentView") {
	EnumCaseDef("threaded")
	EnumCaseDef("two_level")
	EnumCaseDef("flat")
}

let photoFeedUpdate = StructDef("PhotoNewsfeedUpdate") {
	FieldDef("count", type: .int)
		.required()
		.doc("How many photos were added or tagged in total.")
	FieldDef("items", type: .array(.def(photo)))
		.required()
		.doc("Up to 10 photo objects.")
	FieldDef("list_id", type: .def(photoFeedEntryID))
		.required()
		.doc("""
			An identifier to retrieve the complete list of photos that
			were added or tagged using ``Photos/GetFeedEntry``.
			""")
}
.doc("The information about photos added to an album or a user was tagged in.")

let textFormat = EnumDef<String>("TextFormat") {
	EnumCaseDef("markdown")
	EnumCaseDef("html")
	EnumCaseDef("plain")
}

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
		.required()
		.excludeFromFields()
		.swiftName("activityPubID")
		.doc(
			"""
			Globally unique ActivityPub identifier for this \(entity).
			Use this to match \(entity)s across servers.
			""")
}

func statusField(_ entity: String) -> FieldDef {
	FieldDef("status", type: .string)
		.optionalFieldDoc("""
			The status string, the one that’s displayed under the \(entity)’s
			name on the web.
			""", objectName: entity.capitalized)
}

let cropPhoto = StructDef("CropPhoto") {
	FieldDef("photo", type: .def(photo))
		.required()
		.doc("A photo object representing the profile photo.")

	FieldDef("crop", type: .def(imageRect))
		.required()
		.doc("""
			An object decribing the coordinates for cropping the photo
			to obtain the medium rectangular version, as used in profiles on
			the desktop website.
			""")

	FieldDef("square_crop", type: .def(imageRect))
		.required()
		.doc("""
			An object decribing the coordinates for cropping the medium
			rectangular crop photo to obtain the small square version.
			""")
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

	FieldDef("has_photo", type: .bool)
		.optionalFieldDoc(
			"Whether this \(entity) has a profile picture.",
			objectName: entity.capitalized,
		)

	FieldDef("crop_photo", type: .def(cropPhoto))
		.optionalFieldDoc("""
			If this \(entity) has a “profile pictures” system photo album,
			information about \(entity == "user" ? "their" : "its") profile photo
			and the coordinates used for cropping it down to the “medium”
			rectangular and “small” square sizes.
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

private func rangeDoc(_ range: some RangeExpression<Int>) -> String {
	var minValue: Int?
	var maxValue: Int?
	if let range = range as? ClosedRange<Int> {
		minValue = range.lowerBound
		maxValue = range.upperBound
	} else if let range = range as? Range<Int> {
		minValue = range.lowerBound
		maxValue = range.upperBound
	} else if let range = range as? PartialRangeFrom<Int> {
		minValue = range.lowerBound
	} else if let range = range as? PartialRangeThrough<Int> {
		maxValue = range.upperBound
	} else if let range = range as? PartialRangeUpTo<Int> {
		maxValue = range.upperBound
	}
	var result = ""
	if let minValue {
		result += "Minumum value: \(minValue)."
	}
	if let maxValue {
		if minValue != nil {
			result += " "
		}
		result += "Maximum value: \(maxValue)."
	}
	return result
}

@StructDefBuilder
func offsetAndCountParams(
	_ entity: String,
	range: some RangeExpression<Int>,
	defaultCount: Int?,
) -> any StructDefPart {
	FieldDef("offset", type: .int)
		.doc("Offset into the \(entity) list for pagination.")

	let byDefault = defaultCount.map { " By default \($0)." } ?? ""

	FieldDef("count", type: .int)
		.doc("""
			How many \(entity)s to return.

			\(rangeDoc(range))\(byDefault)
			""")
}

extension RequestDef {
	func withUserFields() -> RequestDef {
		withExtendedVersion(
			"WithFields",
			extendedResultType: .paginatedList(.def(user)),
		) {
			userFieldsParam().required()
		}
	}

	func withGroupFields() -> RequestDef {
		withExtendedVersion(
			"WithFields",
			extendedResultType: .paginatedList(.def(group)),
		) {
			groupFieldsParam().required()
		}
	}
}

let commentSortOrder = EnumDef<String>("CommentSortOrder") {
	EnumCaseDef("asc")
		.swiftName("ascending")
		.doc("Oldest first.")
	EnumCaseDef("desc")
		.swiftName("descending")
		.doc("Newest first.")
}
.doc("The sort order for the comments.")

let topicCommentPreviewMode = EnumDef<String>("TopicCommentPreviewMode") {
	EnumCaseDef("first")
		.doc("""
			Return the text of the first comment in
			`commentPreview` for each topic
			""")
	EnumCaseDef("last")
		.doc("""
			Return the text of the last comment in
			`commentPreview` for each topic
			""")
	EnumCaseDef("none")
		.doc("Do not return `commentPreview`.")
}

let postEditSource = StructDef("PostEditSource") {
	FieldDef("text", type: .string)
		.doc("The text itself.")
	FieldDef("format", type: .def(textFormat))
		.required()
		.doc("The format of the text.")
	FieldDef("attachments", type: .array(.def(attachmentToCreate)))
		.required()
		.doc("The array of input attachment objects.")
}

let userConnectionsStruct = StructDef("Connections") {
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

let userCityField = FieldDef("city", type: .string)
	.doc("User’s current city.")

func commentsRequest(
	_ name: String,
	commentID: StructDef,
	comment: StructDef,
	targetField: FieldDef,
) -> RequestDef {
	apiMethod(
		name,
		resultType: .paginatedList(
			.def(comment),
			extras: .paginatedListExtrasCommentView,
		)
	) {
		targetField
			.required()

		FieldDef("view_type", type: .def(commentView))
			.doc("""
				How to structure the comments.
				By default uses the user preference.
				If no token is used, defaults to ``CommentView/flat``.
				""")

		FieldDef("offset", type: .int)
			.doc("Offset into the comments.")

		FieldDef("count", type: .int)
			.doc("""
				How many comments to return.
				When ``viewType`` is ``CommentView/threaded`` or
				``CommentView/twoLevel``, how many **top-level** comments
				to return.

				From 1 to 100. By default 20.
				""")

		FieldDef("secondary_count", type: .int)
			.doc("""
				How many replies to return, combined, in all threads, when
				``viewType`` is ``CommentView/threaded`` or
				``CommentView/twoLevel``. Ignored for ``CommentView/flat``.

				From 1 to 100. By default 20.
				""")

		FieldDef("comment_id", type: .def(commentID))
			.doc("""
				To retrieve a reply thread, the identifier of the comment
				whose replies you would like to get.
				**Important**: if you’re displaying comments as two levels,
				you need to pass ``CommentView/flat`` to ``viewType`` when
				loading reply threads.
				""")

		FieldDef("sort", type: .def(commentSortOrder))
			.doc("""
				The sort order for the comments.

				By default ``CommentSortOrder/ascending``.
				""")

		FieldDef("need_likes", type: .bool)
			.doc("Whether to return information about likes.")
	}
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(comment),
		 	extras: .paginatedListExtrasCommentViewWithProfilesAndGroups,
		)
	) {
		FieldDef("extended", type: .bool)
			.required()
			.constantValue("true")

		actorFieldsParam()
	}
}

@StructDefBuilder
func postParameters(postKind: String, bodyFieldName: String = "message") -> any StructDefPart {
	FieldDef(bodyFieldName, type: .string)
		.doc("""
			The text of the \(postKind).
			**Required** if there are no ``attachments``.
			This parameter supports formatted text, the format is
			determined by the ``textFormat`` parameter.
			""")

	FieldDef("text_format", type: .def(textFormat))
		.doc("""
			The format of the \(postKind) text passed in ``\(bodyFieldName)``.
			By default, the user’s preference is used.
			""")

	FieldDef("attachments", type: .array(.def(attachmentToCreate)))
		.json()
		.doc("""
			An array representing the media attachments to be added to this \(postKind).
			**Required** if there is no ``\(bodyFieldName)``.
			""")

	FieldDef("content_warning", type: .string)
		.doc("""
			If this is not empty, make the content of the \(postKind) hidden
			by default, requiring a click to reveal.
			This text will be shown instead of the content.
			""")
}

@StructDefBuilder
func commentCreationParameters(method: String, replyToID: StructDef) -> any StructDefPart {
	FieldDef("reply_to_comment", type: .def(replyToID))
		.doc("Identifier of the comment to reply to.")
	postParameters(postKind: "comment")
	guidField(method: method, entity: "comment")
}

func guidField(method: String, entity: String) -> FieldDef {
	FieldDef("guid", type: .uuid)
		.doc("""
			A unique identifier used to prevent accidental double-posting
			on unreliable connections.
			If ``\(method)`` was previously called with this
			``guid`` in the last hour, no new \(entity) will be created,
			the ID of that previously created \(entity) will be returned
			instead. Recommended for mobile apps.
			""")
}

func userFieldsParam() -> FieldDef {
	FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
		.doc("A list of ``User`` profile fields to be returned.")
}

func groupFieldsParam() -> FieldDef {
	FieldDef("fields", type: .array(TypeRef(name: "Group.Field")))
		.doc("A list of ``Group`` profile fields to be returned.")
}

func actorFieldsParam() -> FieldDef {
	FieldDef("fields", type: .array(.def(actorField)))
		.doc("A list of ``User`` and ``Group`` profile fields to be returned.")
}
