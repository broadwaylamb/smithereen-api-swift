let newsfeed = Group("Newsfeed") {
	apiMethod("newsfeed.addBan", resultType: .void) {
		FieldDef("user_id", type: .def(userID))
			.required()
			.doc("The identifier of the user to hide.")
	}
	.doc("Hides a user’s updates from the current user’s news feed.")
	.requiresPermissions("newsfeed")

	apiMethod("newsfeed.addFilter", resultType: .def(wordFilterID)) {
		FieldDef("name", type: .string)
			.required()
			.doc("The user-visible name of the filter.")

		FieldDef("words", type: .array(.string))
			.json()
			.required()
			.doc("Words (case-insensitive) that match this filter.")

		FieldDef("contexts", type: .array(.def(wordFilterContext)))
			.required()
			.doc("Which contexts this filter applies in.")

		FieldDef("expiry_date", type: .unixTimestamp)
			.doc("""
				The unixtime when this filter expires.
				If the timestamp is in the past, or if this parameter
				is omitted, the filter will not expire.
				""")
	}
	.doc("Creates a new word filter for the current user’s news feeds.")
	.requiresPermissions("newsfeed")

	apiMethod("newsfeed.get") {
		let paginationToken = IdentifierStruct("PaginationToken", rawValue: .string)
		paginationToken

		let filter = filterEnum(
			("post", "Wall posts and reposts."),
			("photo", "New photos added to albums."),
			("photo_tag", "New photo tags."),
			("friend", "New friends."),
			("group", "Groups joined or created."),
			("event", "Events joined or created."),
			("board", "New discussion board topics in groups."),
			("relation", "Relationship status changes"),
		)

		FieldDef("filters", type: .array(.def(filter)))
			.doc("""
				Which types of updates to return.

				By default, updates of all types are returned.
				""")
		filter

		FieldDef("return_banned", type: .bool)
			.doc("""
				Whether to include updates from muted users.

				By default `false`.
				""")

		startFromAndCount(paginationToken)
		actorFieldsParam()

		let relationUpdateStruct = StructDef("RelationUpdate") {
			FieldDef("status", type: TypeRef(name: "User.RelationshipStatus"))
				.required()
				.doc("The new relationship status.")
			FieldDef("partner", type: .def(userID))
				.doc("The new partner user identifier, if any.")
		}
		.doc("The information about the relationship status change.")
		relationUpdateStruct

		let updatedItem = TaggedUnionDef("UpdatedItem") {
			TaggedUnionVariantDef("post", type: .def(wallPostFeedUpdate))
				.flatten()
				.doc("A new wall post was created.")
			let photoUpdates = [
				("photo", "New photos were uploaded."),
				("photo_tag", "The user was tagged in some photos."),
			]
			for (photoUpdate, doc) in photoUpdates {
				TaggedUnionVariantDef(
					photoUpdate,
					payloadFieldName: "photos",
					type: .def(photoFeedUpdate)
				)
				.doc(doc)
			}
			TaggedUnionVariantDef(
				"friend",
				payloadFieldName: "friend_ids",
				type: .array(.def(userID)),
			)
			.doc("The user added new friends.")
			let groupUpdates = [
				("group_join", "The user joined some groups."),
				("group_create", "The user created some groups."),
				("event_join", "The user joined some events."),
				("event_create", "The user created some events."),
			]
			for (groupUpdate, doc) in groupUpdates {
				TaggedUnionVariantDef(
					groupUpdate,
					payloadFieldName: "group_ids",
					type: .array(.def(groupID)),
				)
				.doc(doc)
			}
			TaggedUnionVariantDef(
				"board",
				payloadFieldName: "topics",
				type: .array(.def(boardTopic)),
			)
			.doc("The user created some discussion board topics.")
			TaggedUnionVariantDef("relation", type: .def(relationUpdateStruct))
				.doc("The user has changed their relationship status.")
		}
		updatedItem

		feedResult(paginationToken: paginationToken, updatedItem: updatedItem) {
			FieldDef("user_id", type: .def(userID))
				.required()
				.doc("Which user this update is about.")
		}
	}
	.doc("Returns the current user’s followees’ updates (and their own posts).")
	.requiresPermissions("newsfeed")

	apiMethod("newsfeed.getComments") {
		let filter = filterEnum(
			("post", "Wall posts."),
			("photo", "Photos."),
			("board", "Discussion board topics."),
		)

		FieldDef("filters", type: .def(filter))
			.doc("""
				Which types of commentable objects to return.

				By default, all types are returned.
				""")
		filter

		offsetAndCountParams("object", range: 1...100, defaultCount: 25)

		FieldDef("last_comments", type: .int)
			.doc("""
				How many of the most recent comments to return, from 0 to 3.

				By default 0.
				""")

		FieldDef("comment_view_type", type: .def(commentView))
			.doc("""
				How to structure the comments for ``lastComments``.
				By default uses the user preference.
				""")

		actorFieldsParam()

		let commentableObject = TaggedUnionDef("CommentableObject") {
			TaggedUnionVariantDef("post", type: .def(wallPost))
			TaggedUnionVariantDef("photo", type: .def(photo))
			TaggedUnionVariantDef(
				"board",
				payloadFieldName: "topic",
				type: .def(boardTopic),
			)
		}
		commentableObject

		let update = StructDef("Update") {
			FieldDef("item", type: .def(commentableObject))
				.required()
				.flatten()

			FieldDef("comments", type: .array(.def(wallPost)))
				.doc("""
					If ``lastComments`` is non-zero, an array of comment
					objects.
					""")
		}
		update

		StructDef("Result") {
			FieldDef("items", type: .array(.def(update)))
				.required()
				.doc("The commentable objects themselves.")

			FieldDef("profiles", type: .array(.def(user)))
				.required()
				.doc("User objects relevant to these objects.")

			FieldDef("groups", type: .array(.def(group)))
				.required()
				.doc("Group objects relevant to these objects.")

			FieldDef("count", type: .int)
				.required()
				.doc("How many comment threads there are in total.")
		}
	}
	.doc("Returns comment threads that the current user has participated in.")
	.requiresPermissions("newsfeed")

	apiMethod("newsfeed.getGroups") {
		let paginationToken = IdentifierStruct("PaginationToken", rawValue: .string)
		paginationToken

		let filter = filterEnum(
			("post", "New wall posts."),
			("board", "New discussion board topics."),
			("photo", "New photos added to albums."),
		)

		FieldDef("filters", type: .def(filter))
			.doc("""
				Which types of updates to return.

				By default, updates of all types are returned.
				""")
		filter

		startFromAndCount(paginationToken)
		actorFieldsParam()

		let updatedItem = TaggedUnionDef("UpdatedItem") {
			TaggedUnionVariantDef("post", type: .def(wallPostFeedUpdate))
				.flatten()
				.doc("A new wall post was created.")
			TaggedUnionVariantDef(
				"board",
				payloadFieldName: "topics",
				type: .array(.def(boardTopic)),
			)
			.doc("New discussion board topics were created in the group.")
			TaggedUnionVariantDef(
				"photo",
				payloadFieldName: "photos",
				type: .array(.def(photoFeedUpdate)),
			)
			.doc("New photos were added to the group’s photo albums.")
		}

		updatedItem

		feedResult(paginationToken: paginationToken, updatedItem: updatedItem) {
			FieldDef("group_id", type: .def(groupID))
				.required()
				.doc("Which group this update is about.")
		}
	}
	.doc("Returns updates from the current user’s groups.")
	.requiresPermissions("newsfeed")
}

private func filterEnum(_ namesAndDocs: (String, String)...) -> EnumDef<String> {
	EnumDef<String>("Filter") {
		for (name, doc) in namesAndDocs {
			EnumCaseDef(name)
				.doc(doc)
		}
	}
	.frozen()
}

@StructDefBuilder
private func startFromAndCount(
	_ paginationToken: StructDef,
) -> any StructDefPart {
	FieldDef("start_from", type: .def(paginationToken))
		.doc("""
			An opaque string required for pagination, returned as
			``Result/nextFrom`` by the previous call of this method.
			Don’t pass this parameter when loading the news feed for
			the first time or refreshing it.
			""")

	FieldDef("count", type: .int)
		.doc("""
			How many updates to return, from 0 to 100.

			By default 25.
			""")
}

@StructDefBuilder
private func feedResult(
	paginationToken: StructDef,
	updatedItem: TaggedUnionDef,
	@StructDefBuilder additionalUpdateFields: () -> any StructDefPart,
) -> any StructDefPart {
	let updateID = IdentifierStruct("UpdateID", rawValue: .int)
	updateID

	let update = StructDef("Update") {
		FieldDef("item", type: .def(updatedItem))
			.required()
			.flatten()

		FieldDef("id", type: .def(updateID))
			.required()
			.id()
			.doc("Identifier of this update.")

		additionalUpdateFields()
	}
	update

	StructDef("Result") {
		FieldDef("items", type: .array(.def(update)))
			.required()
			.doc("The updates themselves.")

		FieldDef("profiles", type: .array(.def(user)))
			.required()
			.doc("User objects relevant to these updates.")

		FieldDef("groups", type: .array(.def(group)))
			.required()
			.doc("Group objects relevant to these updates.")

		FieldDef("next_from", type: .def(paginationToken))
			.doc("""
				The value to pass as ``startFrom`` in a subsequent call to
				this method to load the next page of the news feed.

				If this field is absent, no more updates are available.
				""")
	}
}
