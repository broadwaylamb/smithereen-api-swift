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
}
