let photoComment = StructDef("PhotoComment") {
	postAndCommentCommonFields(
		entity: "comment",
		entityTypeName: "PhotoComment",
		parentObject: "photo",
		idType: photoCommentID,
	)
}
.doc("A comment on a photo in a photo album.")

let topicComment = StructDef("TopicComment") {
	postAndCommentCommonFields(
		entity: "comment",
		entityTypeName: "TopicComment",
		parentObject: "topic",
		idType: topicCommentID,
	)
}
.doc("A comment in a discussion board topic.")

extension FieldDef {
	fileprivate func docWithTransformation(_ text: String, transformation: (String) -> String) -> FieldDef {
		doc(transformation(text))
	}
}

@StructDefBuilder
func postAndCommentCommonFields(
	entity: String,
	entityTypeName: String,
	parentObject: String,
	idType: StructDef,
	commentOnlyDoc: (String) -> String = { $0 },
 ) -> any StructDefPart {
	FieldDef("id", type: .def(idType))
		.required()
		.id()
		.doc("Unique (server-wide) identifier of this \(entity).")

	FieldDef("owner_id", type: .def(actorID))
		.required()
		.doc("Identifier of the \(parentObject) owner.")

	FieldDef("from_id", type: .def(actorID))
		.required()
		.doc("Identifier of the user who made this \(entity).")

	activityPubIDField(entity)

	FieldDef("url", type: .url)
		.required()
		.doc("""
			The URL of the web page representing this \(entity).
			For \(entity)s made by remote users, points to their home server.
			""")

	FieldDef("date", type: .unixTimestamp)
		.required()
		.doc("The timestamp when this \(entity) was published, as unixtime.")

	FieldDef("text", type: .string)
		.doc("""
			The text of the \(entity) as HTML.
			[More about text formatting](https://smithereen.software/docs/api/text-formatting).
			""")

	FieldDef("likes", type: .def(likeInfo))
		.doc("Information about likes of this \(entity).")

	FieldDef("attachments", type: .array(.def(attachment)))
		.doc("Media attachments added to this \(entity).")

	FieldDef("content_warning", type: .string)
		.doc("""
			The content warning text, if any. If this field is present,
			hide the \(entity) content, replacing it with this text, and only reveal
			it after an extra click or tap.
			""")

	FieldDef("can_delete", type: .bool)
		.required()
		.doc("Whether the current user can delete this \(entity).")

	FieldDef("can_edit", type: .bool)
		.required()
		.doc("Whether the current user can edit this \(entity).")

	FieldDef("mentioned_users", type: .array(.def(actorID)))
		.doc("""
			An array of user IDs corresponding to users mentioned in this \(entity).
			""")

	FieldDef("parents_stack", type: .array(.def(idType)))
		.docWithTransformation("Array of identifiers of parent comments.", transformation: commentOnlyDoc)

	FieldDef("reply_to_comment", type: .def(idType))
		.docWithTransformation(
			"Identifier of the comment this is in reply to, if applicable.",
			transformation: commentOnlyDoc,
		)

	FieldDef("reply_to_user", type: .def(actorID))
		.docWithTransformation(
			"Identifier of the user this is in reply to, if applicable.",
			transformation: commentOnlyDoc,
		)

	let threadStruct = StructDef("Thread") {
		FieldDef("count", type: .int)
			.required()
			.doc("The total number of comments in this branch.")

		FieldDef("reply_count", type: .int)
			.required()
			.doc("The total number of replies to this comment.")

		FieldDef("items", type: .array(TypeRef(name: entityTypeName)))
			.required()
			.doc("The replies to this comment.")
	}
	FieldDef("thread", type: .def(threadStruct))
		.docWithTransformation(
			"""
			An object describing the reply thread of this comment.
			Only returned when `view_type` is `threaded` or `two_level`.
			""",
			transformation: commentOnlyDoc,
		)
	threadStruct
}
