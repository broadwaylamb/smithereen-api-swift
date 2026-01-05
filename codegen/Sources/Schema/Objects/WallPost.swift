let wallPost = StructDef("WallPost", conformances: [.def(commentProtocol)]) {
	postAndCommentCommonFields(
		entity: "post",
		entityTypeName: "WallPost",
		parentObject: "wall",
		idType: .def(wallPostID),
	) {
		"""
		\($0)

		- Note: Only returned for comments.
		"""
	}

	let privacyEnum = EnumDef<String>("Privacy") {
		EnumCaseDef("followers")
		EnumCaseDef("followers_and_mentioned")
		EnumCaseDef("friends")
	}

	FieldDef("privacy", type: .def(privacyEnum))
		.doc("If this post isn’t publicly visible, the visibility setting specified by the author.")
	privacyEnum

	let repostsStruct = StructDef("Reposts") {
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
	FieldDef("reposts", type: .def(repostsStruct))
		.doc("Information about reposts of this post.")
	repostsStruct

	// TODO: Post source

	let commentsStruct = StructDef("Comments") {
		FieldDef("count", type: .int)
			.required()
			.doc("The total number of comments.")

		FieldDef("can_comment", type: .bool)
			.required()
			.doc("Whether the current user can comment on this post.")
	}
	FieldDef("comments", type: .def(commentsStruct))
		.topLevelPostDoc("Information about comments on this post.")
	commentsStruct

	FieldDef("repost_history", type: .array(TypeRef(name: "WallPost")))
		.topLevelPostDoc("""
			If this is a repost, the array of reposted posts.
			Contains more than one element if the reposted post is itself
			a repost.
			""")

	FieldDef("is_mastodon_style_repost", type: .bool)
		.topLevelPostDoc("""
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
		.topLevelPostDoc(
			"Whether the current user can pin this post to their wall."
		)

	FieldDef("is_pinned", type: .bool)
		.topLevelPostDoc("Whether this post is pinned on its owner’s wall.")
}
.doc("A post or a comment on a wall.")

extension Documentable {
	fileprivate func topLevelPostDoc(_ text: String) -> Self {
		doc("""
			\(text)

			- Note: Only returned for top-level posts.
			""")
	}
}

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
