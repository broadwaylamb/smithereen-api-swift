let board = Group("Board") {
	RequestDef("board.closeTopic", resultType: .void) {
		FieldDef("topic_id", type: .def(boardTopicID))
			.required()
			.doc("The topic identifier.")
	}
	.doc("Closes a topic so that no more comments could be posted.")
}
