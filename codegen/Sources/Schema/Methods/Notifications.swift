let notifications = Group("Notifications") {

	FileDef("Notifications.Get") {
		apiMethod("notifications.get") {
			offsetAndCountParams("notification", range: 1...100, defaultCount: 50)

			FieldDef("max_id", type: .def(notificationID))
				.doc("""
					The identifier of the most recent notification known to
					the client. Use this to get a consistent view of the list
					even if new notifications were added between requests for
					subsequent pages.
					""")

			StructDef("Notification") {
				FieldDef("id", type: .def(notificationID))
					.required()
					.id()
					.doc("""
						Identifier of this notification.
						The newer the notification, the greater the identifier.
						""")
				FieldDef("event", type: TypeRef(name: "Event"))
					.required()
					.flatten()

				FieldDef("date", type: .unixTimestamp)
					.required()
					.doc("The time when this notification was created.")
			}
		}
		.doc("Returns the current user's notifications.")
		.requiresPermissions("notifications")

		StructDef("Notifications.Get.Event.UserIDs") {
			FieldDef("count", type: .int)
				.required()
				.doc("How many users there are total.")
			FieldDef("items", type: .array(.def(userID)))
				.required()
				.doc("Identifiers of the most recent 10 users.")
		}
		.doc("""
			For groupable notifications: information about users that did
			the action.
			""")
	}
}
