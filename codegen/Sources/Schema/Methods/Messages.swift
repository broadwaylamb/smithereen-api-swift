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
}
