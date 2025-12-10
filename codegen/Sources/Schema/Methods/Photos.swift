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

	RequestDef("photos.copy", resultType: .def(photoID)) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("The identifier of the photo to be copied.")
	}
	.doc("""
		Saves a copy of a photo to the current user’s “Saved photos” album.

		Returns the identifier of the photo that was created in
		the “Saved photos” album.
		""")
	.requiresPermissions("photos")
}
