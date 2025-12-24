let globalRequestParameters = FileDef("GlobalRequestParameters") {
	StructDef("GlobalRequestParameters", conformances: [.encodable]) {
		FieldDef("v", type: TypeRef(name: "SmithereenAPIVersion"))
			.swiftName("apiVersion")
			.required()
			.doc("The API version to use.")
		FieldDef("access_token", type: .def(accessToken))
			.doc("""
				The access token for performing actions on behalf of a user.
				Alternatively, can be passed as a header `Authorization: Bearer <token>`.
				""")
		FieldDef("lang", type: .string)
			.swiftName("language")
			.doc("""
				A language code like `en-GB` or `ru` for methods that
				use translatable strings or inflect people’s names.
				""")
		FieldDef("image_format", type: .def(imageFormat))
			.doc("""
				In which format you would like images to be returned.
				""")
	}
	.doc("""
		In addition to parameters specific to each method, the global parameters
		applicable to all methods.

		See https://smithereen.software/docs/api/requests/
		""")
}
