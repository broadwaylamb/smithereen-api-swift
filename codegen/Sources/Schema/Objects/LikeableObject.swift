let likeableObject = TaggedUnionDef("LikeableObject") {
	TaggedUnionVariantDef("post", payloadFieldName: "item_id", type: .def(wallPostID))
	TaggedUnionVariantDef("photo", payloadFieldName: "item_id", type: .def(photoID))
	TaggedUnionVariantDef("photo_comment", payloadFieldName: "item_id", type: .def(photoCommentID))
	TaggedUnionVariantDef("topic_comment", payloadFieldName: "item_id", type: .def(topicCommentID))
}
.frozen()
