let likes = Group("Likes") {
	RequestDef("likes.add", resultType: .int) {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.doc("Identifier of the object to be liked.")
	}
	.doc("""
		Likes an object on behalf of the current user.
		Returns the new number of likes on the target object.
		""")
	.requiresPermissions("likes")

	RequestDef("likes.delete", resultType: .int) {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.doc("Identifier of the object to be unliked.")
	}
	.doc("""
		Undoes the like of an object on behalf of the current user.
		Returns the new number of likes on the target object.
		""")
	.requiresPermissions("likes")
}
