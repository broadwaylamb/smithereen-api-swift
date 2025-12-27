let likes = Group("Likes") {
	let likeResultStruct = StructDef("Result") {
		FieldDef("likes", type: .int)
			.required()
			.doc("The new number of likes on the target object.")
	}

	apiMethod("likes.add") {
		FieldDef("item_id", type: .likeableObject)
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

	apiMethod("likes.delete") {
		FieldDef("item_id", type: .likeableObject)
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

	apiMethod("likes.getList", resultType: .paginatedList(.def(userID))) {
		FieldDef("item_id", type: .likeableObject)
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

		offsetAndCountParams("user", range: 1...1000, defaultCount: 100)
	}
	.doc("Returns the list of users who like an object.")
	.withUserFields()

	apiMethod("likes.isLiked") {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				The user identifier for which the like needs to be checked.

				By default, the current user.
				""")

		FieldDef("item_id", type: .likeableObject)
			.required()
			.flatten()
			.doc("Identifier of the target object.")

		StructDef("Result") {
			FieldDef("liked", type: .bool)
				.required()
				.doc("Whether the user likes this object.")

			FieldDef("reposted", type: .bool)
				.doc("Whether the user has reposted this post or comment.")
		}
	}
}
