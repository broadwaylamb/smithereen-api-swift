let oauth = FileDef("OAuthRequests", additionalImports: ["Hammond"]) {
	StructDef("OAuth.AccessTokenResponse") {
		FieldDef("access_token", type: .def(accessToken))
			.required()
		FieldDef("user_id", type: .def(userID))
			.required()
		FieldDef("expires_in", type: .double)
			.doc("In how many seconds this access token expires.")
	}

	StructDef(
		"OAuth.TokenError",
		conformances: StructDef.defaultConformances + [TypeRef(name: "Error")],
	) {
		let code = EnumDef<String>("Code") {
			EnumCaseDef("access_denied")
			EnumCaseDef("invalid_request")
			EnumCaseDef("invalid_grant")
			EnumCaseDef("unsupported_grant_type")
			EnumCaseDef("captcha_needed")
		}
		.nonexhaustive()
		code
		FieldDef("error", type: .def(code))
			.swiftName("code")
			.required()
		FieldDef("error_description", type: .string)
			.doc("A localized error description suitable for display in the UI.")
		FieldDef("captcha", type: .def(captcha))
			.doc("Returned only if ``code`` is ``Code/captchaNeeded``")
	}

	RequestDef(
		"/oauth/token",
		swiftName: "OAuth.ExchangeAuthorizationCodeForAccessToken",
		conformances: [
			TypeRef(name: "SmithereenOAuthTokenRequest"),
			.hashable,
			.encodable,
			.sendable,
		]
	) {
		FieldDef("grant_type", type: .string)
			.required()
			.constantValue("\"authorization_code\"")
		FieldDef("code", type: TypeRef(name: "AuthorizationCode"))
			.required()
			.doc("The OAuth authorization code.")
		FieldDef("redirect_uri", type: .url)
			.required()
			.doc("The redirect URI you used for obtaining the authorization code.")
		FieldDef("client_id", type: .url)
			.required()
			.doc("Your application ID.")
		FieldDef("code_verifier", type: .string)
			.doc("If using PKCE, the code verifier string.")
	}

	RequestDef(
		"/oauth/token",
		swiftName: "OAuth.PasswordGrant",
		conformances: [
			TypeRef(name: "SmithereenOAuthTokenRequest"),
			.hashable,
			.encodable,
			.sendable,
		],
	) {
		FieldDef("grant_type", type: .string)
			.required()
			.constantValue("\"password\"")
		FieldDef("client_id", type: .url)
			.required()
			.doc("Your application ID.")
		FieldDef("username", type: .string)
			.required()
			.doc("The email or username.")
		FieldDef("password", type: .string)
			.required()
			.doc("The user's password.")
		FieldDef("captchaAnswer", type: .def(captchaAnswer))
			.transient()
	}
	.doc("""
		Receive an access token with complete access to a user account
		using their email/username and password.
		This is intended for client apps, to provide a more streamlined
		user experience, and for apps running on platforms that can't
		load or render modern web pages.
		""")
}
