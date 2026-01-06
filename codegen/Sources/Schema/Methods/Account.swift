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

	apiMethod("account.getProfileInfo") {
		userFieldsParam()
			.doc("""
				A list of ``User`` profile fields to be returned in
				``Result/relationPartner``.
				""")

		StructDef("Result") {
			FieldDef("first_name", type: .string)
				.required()
				.doc("First name.")
			FieldDef("nickname", type: .string)
				.required()
				.doc("Nickname or middle name.")
			FieldDef("last_name", type: .string)
				.required()
				.doc("Last name.")
			FieldDef("maiden_name", type: .string)
				.required()
				.doc("Maiden name.")

			FieldDef("sex", type: .clearable(TypeRef(name: "User.Gender")))
				.required()
				.doc("""
					Preferred grammatical gender used to choose pronouns in strings
					that refer to the current user.
					""")

			FieldDef("bdate", type: .clearable(TypeRef(name: "Birthday")))
				.swiftName("birthday")
				.required()
				.doc("The date of birth.")

			FieldDef("hometown", type: .string)
				.required()
				.doc("Hometown.")

			FieldDef("relation", type: .clearable(TypeRef(name: "User.RelationshipStatus")))
				.required()
				.doc("Relationship status.")

			FieldDef("relation_partner", type: .def(user))
				.doc("""
					A ``User`` object representing the current user's relationship
					partner, if any.
					""")
		}
	}
	.doc("""
		Returns the information needed to display the form for editing the "General"
		section of the current user's profile.

		This method is needed because ``Users/Get`` will only return the relationship
		partner for statuses other than "in love" if both users have set each other
		as their partners.
		Future Smithereen versions may add more such fields, for example,
		names in different languages.
		""")
	.requiresPermissions("account")

	apiMethod("account.revokeToken", resultType: .void) {
	}
	.doc("Revokes the current access token.")

	apiMethod("account.savePrivacySettings", resultType: .void) {
		let settingDef = StructDef("Setting") {
			FieldDef("key", type: TypeRef(name: "PrivacySetting.Key"))
				.required()
				.doc("The key as returned by ``Account/GetPrivacySettings``.")
			FieldDef("setting", type: .def(privacySetting))
				.required()
				.doc("The privacy setting itself.")
		}

		settingDef

		FieldDef("settings", type: .array(.def(settingDef)))
			.json()
			.doc("Regular privacy settings.")

		FieldDef("feed_types", type: TypeRef(name: "FeedTypes"))
			.doc("Which updates show up in followers' news feeds.")
	}
	.doc("""
		Updates the current user's privacy settings.

		Any settings not specified remain unchanged.
		""")
	.requiresPermissions("account")

	apiMethod("account.saveProfileContacts", resultType: .void) {
		userCityField

		FieldDef("site", type: .clearable(.url))
			.doc("User’s personal website.")

		for field in userConnectionsStruct.fields {
			if field.type.optional(false) == .url {
				copyWith(field, \.type, .clearable(.url).optional())
			} else {
				field
			}
		}
	}
	.doc("""
		Updates the "Contacts" section in the current user's profile.

		Omitting a parameter means that that property remains unchanged.
		To clear a property, pass an empty string or ``Clearable/unspecified``.
		""")
	.requiresPermissions("account")

	apiMethod("account.saveProfileInfo", resultType: .void) {
		FieldDef("first_name", type: .string)
			.doc("""
				First name. Can't be cleared.
				If an empty string is passed, the first name will remain
				unchanged.
				""")

		FieldDef("nickname", type: .string)
			.doc("Nickname or middle name.")

		FieldDef("last_name", type: .string)
			.doc("Last name.")

		FieldDef("maiden_name", type: .string)
			.doc("Maiden name.")

		FieldDef("sex", type: .clearable(TypeRef(name: "User.Gender")))
			.doc("""
				Preferred grammatical gender used to choose pronouns in strings
				that refer to the current user.
				""")

		FieldDef("bdate", type: .clearable(TypeRef(name: "Birthday")))
			.doc("Birth date.")

		FieldDef("hometown", type: .string)
			.doc("Hometown.")

		FieldDef("relation", type: .clearable(TypeRef(name: "User.RelationshipStatus")))
			.doc("Relationship status.")

		FieldDef("relation_partner_id", type: .clearable(.def(userID)))
			.doc("""
				Identifier of the relationship partner.

				All relationship statuses except unspecified,
				``User/RelationshipStatus/single``, and ``User/RelationshipStatus/activelySearching``
				can have a partner. All of those, except ``User/RelationshipStatus/inLove``,
				require the partner to set the current user as their partner to show up on both
				their profiles.
				""")
	}
	.doc("""
		Updates the "General" section in the current user's profile.

		Omitting a parameter means that the property remains unchanged.
		To clear a property (except ``firstName``), pass an empty string
		or ``Clearable/unspecified``.
		""")
	.requiresPermissions("account")

	apiMethod("account.saveProfileInterests", resultType: .void) {
		let fields = [
			("activities", "User's activities."),
			("interests", "User's interests."),
			("music", "User's favorite music."),
			("movies", "User's favorite movies."),
			("tv", "User's favorite TV shows."),
			("books", "User's favorite books."),
			("games", "User's favorite games."),
			("quotes", "User's favorite quotes."),
			("about", "User's about field as HTML."),
		]
		for (name, doc) in fields {
			FieldDef(name, type: .string).doc(doc)
		}
	}
	.doc("""
		Updates the "Interests" section in the current user's profile.

		Omitting a parameter means that that property remains unchanged.
		To clear a property, pass an empty string.
		""")
	.requiresPermissions("account")

	apiMethod("account.saveProfilePersonal", resultType: .void) {
		FieldDef("political", type: .clearable(TypeRef(name: "User.PoliticalViews")))
			.doc("Political views.")
		FieldDef("religion", type: .string)
			.doc("Religious views.")
		FieldDef("inspired_by", type: .string)
			.doc("Sources of inspiration.")
		FieldDef("people_main", type: .clearable(TypeRef(name: "User.PeoplePriority")))
			.doc("What this user considers important in others.")
		FieldDef("life_main", type: .clearable(TypeRef(name: "User.PersonalPriority")))
			.doc("What this user considers personal priority.")
		FieldDef("smoking", type: .clearable(TypeRef(name: "User.HabitsViews")))
			.doc("Views on smoking.")
		FieldDef("alcohol", type: .clearable(TypeRef(name: "User.HabitsViews")))
			.doc("Views on alcohol.")
	}
	.doc("""
		Updates the "Personal" section in the current user's profile.

		Omitting a parameter means that that property remains unchanged.
		To clear a property, pass an empty string or ``Clearable/unspecified``.
		""")
	.requiresPermissions("account")

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
