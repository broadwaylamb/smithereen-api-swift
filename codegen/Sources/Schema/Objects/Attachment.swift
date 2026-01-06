let attachment = TaggedUnionDef("Attachment") {
	TaggedUnionVariantDef("photo", type: .def(photo))
		.doc("The attachment is a photo.")
	TaggedUnionVariantDef("graffiti", type: .def(graffiti))
		.doc("The attachment is a graffiti. Only exists on top-level wall posts.")
	TaggedUnionVariantDef("video", type: .def(video))
		.doc("The attachment is a video")
	TaggedUnionVariantDef("audio", type: .def(audio))
		.doc("The attachment is an audio")
	TaggedUnionVariantDef("poll", type: .def(poll))
		.doc("The attachment is a poll.")
}
.doc("A media attachment to a wall post, a comment, or a private message.")
