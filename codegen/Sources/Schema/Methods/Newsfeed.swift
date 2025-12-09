let newsfeed = Group("Newsfeed") {
	RequestDef("newsfeed.get") {
		let paginationToken = IdentifierStruct("PaginationToken", rawValue: .string)
		paginationToken

		let filter = EnumDef<String>("Filter") {
			EnumCaseDef("post")
				.doc("Wall posts and reposts.")
			EnumCaseDef("photo")
				.doc("New photos added to albums.")
			EnumCaseDef("photo_tag")
				.doc("New photo tags.")
			EnumCaseDef("friend")
				.doc("New friends")
			EnumCaseDef("group")
				.doc("Groups joined or created")
			EnumCaseDef("event")
				.doc("Events joined or created")
			EnumCaseDef("board")
				.doc("New discussion board topics in groups")
			EnumCaseDef("relation")
				.doc("Relationship status changes")
		}
		.frozen()

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
		
		FieldDef("start_from", type: .def(paginationToken))
			.doc("""
				An opaque string required for pagination, returned as
				``Result/nextFrom`` by the previous call of this method.
				Don’t pass this parameter when loading the news feed for
				the first time or refreshing it.
				""")
		
		FieldDef("count", type: .int)
			.doc("""
				How many updates to return.

				By default 25.
				""")
		
		FieldDef("fields", type: .array(.def(actorField)))
			.doc("A list of user and group profile fields to return.")
		
		let photoUpdateStruct = StructDef("PhotoUpdate") {
			FieldDef("count", type: .int)
				.required()
				.doc("How many photos were added or tagged in total.")
			FieldDef("items", type: .array(.def(photo)))
				.required()
				.doc("Up to 10 photo objects.")
			FieldDef("list_id", type: .def(photoFeedEntryID))
				.required()
				.doc("""
					An identifier to retrieve the complete list of photos that
					were added or tagged using ``Photos/GetFeedEntry``.
					""")
		}
		.doc("The information about photos the user added or was tagged in.")
		photoUpdateStruct

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
			TaggedUnionVariantDef("post", type: .def(wallPost))
				.doc("A new wall post was created.")
			let photoUpdates = [
				("photo", "New photos were uploaded."),
				("photo_tag", "The user was tagged in some photos."),
			]
			for (photoUpdate, doc) in photoUpdates {
				TaggedUnionVariantDef(
					photoUpdate,
					payloadFieldName: "photos",
					type: .def(photoUpdateStruct)
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
		
		let update = StructDef("Update") {
			FieldDef("item", type: .def(updatedItem))
				.required()
				.flatten()
			
			FieldDef("user_id", type: .def(userID))
				.required()
				.doc("Which user this update is about.")
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
}
