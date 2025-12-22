let utils = Group("Utils") {
	RequestDef("utils.getServerTime", resultType: .unixTimestamp) {
	}
	.doc("Returns the server's current time.")

	RequestDef("utils.loadRemoteObject") {
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
}
