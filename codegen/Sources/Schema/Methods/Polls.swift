let polls = Group("Polls") {
	RequestDef("polls.addVote", resultType: .void) {
		FieldDef("poll_id", type: .def(pollID))
			.required()
			.doc("Identifier of the poll.")
		FieldDef("answer_ids", type: .array(.def(pollOptionID)))
			.required()
			.doc("Comma-separated identifiers of the options to vote for.")
	}
	.doc("Votes in a poll on behalf of the current user.")
	.requiresPermissions("wall")
}
