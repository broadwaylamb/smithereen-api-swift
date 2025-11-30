let poll = StructDef("Poll") {
    FieldDef("id", type: .def(pollID))
        .id()
        .required()
        .doc("The identifier of this poll.")

    FieldDef("owner_id", type: .def(actorID))
        .required()
        .doc("The identifier of the owner of this poll.")
    
    FieldDef("created", type: .unixTimestamp)
        .required()
        .doc("The timestamp when this poll was created, as unixtime.")
    
    FieldDef("question", type: .string)
        .doc("The text of the question.")
    
    FieldDef("votes", type: .int)
        .required()
        .doc("The total number of votes.")
    
    let answerStruct = StructDef("Answer") {
        FieldDef("id", type: .def(pollOptionID))
            .id()
            .required()
            .doc("Identifier of this option.")
        
        FieldDef("text", type: .string)
            .required()
            .doc("The text of the option.")
        
        FieldDef("votes", type: .int)
            .required()
            .doc("The number of people who voted for this option.")
        
        FieldDef("rate", type: .double)
            .required()
            .doc("The percentage of people who voted for this option.")
    }

    FieldDef("answers", type: .array(.def(answerStruct)))
        .required()
        .doc("An array of objects describing the poll options.")
    answerStruct

    FieldDef("anonymous", type: .bool)
        .required()
        .doc("""
            Whether this poll is anonymous (i.e. no one can see who voted on it
            and for what).
            """)
    
    FieldDef("multiple", type: .bool)
        .required()
        .doc("Whether this poll is multiple-choice.")
    
    FieldDef("answer_ids", type: .array(.def(pollOptionID)))
        .doc("""
            If the current user has voted in this poll, the IDs of the options
            they voted for.
            """)
    
    FieldDef("end_date", type: .unixTimestamp)
        .required()
        .doc("""
            The timestamp when this poll ends, in unixtime.
            0 if the poll does not end.
            """)
    
    FieldDef("closed", type: .bool)
        .required()
        .doc("Whether this poll has ended.")
    
    FieldDef("can_edit", type: .bool)
        .required()
        .doc("Whether the current user can edit this poll.")
    
    FieldDef("can_vote", type: .bool)
        .required()
        .doc("Whether the current user can vote in this poll.")
    
    FieldDef("author_id", type: .def(actorID))
        .required()
        .doc("The identifier of the author of this poll.")
}
.doc("A poll attached to a wall post.")