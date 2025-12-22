let status = Group("Status") {
	RequestDef("status.get") {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				User or group ID for which to return the status.
				By default, the current user.
				Required if no token is used.
				""")

		StructDef("Result") {
			FieldDef("text", type: .string)
				.doc("The status text. If there’s no status, `nil`.")
		}
	}
	.doc("Returns a user’s or group’s status text.")

	RequestDef("status.set", resultType: .void) {
		FieldDef("group_id", type: .def(groupID))
			.doc("""
				Which group to update the status in.
				Updating a group’s status requires the `groups` permission.

				If not specified, updates the current user’s status.
				""")
		FieldDef("text", type: .string)
			.doc("The status text. The status is cleared if this is not specified.")
	}
	.doc("Updates the current user’s or their managed group’s status.")
	.requiresPermissions("account")
}
