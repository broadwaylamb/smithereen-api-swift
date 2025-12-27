let polls = Group("Polls") {
	apiMethod("polls.addVote", resultType: .void) {
		FieldDef("poll_id", type: .def(pollID))
			.required()
			.doc("Identifier of the poll.")
		FieldDef("answer_ids", type: .array(.def(pollOptionID)))
			.required()
			.doc("Comma-separated identifiers of the options to vote for.")
	}
	.doc("Votes in a poll on behalf of the current user.")
	.requiresPermissions("wall")

	apiMethod("polls.create", resultType: .def(pollID)) {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				User or group identifier of the owner on whose wall
				the poll will be posted.

				Current user by default.
				""")
		FieldDef("question", type: .string)
			.required()
			.doc("The poll question.")
		FieldDef("answers", type: .array(.string))
			.json()
			.required()
			.doc("Poll options, 2 to 10 strings.")
		FieldDef("anonymous", type: .bool)
			.doc("""
				Whether the list of people who voted for each option
				is hidden.

				By default `false`.
				""")
		FieldDef("multiple", type: .bool)
			.doc("""
				Whether this poll is multiple-choice.

				By default `false`.
				""")
		FieldDef("end_date", type: .unixTimestamp)
			.doc("""
				The time when this poll stops accepting new votes.

				By default, or if this parameter is in the past,
				the poll does not end.
				""")
	}
	.doc("Creates a poll to later attach to a post.")
	.requiresPermissions("wall")

	apiMethod("polls.getById", resultType: .def(poll)) {
		FieldDef("poll_id", type: .def(pollID))
			.required()
			.doc("The identifier of the poll.")
	}
	.doc("Returns a poll.")

	apiMethod("polls.getVoters", resultType: .paginatedList(.def(userID))) {
		FieldDef("poll_id", type: .def(pollID))
			.required()
			.doc("Poll identifier.")
		FieldDef("answer_id", type: .def(pollOptionID))
			.required()
			.doc("Poll option identifier.")
		offsetAndCountParams("user", defaultCount: 100)
	}
	.doc("Returns a list of users who voted for a specific option in a poll.")
	.withUserFields()
}
