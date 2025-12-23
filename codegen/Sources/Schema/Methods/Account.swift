let account = Group("Account") {
	RequestDef(
		"account.getAppPermissions",
		resultType: .array(TypeRef(name: "Permission")),
	) {
	}
	.doc("Returns the list of permissions granted to the access token.")
}
