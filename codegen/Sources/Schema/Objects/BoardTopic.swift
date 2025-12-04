let boardTopic = StructDef("BoardTopic") {
	FieldDef("id", type: .def(boardTopicID))
		.required()
		.id()
		.doc("Unique (server-wide) identifier of this topic.")
	
	FieldDef("group_id", type: .def(groupID))
		.required()
		.doc("Identifier of the group in which this topic exists.")
	
	activityPubIDField("topic")

	FieldDef("url", type: .url)
		.required()
		.doc("""
			The URL of the web page representing this topic.
			For topics in remote groups, points to the group’s home server.
			""")
	
	FieldDef("title", type: .string)
		.required()
		.doc("The title of this topic.")
	
	FieldDef("created", type: .unixTimestamp)
		.required()
		.doc("The timestamp when this topic was created.")
	
	FieldDef("created_by", type: .def(userID))
		.required()
		.doc("Identifier of the user who created this topic.")
	
	FieldDef("updated", type: .unixTimestamp)
		.required()
		.doc("The timestamp when someone last posted in this topic.")
	
	FieldDef("updated_by", type: .def(userID))
		.required()
		.doc("Identifier of the user who last posted in this topic.")
	
	FieldDef("is_closed", type: .bool)
		.required()
		.doc("Whether this topic is closed so no further posts can be made.")
	
	FieldDef("is_pinned", type: .bool)
		.required()
		.doc("Whether this topic is pinned at the top of the discussion board.")
	
	FieldDef("comments", type: .int)
		.required()
		.doc("The total number of posts in this topic.")
	
	FieldDef("comment_preview", type: .string)
		.doc("The first or last post text preview returned by some methods.")
}
.doc("Represents a topic in a group’s discussion board.")