let utils = Group("Utils") {
	apiMethod("utils.getServerTime", resultType: .unixTimestamp) {
	}
	.doc("Returns the server's current time.")

	apiMethod("utils.loadRemoteObject") {
		FieldDef("q", type: .string)
			.swiftName("query")
			.required()
			.doc("""
				The URL (ActivityPub ID) of the target object or
				a `username@domain` string to resolve a username.
				""")
	}
	.doc("""
		Loads an object from another fediverse server.

		Note that a call to this method may potentially take 30 seconds or more.
		""")

	apiMethod("utils.resolveScreenName") {
		FieldDef("screen_name", type: .string)
			.required()
			.doc("The username or `username@domain` to resolve.")

		TaggedUnionDef("Result") {
			TaggedUnionVariantDef("user", payloadFieldName: "id", type: .def(userID))
			TaggedUnionVariantDef("group", payloadFieldName: "id", type: .def(groupID))
			TaggedUnionVariantDef("application", payloadFieldName: "id", type: .def(applicationID))
		}
	}
	.doc("""
		Returns the user, group, or app ID by its screen name (username).

		This method only works with actors that are already present
		in the server’s database. If you need to load a remote actor that
		the server may not know about, use ``LoadRemoteObject`` instead.
		""")

	apiMethod("utils.testCaptcha", resultType: .void) {
	}
	.doc("""
		Allows you to intentionally trigger a captcha needed response to test
		how your app handles it.

		See [captcha and validation](https://smithereen.software/docs/api/captcha)
		for details.

		When first called, this method will fail with the error ``SmithereenAPIError/Code/captchaNeeded``.
		When the request is then retried with a valid ``captchaAnswer``, returns normally.
		""")
}
