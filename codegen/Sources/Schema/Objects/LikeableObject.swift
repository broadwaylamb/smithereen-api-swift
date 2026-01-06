let likeableObject = TaggedUnionDef("LikeableObject") {
	TaggedUnionVariantDef("post", payloadFieldName: "item_id", type: .def(wallPostID), convertPayloadFromString: true)
		.doc("Wall post or comment.")
	TaggedUnionVariantDef("photo", payloadFieldName: "item_id", type: .def(photoID))
		.doc("Photo.")
	TaggedUnionVariantDef("photo_comment", payloadFieldName: "item_id", type: .def(photoCommentID))
		.doc("A comment on a photo.")
	TaggedUnionVariantDef("topic_comment", payloadFieldName: "item_id", type: .def(topicCommentID))
		.doc("A comment in a discussion board topic.")
}
