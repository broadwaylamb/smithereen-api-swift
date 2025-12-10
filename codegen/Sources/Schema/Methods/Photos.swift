let photos = Group("Photos") {
	RequestDef("photos.getAttachmentUploadServer") {
		StructDef("Result") {
			FieldDef("upload_url", type: .url)
				.required()
				.doc("""
					The URL to which to send the POST request to
					[upload your image](https://smithereen.software/docs/api/uploads).
					""")
		}
	}
	.doc("""
		Get the information required for uploading an image to be attached
		to a wall post, comment, or message.
		""")

	RequestDef("photos.confirmTag", resultType: .void) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")

		FieldDef("tag_id", type: .def(photoTagID))
			.required()
			.doc("Identifier of the tag.")
	}
	.doc("Confirms the current user’s tag on a photo.")
	.requiresPermissions("photos")
}
