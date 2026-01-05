let account = Group("Account") {
	apiMethod("account.banDomain", resultType: .void) {
		FieldDef("domain", type: .string)
			.required()
			.doc("The domain name of the server to block.")
	}
	.doc("Blocks a remote server on behalf of the current user.")
	.requiresPermissions("account")

	apiMethod("account.banUser", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("The identifier of the user to block.")
	}
	.doc("Blocks a user on behalf of the current user.")
	.requiresPermissions("account")

	apiMethod(
		"account.getAppPermissions",
		resultType: .array(TypeRef(name: "Permission")),
	) {
	}
	.doc("Returns the list of permissions granted to the access token.")

	apiMethod("account.getBannedDomains", resultType: .paginatedList(.string)) {
		offsetAndCountParams("domain", range: 1...1000, defaultCount: 100)
	}
	.doc("Returns the list of remote server domains blocked by the current user.")
	.requiresPermissions("account")

	apiMethod("account.getBannedUsers", resultType: .paginatedList(.def(user))) {
		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
		userFieldsParam()
	}
	.doc("Returns the list of users blocked by the current user.")
	.requiresPermissions("account")

	apiMethod("account.getCounters") {
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

	apiMethod("account.getPrivacySettings") {
		let settingDef = StructDef("Setting") {
			FieldDef("key", type: TypeRef(name: "PrivacySetting.Key"))
				.required()
				.doc("Which setting this is.")
			FieldDef("description", type: .string)
				.required()
				.doc("Localized user-visible description of this setting.")
			FieldDef("setting", type: .def(privacySetting))
				.required()
				.doc("The privacy setting itself.")
			FieldDef("only_me", type: .bool)
				.required()
				.doc("""
					If `true`, this setting's ``PrivacySetting/Rule/none`` value
					should be displayed as "only me" instead of "no one".
					""")
			FieldDef("friends_only", type: .bool)
				.required()
				.doc("""
					If `true`, this setting only goes up to "friends only",
					i.e. "friends and friends of friends" and "everyone" options
					are not available.
					""")
		}
		settingDef

		StructDef("Result") {
			FieldDef("settings", type: .array(.def(settingDef)))
				.required()
				.doc("Regular privacy settings.")

			FieldDef("feed_types", type: .array(TypeRef(name: "PrivacySetting.FeedType")))
				.required()
				.doc("Which updates show up in followers' news feeds.")
		}
	}
	.doc("Returns the current user's privacy settings.")
	.requiresPermissions("account")

	apiMethod("account.revokeToken", resultType: .void) {
	}
	.doc("Revokes the current access token.")

	apiMethod("account.setOffline", resultType: .void) {
	}
	.doc("""
		Sets the current user’s presence status to “offline”,
		even if the 5-minute timeout hasn’t expired yet.

		This only has an effect if the user’s current online status was
		set using the same token. For example, if they opened your app
		on their phone, which called ``Account/SetOnline``, and then
		switched to the web browser on their computer, your app calling
		``Account/SetOffline`` will have no effect since their current
		online status will be associated with a different session.
		""")

	apiMethod("account.setOnline", resultType: .void) {
		FieldDef("mobile", type: .bool)
			.doc("""
				Whether the user is using a mobile device.
				Strongly recommended for apps that run on phones, tablets,
				and other devices that are limited compared to desktop
				and laptop computers.

				By default `false`.
				""")
	}
	.doc("""
		Sets the current user’s presence status to “online”
		for 5 minutes.
		""")

	apiMethod("account.unbanDomain", resultType: .void) {
		FieldDef("domain", type: .string)
			.required()
			.doc("The domain name of the server to unblock.")
	}
	.doc("Unlocks a remote server on behalf of the current user.")
	.requiresPermissions("account")

	apiMethod("account.unbanUser", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("The identifier of the user to unblock.")
	}
	.doc("Unblocks a user on behalf of the current user.")
	.requiresPermissions("account")
}
