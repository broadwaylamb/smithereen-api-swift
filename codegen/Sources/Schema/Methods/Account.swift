let account = Group("Account") {
	RequestDef(
		"account.getAppPermissions",
		resultType: .array(TypeRef(name: "Permission")),
	) {
	}
	.doc("Returns the list of permissions granted to the access token.")

	RequestDef("account.getCounters") {
		StructDef("Result") {
			FieldDef("friends", type: .int)
				.required()
				.doc("New friend requests.")
			FieldDef("notifications", type: .int)
				.required()
				.doc("""
					New notifications (“feedback”).
					Whether or not this includes likes and reposts is
					determined by the corresponding setting.
					""")
			FieldDef("groups", type: .int)
				.required()
				.doc("New group invitations.")
			FieldDef("events", type: .int)
				.required()
				.doc("New event invitations.")
			FieldDef("messages", type: .int)
				.required()
				.doc("Unread messages.")
			FieldDef("photos", type: .int)
				.required()
				.doc("New photo tags.")
		}
	}
	.doc("""
		Returns how many of each type of unread items the current user
		has.
		""")
}
