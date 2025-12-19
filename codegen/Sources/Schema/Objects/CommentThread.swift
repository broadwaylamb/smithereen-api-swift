private let commentTP = TypeParameterDef(name: "Comment", upperBound: TypeRef(name: "CommentProtocol"))

let commentThread = StructDef("CommentThread", typeParameters: [commentTP]) {
	FieldDef("count", type: .int)
		.required()
		.doc("The total number of comments in this branch.")

	FieldDef("reply_count", type: .int)
		.required()
		.doc("The total number of replies to this comment.")

	FieldDef("items", type: .array(.def(commentTP)))
		.required()
		.doc("The replies to this comment.")
}
