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
	.withExtendedVersion(
		"Extended",
		extendedResultType: .paginatedList(
			.def(message),
			extras: .paginatedListExtrasProfiles
		),
	) {
		FieldDef("extended", type: .bool)
			.required()
			.constantValue("true")
		FieldDef("fields", type: .array(TypeRef(name: "User.Field")))
			.doc("A list of user profile fields to be returned.")
	}
}
