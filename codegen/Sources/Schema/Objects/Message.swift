let message = StructDef("Message") {
	FieldDef("id", type: .def(messageID))
		.required()
		.id()
		.doc("Unique (server-wide) identifier of this message.")

	activityPubIDField("message")

	FieldDef("from", type: .def(userID))
		.required()
		.doc("Identifier of the user who sent this message.")

	FieldDef("to", type: .array(.def(userID)))
		.required()
		.doc("Identifiers of primary recipients of this message.")

	FieldDef("cc", type: .array(.def(userID)))
		.required()
		.doc("Identifiers of secondary recipients of this message.")

	FieldDef("date", type: .unixTimestamp)
		.required()
		.doc("Timestamp when this message was sent.")

	FieldDef("read_by", type: .array(.def(userID)))
		.required()
		.doc("""
			Identifiers of recipients who have read (opened) this message.

			Read receipts are currently only supported by Smithereen,
			so users from servers running different software won’t
			show up here.
			""")

	FieldDef("subject", type: .string)
		.required()
		.doc("The subject line.")

	FieldDef("body", type: .string)
		.required()
		.doc("The main text of the message as HTML.")

	FieldDef("attachments", type: .array(.def(attachment)))
		.doc("Media attachments added to this message.")

	let replyInfoDef = TaggedUnionDef("ReplyInfo") {
		TaggedUnionVariantDef(
			"wall_post",
			payloadFieldName: "wall_post_id",
			type: .def(wallPostID),
		)
		.doc("This is a private reply to a wall post")
		TaggedUnionVariantDef(
			"wall_comment",
			payloadFieldName: "wall_comment_id",
			type: .def(wallPostID),
		)
		.doc("This is a private reply to a comment on a wall post.")
		TaggedUnionVariantDef(
			"message",
			payloadFieldName: "message_id",
			type: .def(messageID),
		)
		.doc("This is a reply to another private message.")
	}
	.frozen()

	FieldDef("reply_to", type: .def(replyInfoDef))
		.doc("""
			If this message is in reply to something, information about
			that object.

			Mastodon and most other similar microblogging-style software
			represents private messages as posts with limited visibility,
			thus allowing its users to reply to public content in private.
			""")
	replyInfoDef
}
.doc("A private message.")
