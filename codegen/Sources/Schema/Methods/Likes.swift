let likes = Group("Likes") {
	let likeResultStruct = StructDef("Result") {
		FieldDef("likes", type: .int)
			.required()
			.doc("The new number of likes on the target object.")
	}

	RequestDef("likes.add") {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.flatten()
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
			.flatten()
			.doc("Identifier of the object to be unliked.")
		
		likeResultStruct
	}
	.doc("""
		Undoes the like of an object on behalf of the current user.
		Returns the new number of likes on the target object.
		""")
	.requiresPermissions("likes")

	RequestDef("likes.getList", resultType: .paginatedList(.def(userID))) {
		FieldDef("itemID", type: TypeRef(name: "LikeableObject"))
			.required()
			.flatten()
			.doc("Identifier of the target object.")
		
		FieldDef("friends_only", type: .bool)
			.doc("""
				Whether to only return likes by the current user’s friends.
				By default `false`.
				""")
		
		FieldDef("skip_own", type: .bool)
			.doc("""
				Whether to omit the current user from the list.
				By default `false`.
				""")
		
		offsetAndCountParams("user", defaultCount: 100)
	}
	.doc("Returns the list of users who like an object.")
	.withUserFields()
}

