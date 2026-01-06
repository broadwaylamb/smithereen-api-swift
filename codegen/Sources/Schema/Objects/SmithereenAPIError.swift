let error = StructDef("SmithereenAPIError") {
	let codeEnum = EnumDef<Int>("Code") {
		EnumCaseDef(1, swiftName: "other")
			.doc("See the error message for details.")
		EnumCaseDef(3, swiftName: "unknownMethodPassed")
			.doc("""
				Make sure the method you’re calling
				[exists](https://smithereen.software/docs/api/methods) on
				the Smithereen version your server is running, and that there
				are no typos in the method name.
				""")
		EnumCaseDef(5, swiftName: "userAuthorizationFailed")
			.doc("""
				If you passed an access token, it’s invalid, revoked,or expired.
				If you did not, this method requires an authenticated user.
				""")
		EnumCaseDef(6, swiftName: "tooManyRequestsPerSecond")
			.doc("""
				You made more than 3 requests per second per token
				(for authenticated requests) or per IPv4 address or IPv6 /64
				(for anonymous requests). If you need to make multiple requests
				in a quick succession, use the ``Execute`` method.
				""")
		EnumCaseDef(7, swiftName: "permissionDenied")
			.doc("""
				Your access token does not have the necessary scopes to call
				this method or perform this action. See the page for the method
				you’re calling for the permissions it requires.
				""")
		EnumCaseDef(8, swiftName: "invalidRequest")
			.doc("""
				Make sure your request is
				[correctly formatted and contains all necessary parameters](https://smithereen.software/docs/api/requests).
				""")
		EnumCaseDef(9, swiftName: "floodControl")
			.doc("""
				You are performing the same type of action too often.
				Try again later.
				""")
		EnumCaseDef(10, swiftName: "internalServerError")
			.doc("""
				The server was unable to complete your request because of a bug
				or a misconfiguration. Try again later, and if the error
				persists, report it to the server staff.
				If this is your server, see the server log
				(`journalctl -u smithereen.service`) for details.
				""")
		EnumCaseDef(12, swiftName: "executeFailedToCompile")
			.doc("""
				Failed to compile the script in the ``Execute`` method.
				""")
		EnumCaseDef(13, swiftName: "executeRuntimeError")
			.doc("""
				A runtime error occurred during script execution in
				the ``Execute`` method.
				""")
		EnumCaseDef(14, swiftName: "captchaNeeded")
			.doc("""
				You are performing the same type of action too often, and
				the server suspects you of spamming. [You need to present
				a captcha image to the user and retry the request](https://smithereen.software/docs/api/captcha).
				""")
		EnumCaseDef(15, swiftName: "accessDenied")
			.doc("""
				The object you’re requesting, or the action you’re performing,
				is not available to the current user due to privacy settings or
				because they were blocked.
				""")
		EnumCaseDef(17, swiftName: "validationRequired")
			.doc("""
				You need to go through
				[web-based validation](https://smithereen.software/docs/api/validation)
				to perform this action.
				""")
		EnumCaseDef(18, swiftName: "accountBanned")
			.doc("""
				The current user’s account is suspended or frozen. They can’t
				access this server. Details about why this happened and further
				instructions for the user are available if they log in on
				the web.
				""")
		EnumCaseDef(100, swiftName: "invalidMethodParameters")
			.doc("""
				See the method page for required parameters and their format.
				""")
		EnumCaseDef(173, swiftName: "tooManyFriendLists")
			.doc("Too many friend lists.")
		EnumCaseDef(174, swiftName: "cantAddOneselfAsFriend")
			.doc("Can't add oneself as a friend.")
		EnumCaseDef(175, swiftName: "cantAddAsFriendBecauseUserBlockedYou")
			.doc("Can't add this user as a friend because they blocked you.")
		EnumCaseDef(176, swiftName: "cantAddAsFriendBecauseYouBlockedUser")
			.doc("Can't add this user as a friend because you blocked them.")
		EnumCaseDef(181, swiftName: "cannotAddOrUpdateGroupManager")
			.doc("Can't add or update this group manager.")
		EnumCaseDef(182, swiftName: "cannotRemoveGroupManager")
			.doc("Can't remove this group manager.")
		EnumCaseDef(242, swiftName: "tooManyFriends")
			.doc("Too many friends.")
		EnumCaseDef(302, swiftName: "tooManyPhotoAlbums")
			.doc("Too many photo albums.")
		EnumCaseDef(401, swiftName: "remoteObjectNetworkError")
			.doc("Failed to fetch remote object due to a network error.")
		EnumCaseDef(402, swiftName: "remoteObjectUnsupportedType")
			.doc("Remote object is of an unsupported type.")
		EnumCaseDef(403, swiftName: "remoteObjectServerTimeOut")
			.doc("Request to the remote server timed out ")
		EnumCaseDef(404, swiftName: "remoteObjectNotFound")
			.doc("Remote object not found.")
		EnumCaseDef(405, swiftName: "remoteObjectOtherError")
			.doc("Failed to fetch remote object due to other error.")
	}
	.nonexhaustive()
	FieldDef("error_code", type: .def(codeEnum))
		.required()
		.swiftName("code")
	codeEnum

	FieldDef("error_msg", type: .string)
		.required()
		.swiftName("message")

	FieldDef("request_params", type: .dict(key: .string, value: .string))

	FieldDef("method", type: .string)
		.doc("Returned only for the ``Execute`` request.")
}
