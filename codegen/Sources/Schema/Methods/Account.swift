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

	RequestDef("account.setOffline", resultType: .void) {
	}
	.doc("""
		Sets the current user’s presence status to “offline”,
		even if the 5-minute timeout hasn’t expired yet.

		This only has an effect if the user’s current online status was
		set using the same token. For example, if they opened your app
		on their phone, which called ``Account/SetOnline``, and then
		switched to the web browser on their computer, your app calling
		``Account.SetOffline`` will have no effect since their current
		online status will be associated with a different session.
		""")
}
