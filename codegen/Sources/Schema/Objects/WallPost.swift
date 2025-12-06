let wallPost = StructDef("WallPost") {
	FieldDef("id", type: .def(wallPostID))
		.required()
		.id()
		.doc("Unique (server-wide) identifier of this post.")
	
	FieldDef("owner_id", type: .def(actorID))
		.required()
		.doc("Identifier of the wall owner, either user ID or minus group ID.")
	
	FieldDef("from_id", type: .def(actorID))
		.required()
		.doc("Identifier of the user who made this post.")
	
	activityPubIDField("post")

	FieldDef("url", type: .url)
		.required()
		.doc("""
			The URL of the web page representing this post.
			For posts made by remote users, points to their home server.
			""")
	
	FieldDef("date", type: .unixTimestamp)
		.required()
		.doc("The timestamp when this post was published, as unixtime.")
	
	FieldDef("text", type: .string)
		.doc("""
			The text of the post as HTML.
			[More about text formatting.](https://smithereen.software/docs/api/text-formatting)
			""")
	
	let privacyEnum = EnumDef<String>("Privacy") {
		EnumCaseDef("followers")
		EnumCaseDef("followers_and_mentioned")
		EnumCaseDef("friends")
	}
	
	FieldDef("privacy", type: .def(privacyEnum))
		.doc("If this post isn’t publicly visible, the visibility setting specified by the author.")
	privacyEnum

	FieldDef("likes", type: .def(likes))
		.doc("Information about likes of this post.")
	
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

	FieldDef("attachments", type: .array(.def(attachment)))
		.doc("Media attachments added to this post.")
	
	FieldDef("content_warning", type: .string)
		.doc("""
			The content warning text, if any. If this field is present,
			hide the post content, replacing it with this text, and only reveal
			it after an extra click or tap.
			""")
	
	FieldDef("can_delete", type: .bool)
		.required()
		.doc("Whether the current user can delete this post.")
	
	FieldDef("can_edit", type: .bool)
		.required()
		.doc("Whether the current user can edit this post.")
	
	FieldDef("mentioned_users", type: .array(.def(actorID)))
		.doc("""
			An array of user IDs corresponding to users mentioned in this post.
			""")
	
	let commentsStruct = StructDef("Comments") {
		FieldDef("count", type: .int)
			.required()
			.doc("The total number of comments.")
		
		FieldDef("can_post", type: .bool)
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
	
	FieldDef("parents_stack", type: .array(.def(wallPostID)))
		.commentDoc("Array of identifiers of parent comments.")
	
	FieldDef("reply_to_comment", type: .def(wallPostID))
		.commentDoc(
			"Identifier of the comment this is in reply to, if applicable."
		)
	
	FieldDef("reply_to_user", type: .def(actorID))
		.commentDoc(
			"Identifier of the user this is in reply to, if applicable."
		)
	
	let threadStruct = StructDef("Thread") {
		FieldDef("count", type: .int)
			.required()
			.doc("The total number of comments in this branch.")
		
		FieldDef("reply_count", type: .int)
			.required()
			.doc("The total number of replies to this comment.")
		
		FieldDef("items", type: .array(TypeRef(name: "WallPost")))
			.required()
			.doc("The replies to this comment.")
	}
	FieldDef("thread", type: .def(threadStruct))
		.commentDoc("""
			An object describing the reply thread of this comment.
			Only returned when `view_type` is `threaded` or `two_level`.
			""")
	threadStruct
}
.doc("A post or a comment on a wall.")

extension Documentable {
	fileprivate func topLevelPostDoc(_ text: String) -> Self {
		doc("""
			\(text)

			- Note: Only returned for top-level posts.
			""")
	}

	fileprivate func commentDoc(_ text: String) -> Self {
		doc("""
			\(text)

			- Note: Only returned for comments.
			""")
	}
}
