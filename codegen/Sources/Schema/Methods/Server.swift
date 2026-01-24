let server = Group("Server") {
	let announcementDef = StructDef("Announcement") {
		FieldDef("id", type: .def(serverAnnouncementID))
			.required()
			.id()
			.doc("Unique identifier of this announcement.")

		FieldDef("title", type: .string)
			.doc("Title of the announcement.")

		FieldDef("text", type: .string)
			.required()
			.doc("Text of the announcement.")

		FieldDef("link", type: .string)
			.doc("""
				If this announcement contains a link, its title.
				The link is meant to be displayed below the main text.
				""")

		FieldDef("link_url", type: .url)
			.doc("If this announcement contains a link, its URL.")

		FieldDef("show_until_date", type: .unixTimestamp)
			.doc("""
				If this announcement is temporary, the time after
				which it should no longer be displayed.
				""")
	}
	apiMethod("server.getAnnouncements", resultType: .array(.def(announcementDef))) {
		announcementDef
	}
	.doc("""
		Returns the currently active announcements published by
		the server staff.

		Announcements are displayed below the main menu on the web.
		""")

	apiMethod("server.getInfo") {
		let serverRule = StructDef("ServerRule") {
			FieldDef("id", type: TypeRef(name: "ServerRuleID"))
				.required()
				.id()
				.doc("Rule identifier.")

			FieldDef("title", type: .string)
				.required()
				.doc("The short title of this rule.")

			FieldDef("description", type: .string)
				.doc("The description of this rule.")
		}
		serverRule

		let uploadsStruct = StructDef("Uploads") {
			FieldDef("image_max_size", type: .int)
				.required()
				.doc("The maximum size of an image file in bytes.")
			FieldDef("image_max_dimensions", type: .int)
				.required()
				.doc("The maximum image dimensions, on each side, in pixels.")

			 // TODO: Use ContentType instead of String
			FieldDef("image_types", type: .array(.string))
				.required()
				.doc("""
					The MIME types of image formats supported by this server.
					""")
		}
		uploadsStruct

		let statsStruct = StructDef("Stats") {
			FieldDef("users", type: .int)
				.required()
				.doc("How many local user accounts exist on this server.")
			FieldDef("active_users", type: .int)
				.required()
				.doc("""
					How many of the local users have been active in the last
					month.
					""")
			FieldDef("groups", type: .int)
				.required()
				.doc("How many local groups exist on this server.")
		}
		statsStruct

		StructDef("Result") {
			FieldDef("domain", type: .string)
				.required()
				.doc("The domain of this server.")
			FieldDef("name", type: .string)
				.required()
				.doc("The display name of this server.")
			FieldDef("description", type: .string)
				.doc("The long description of this server (HTML).")
			FieldDef("short_description", type: .string)
				.doc("The short description of this server (HTML).")
			FieldDef("version", type: .string)
				.required()
				.doc("The version of Smithereen running on this server.")
			FieldDef("policy", type: .string)
				.doc("The server policy, as displayed on /system/about (HTML).")

			FieldDef("rules", type: .array(.def(serverRule)))
				.required()
				.doc("""
					The server rules. If there are translations, the returned
					strings will be different depending on the language
					(the `lang` parameter or the current user’s setting).
					""")

			FieldDef("admin_email", type: .string)
				.doc("The server administrator’s email.")

			FieldDef("admins", type: .array(.def(user)))
				.required()
				.doc("""
					The array of user objects representing the server
					administrators.
					""")
			FieldDef("signup_mode", type: .def(serverSignupMode))
				.required()
				.doc("The sign-up mode currently in effect on this server.")

			FieldDef("api_versions", type: TypeRef(name: "APIVersionDictionary"))
				.required()
				.doc("""
					Information about the API versions that this server
					supports. The version numbers have the format of
					`major.minor`.

					It is intended that forks will add their own fields to this
					object, enabling apps to easily discover which extensions
					this server supports and which versions they are.
					""")

			FieldDef("uploads", type: .def(uploadsStruct))
				.required()
				.doc("""
					Information about the limitations that this server imposes
					on uploaded files.
					""")

			FieldDef("stats", type: .def(statsStruct))
				.required()
				.doc("Server statistics.")
		}
	}
	.doc("Returns information about this server.")

	let restriction = EnumDef<String>("ServerRestriction") {
		EnumCaseDef("suspension")
			.doc("Complete defederation – no communication with this server is possible.")
	}

	let restrictedServerStruct = StructDef("RestrictedServer") {
		FieldDef("domain", type: .string)
			.required()
			.doc("The domain name of the server. May be partially masked with `*`s.")

		FieldDef("reason", type: .string)
			.doc("The reason for restriction provided by this server’s administrators.")

		FieldDef("restriction", type: .def(restriction))
			.required()
			.doc("The type of restriction applied.")
	}

	apiMethod("server.getRestrictedServers", resultType: .paginatedList(.def(restrictedServerStruct))) {
		FieldDef("offset", type: .int)
			.doc("Offset into the list of restricted servers.")

		FieldDef("count", type: .int)
			.doc("""
				How many of the restricted servers to return.

				By default, all servers are returned.
				""")

		restriction
		restrictedServerStruct
	}
	.doc("Returns the list of servers for which there are federation restrictions.")

	apiMethod("server.report", resultType: .void) {
		FieldDef("owner_id", type: .def(actorID))
			.required()
			.doc("The identifier of the user or group being reported.")

		let reasonDef = TaggedUnionDef(
			"Reason",
			conformances: [.hashable, .encodable, .sendable],
		) {
			TaggedUnionVariantDef("spam", type: .void)
				.doc("Spam")
			TaggedUnionVariantDef(
				"rules",
				payloadFieldName: "rule_ids",
			 	type: .array(.def(serverRuleID))
			)
			.doc("""
				The actor violates some server rules.
				Only available when there are rules defined on the server.
				At least one rule identifier must be specified.
				""")
			TaggedUnionVariantDef("illegal", type: .void)
				.doc("Illegal content or activities.")
			TaggedUnionVariantDef("other", type: .void)
				.doc("Anything that doesn’t fit into the above categories.")
		}
		.tag("reason")

		FieldDef("reason", type: .def(reasonDef))
			.required()
			.flatten()
			.doc("The reason for the report.")
		reasonDef

		let reportedContentDef = TaggedUnionDef(
			"ReportedContent",
			conformances: [.hashable, .encodable, .sendable],
		) {
			TaggedUnionVariantDef("wall_post", payloadFieldName: "id", type: .def(wallPostID), convertPayloadFromString: true)
			TaggedUnionVariantDef("wall_comment", payloadFieldName: "id", type: .def(wallPostID), convertPayloadFromString: true)
			TaggedUnionVariantDef("comment", payloadFieldName: "id", type: .def(photoCommentID))
				.swiftName("photoComment")
			TaggedUnionVariantDef("comment", payloadFieldName: "id", type: .def(topicCommentID))
				.swiftName("topicComment")
			TaggedUnionVariantDef("message", payloadFieldName: "id", type: .def(messageID))
			TaggedUnionVariantDef("photo", payloadFieldName: "id", type: .def(photoID))
		}

		FieldDef("content", type: .array(.def(reportedContentDef)))
			.json()
			.doc("""
				Any content to be attached to the report.
				``ownerID`` must be a user and the content must be authored
				by that user.
				""")

		reportedContentDef

		FieldDef("forward", type: .bool)
			.doc("""
				If ``ownerID`` refers to an actor on another server, whether to
				forward (anonymously) the report to that server.

				By default `false`.
				""")

		FieldDef("comment", type: .string)
			.doc("An optional comment for the server staff.")
	}
	.doc("""
		Submits a report about potentially harmful content or behavior for review
		by the server staff.
		""")
}
