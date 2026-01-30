let wallPostProtocol = ProtocolDef(
	"WallPostProtocol",
	conformances: StructDef.defaultConformances + [.identifiable],
) {
	wallPostAndCommentCommonFields(
		entity: "post or comment",
		entityTypeName: "Self",
		postOnly: true,
	)
}

let wallPost = StructDef("WallPost", conformances: [.def(wallPostProtocol)]) {
	wallPostAndCommentCommonFields(
		entity: "post",
		entityTypeName: "WallPost",
		postOnly: true,
	)

	EnumDef<String>("Privacy") {
		EnumCaseDef("followers")
		EnumCaseDef("followers_and_mentioned")
		EnumCaseDef("friends")
	}

	StructDef("Reposts") {
		FieldDef("count", type: .int)
			.required()
			.doc("How many reposts of this post were made.")

		FieldDef("can_repost", type: .bool)
			.required()
			.doc("Whether the current user can repost this post.")

		FieldDef("user_reposted", type: .bool)
			.required()
			.doc("Whether the current user has reposted this post.")
	}

	StructDef("Source") {
		let appDef = StructDef("Application") {
			FieldDef("id", type: .def(applicationID))
				.required()
				.doc("Unique (server-wide) identifier of the app.")

			activityPubIDField("app")

			FieldDef("name", type: .string)
				.required()
				.doc("The user-visible name of the app.")
		}
		FieldDef("app", type: .def(appDef))
			.doc("""
				If this post was published using the API, information about
				the app that was used.
				""")
		appDef

		let actionDef = EnumDef<String>("Action") {
			EnumCaseDef("profile_picture_update")
				.doc("The user has uploaded a new profile picture.")
		}
		FieldDef("action", type: .def(actionDef))
			.doc("""
				If this post was created as part of another user action,
				the type of that action.
				""")
		actionDef
	}

	let commentsStruct = StructDef("Comments") {
		FieldDef("count", type: .int)
			.required()
			.doc("The total number of comments.")

		FieldDef("can_comment", type: .bool)
			.required()
			.doc("Whether the current user can comment on this post.")
	}
	FieldDef("comments", type: .def(commentsStruct))
		.doc("Information about comments on this post.")
	commentsStruct

	FieldDef("repost_history", type: .array(TypeRef(name: "WallPost")))
		.doc("""
			If this is a repost, the array of reposted posts.
			Contains more than one element if the reposted post is itself
			a repost.
			""")

	FieldDef("is_mastodon_style_repost", type: .bool)
		.doc("""
			If this is a repost, whether this is a Mastodon-style repost
			(`Announce` activity). Mastodon-style reposts work like retweets on
			Twitter – they aren’t “real” posts, they don’t have their own
			comment thread and can’t be interacted with.
			If this is `true`, you should forward all user interactions,
			like comments or likes, to the reposted post (`repost_history[0]`).
			It’s also recommended display such posts with some indication in
			the UI that the user will interact with the original post.
			""")

	FieldDef("can_pin", type: .bool)
		.doc("Whether the current user can pin this post to their wall.")

	FieldDef("is_pinned", type: .bool)
		.doc("Whether this post is pinned on its owner’s wall.")
}
.doc("A post on a wall.")

let wallComment = StructDef(
	"WallComment",
	conformances: [.def(wallPostProtocol), .def(commentProtocol)],
) {
	wallPostAndCommentCommonFields(
		entity: "comment",
		entityTypeName: "WallComment",
		postOnly: false,
	)
}
.doc("A comment under a post on a wall.")

let wallPostFeedUpdate = StructDef("WallPostNewsfeedUpdate") {
	FieldDef("post", type: .def(wallPost))
		.required()

	let matchedFilterDef = StructDef("MatchedFilter") {
		FieldDef("id", type: .def(wordFilterID))
			.id()
			.required()
			.doc("Identifier of the filter.")
		FieldDef("name", type: .string)
			.required()
			.doc("Name of the filter.")
		FieldDef("expiry_date", type: .unixTimestamp)
			.doc("If the filter expires, the time when it does.")
	}

	FieldDef("matched_filter", type: .def(matchedFilterDef))
		.doc("""
			If any word filter has matched the post, information about
			that filter.
			""")

	matchedFilterDef
}

@FieldContainerBuilder
private func wallPostAndCommentCommonFields(
	entity: String,
	entityTypeName: String,
	postOnly: Bool,
) -> any FieldContainerPart {
	postAndCommentCommonFields(
		entity: entity,
		entityTypeName: entityTypeName,
		parentObject: "wall",
		idType: .def(wallPostID),
		postOnly: postOnly,
	)

	FieldDef("privacy", type: TypeRef(name: "WallPost.Privacy"))
		.doc("If this post isn’t publicly visible, the visibility setting specified by the author.")

	FieldDef("reposts", type: TypeRef(name: "WallPost.Reposts"))
		.doc("Information about reposts of this post.")

	FieldDef("post_source", type: TypeRef(name: "WallPost.Source"))
		.doc("Information about how this post was created.")
}
