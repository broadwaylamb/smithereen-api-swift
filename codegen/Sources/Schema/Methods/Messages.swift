let messages = Group("Messages") {
	RequestDef("messages.delete", resultType: .void) {
		FieldDef("message_id", type: .def(messageID))
			.required()
			.doc("Identifier of the message to be deleted.")
		FieldDef("revoke", type: .bool)
			.doc("""
				If this is an outgoing message that is still unread,
				delete it out of its recipients’ mailboxes as well.
				Messages deleted like this can’t be restored using
				``Messages/Restore``.

				To revoke a previously deleted message, just call
				``Messages/Delete`` again with ``revoke`` set to `true`.

				By default `false`.
				""")
	}
	.doc("Deletes a message.")
	.requiresPermissions("messages")

	RequestDef("messages.get", resultType: .paginatedList(.def(message))) {
		FieldDef("out", type: .bool)
			.doc("""
				Whether to return outgoing or incoming messages.

				By default `false`.
				""")
		offsetAndCountParams("message", defaultCount: 20)
	}
	.doc("Returns the current user’s incoming or outgoing private messages.")
	.requiresPermissions("messages:read")
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(message),
			extras: .paginatedListExtrasProfiles
		),
	) {
		extendedParameters()
	}

	RequestDef("messages.getById", resultType: .array(.def(message))) {
		FieldDef("message_ids", type: .array(.def(messageID)))
			.required()
			.doc("A list of up to 200 message identifiers.")
	}
	.doc("Returns messages by their identifiers.")
	.requiresPermissions("messages:read")
	.withExtendedVersion("Extended") {
		extendedParameters()

		StructDef("Result") {
			FieldDef("items", type: .array(.def(message)))
				.required()
			FieldDef("profiles", type: .array(.def(user)))
				.required()
		}
	}

	RequestDef("messages.getHistory", resultType: .paginatedList(.def(message))) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("Identifier of the user.")
		offsetAndCountParams("message", defaultCount: 20)
	}
	.doc("""
		Returns the conversation history with a specified user.

		Messages that have multiple recipients are included in all corresponding
		conversations, so you may see the same message returned for different
		``userID``s.
		""")
	.requiresPermissions("messages:read")
}

@StructDefBuilder
private func extendedParameters() -> any StructDefPart {
	FieldDef("extended", type: .bool)
		.required()
		.constantValue("true")
	FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
		.doc("A list of ``User`` profile fields to be returned.")
}
