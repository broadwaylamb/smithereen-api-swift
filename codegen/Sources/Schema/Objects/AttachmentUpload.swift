let attachmentToCreate = TaggedUnionDef("AttachmentToCreate") {
	let imageDef = StructDef("Image") {
		FieldDef("file_id", type: .def(uploadedImageID))
			.required()
			.doc("""
				The identifier returned by the upload endpoint after
				[uploading the image](https://smithereen.software/docs/api/uploads).
				""")
		FieldDef("hash", type: .def(uploadedImageHash))
			.required()
			.doc("""
				The hash returned by the upload endpoint after
				[uploading the image](https://smithereen.software/docs/api/uploads).
				""")
		FieldDef("text", type: .string)
			.doc("An optional caption or alt text for this image.")
	}
	imageDef

	TaggedUnionVariantDef("image", type: .def(imageDef))
		.flatten()
		.doc("An image file that is not a photo that belongs to a photo album.")
	TaggedUnionVariantDef("photo", payloadFieldName: "photo_id", type: .def(photoID))
		.doc("A photo from an album.")
	TaggedUnionVariantDef("poll", payloadFieldName: "poll_id", type: .def(pollID))
		.doc("""
			A poll. The associated value is the identifier of the poll returned by
			``Polls/Create``
			""")
}
