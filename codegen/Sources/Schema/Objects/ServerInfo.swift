let serverInfo = StructDef("ServerInfo") {
	FieldDef("domain", type: .string)
		.required()
	FieldDef("name", type: .string)
		.required()
	FieldDef("description", type: .string)
	FieldDef("short_description", type: .string)
	FieldDef("version", type: .string)
		.required()
	FieldDef("policy", type: .string)
	
	FieldDef("rules", type: .array(.def(serverRule)))
		.required()
	
	FieldDef("admin_email", type: .string)
	FieldDef("admins", type: .array(.def(user)))
		.required()
	FieldDef("signup_mode", type: .def(serverSignupMode))
		.required()

	FieldDef("api_versions", type: .dict(key: TypeRef(name: "APIVersionKey"), value: .string))
		.required()
	EnumDef<String>("APIVersionKey") {
		EnumCaseDef("smithereen")
	}

	FieldDef("uploads", type: TypeRef(name: "Uploads")).required()
	StructDef("Uploads") {
		FieldDef("image_max_size", type: .int).required()
		FieldDef("image_max_dimensions", type: .int).required()
		FieldDef("image_types", type: .array(.string)).required() // TODO: Use ContentType instead of String
	}
	
	FieldDef("stats", type: TypeRef(name: "Stats")).required()
	StructDef("Stats") {
		FieldDef("users", type: .int).required()
		FieldDef("active_users", type: .int).required()
		FieldDef("groups", type: .string).required()
	}
}
