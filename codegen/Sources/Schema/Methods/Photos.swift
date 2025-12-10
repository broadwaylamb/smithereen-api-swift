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

	RequestDef("photos.createAlbum", resultType: .def(photoAlbum)) {
		FieldDef("title", type: .string)
			.required()
			.doc("The title of the album.")

		FieldDef("description", type: .string)
			.doc("The description of the album.")

		FieldDef("group_id", type: .def(groupID))
			.doc("""
				If creating an album in a group, the identifier of that group.
				Omit this parameter to create an album in the currentuser’s
				profile.
				""")

		FieldDef("privacy_view", type: .def(privacySetting))
			.doc("""
				For a user-owned album, privacy setting determining who can
				view this album.
				By default, the album is publicly viewable.
				""")

		FieldDef("privacy_comment", type: .def(privacySetting))
			.doc("""
				For a user-owned album, privacy setting determining who can
				comment on photos in this album.
				By default, anyone can comment.
				""")

		FieldDef("upload_by_admins_only", type: .bool)
			.doc("""
				For a group-owned album, whether uploading new photos is
				restricted to group managers.

				By default `false`.
				""")

		FieldDef("comments_disabled", type: .bool)
			.doc("""
				For a group-owned album, whether commenting on photos in
				this album is disabled

				By default `false`..
				""")
	}
	.doc("Creates a new photo album.")
	.requiresPermissions("photos")

	RequestDef("photos.createComment", resultType: .def(commentID)) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo on which to comment.")

		FieldDef("reply_to_comment", type: .def(commentID))
			.doc("Identifier of the comment to reply to.")

		FieldDef("message", type: .string)
			.doc("""
				The text of the comment.
				**Required** if there are no attachments.
				This parameter supports formatted text, the format is
				determined by the ``textFormat`` parameter.
				""")

		FieldDef("text_format", type: .def(textFormat))
			.doc("""
				The format of the comment text passed in ``message``.
				By default, the user’s preference is used.
				""")

		FieldDef("attachments", type: .array(.def(attachmentToCreate)))
			.json()
			.doc("""
				An array representing the media attachments to be added to this post.
				**Required** if there is no message.
				""")

		FieldDef("content_warning", type: .string)
			.doc("""
				If this is not empty, make the content of the comment hidden
				by default, requiring a click to reveal.
				This text will be shown instead of the content.
				""")

		FieldDef("guid", type: .uuid)
			.doc("""
				A unique identifier used to prevent accidental double-posting
				on unreliable connections.
				If ``Photos/createComment`` was previously called with this
				``guid`` in the last hour, no new comment will be created,
				the ID of that previously created comment will be returned
				instead. Recommended for mobile apps.
				""")
	}
	.doc("""
		Creates a new comment on a photo.

		Returns the identifier of the newly created comment.
		""")
	.requiresPermissions("photos")

	RequestDef("photos.delete", resultType: .void) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")
	}
	.doc("Deletes a photo.")
	.requiresPermissions("photos")
}
