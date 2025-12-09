let server = Group("Server") {
	RequestDef("server.getInfo") {
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
			FieldDef("groups", type: .string)
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
}
