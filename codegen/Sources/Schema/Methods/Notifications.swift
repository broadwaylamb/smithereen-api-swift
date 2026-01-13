let notifications = Group("Notifications") {
	apiMethod("notifications.get") {
		offsetAndCountParams("notification", range: 1...100, defaultCount: 50)
		FieldDef("max_id", type: .def(notificationID))
			.doc("""
				The identifier of the most recent notification known to the client.
				Use this to get a consistent view of the list even if new
				notifications were added between requests for subsequent pages.
				""")

		StructDef("Result") {
			FieldDef("items", type: .array(.def(notification)))
				.required()
				.doc("Notifications themselves.")
			FieldDef("wall_posts", type: .array(.def(wallPost)))
				.required()
				.doc("Wall post objects referenced in ``items``.")
			FieldDef("wall_comments", type: .array(.def(wallPost)))
				.required()
				.doc("Wall comment objects referenced in ``items``.")
			FieldDef("photo_comments", type: .array(.def(photoComment)))
				.required()
				.doc("Photo comment objects referenced in ``items``.")
			FieldDef("board_comments", type: .array(.def(topicComment)))
				.required()
				.doc("Discussion board comment objects referenced in ``items``.")
			FieldDef("photos", type: .array(.def(photo)))
				.required()
				.doc("Photo objects referenced in ``items``.")
			FieldDef("board_topics", type: .array(.def(boardTopic)))
				.required()
				.doc("Discussion board topic objects referenced in items.")
			FieldDef("profiles", type: .array(.def(user)))
				.required()
				.doc("``User`` objects relevant to these notifications.")
			FieldDef("groups", type: .array(.def(group)))
				.required()
				.doc("``Group`` objects relevant to these notifications.")
			FieldDef("last_viewed", type: .def(notificationID))
				.required()
				.doc("The identifier of the most recent notification seen by the user.")
		}
	}
	.doc("Returns the current user's notifications.")
	.requiresPermissions("notifications")
}
