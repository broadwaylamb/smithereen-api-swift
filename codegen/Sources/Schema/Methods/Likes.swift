let likes = Group("Likes") {
	RequestDef("likes.add", resultType: .int) {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.doc("Identifier of the object to be liked.")
	}
	.doc("Likes an object on behalf of the current user.")
	.requiresPermissions("likes")
}
