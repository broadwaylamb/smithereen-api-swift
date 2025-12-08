let likes = Group("Likes") {
	let likeResultStruct = StructDef("Result") {
		FieldDef("likes", type: .int)
			.required()
			.doc("The new number of likes on the target object.")
	}

	RequestDef("likes.add") {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.doc("Identifier of the object to be liked.")
		
		likeResultStruct
	}
	.doc("""
		Likes an object on behalf of the current user.
		Returns the new number of likes on the target object.
		""")
	.requiresPermissions("likes")

	RequestDef("likes.delete") {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.doc("Identifier of the object to be unliked.")
		
		likeResultStruct
	}
	.doc("""
		Undoes the like of an object on behalf of the current user.
		Returns the new number of likes on the target object.
		""")
	.requiresPermissions("likes")
}
