let photos = Group("Photos") {
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

		commentContent()

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

	RequestDef("photos.deleteAlbum", resultType: .void) {
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("Identifier of the album to delete.")
	}
	.doc("Deletes a photo album.")
	.requiresPermissions("photos")

	RequestDef("photos.deleteComment", resultType: .void) {
		FieldDef("comment_id", type: .def(commentID))
			.required()
			.doc("Identifier of the comment to delete.")
	}
	.doc("Deletes a comment on a photo.")
	.requiresPermissions("photos")

	RequestDef("photos.edit", resultType: .void) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo to be updated.")
		FieldDef("caption", type: .string)
			.doc("The new caption.")
		FieldDef("text_format", type: .def(textFormat))
			.doc("The format of the text in ``caption``.")
	}
	.doc("Updates the caption of a photo.")
	.requiresPermissions("photos")

	RequestDef("photos.editAlbum", resultType: .void) {
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("Identifier of the target album.")

		FieldDef("title", type: .string)
			.doc("New title of the album.")

		FieldDef("description", type: .string)
			.doc("New description of the album.")

		FieldDef("privacy_view", type: .def(privacySetting))
			.json()
			.doc("""
				For a user-owned album, privacy setting determining
				who can view this album.
				""")

		FieldDef("privacy_comment", type: .def(privacySetting))
			.json()
			.doc("""
				For a user-owned album, privacy setting determining
				who can comment on photos in this album.
				""")

		FieldDef("upload_by_admins_only", type: .bool)
			.doc("""
				For a group-owned album, whether uploading new photos
				is restricted to group managers.
				""")

		FieldDef("comments_disabled", type: .bool)
			.doc("""
				For a group-owned album, whether commenting on photos
				in this album is disabled.
				""")
	}
	.doc("Updates a photo album.")
	.requiresPermissions("photos")

	RequestDef("photos.editComment", resultType: .def(commentID)) {
		FieldDef("comment_id", type: .def(commentID))
			.required()
			.doc("The identifier of the comment to be updated.")

		commentContent()
	}
	.doc("Edits a comment on a photo.")
	.requiresPermissions("photos")

	RequestDef("photos.get", resultType: .paginatedList(.def(photo))) {
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("""
				Identifier of the photo album.

				For system albums, pass ``PhotoAlbumID/profile`` or ``PhotoAlbumID/saved`` here.
				""")

		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				When getting photos from a system album, whose album it is.

				If omitted, returns the system album for the current user.
				""")

		offsetAndCountParams("photo", defaultCount: 50)
		extendedField()

		FieldDef("rev", type: .bool)
			.doc("""
				Whether to return the photos in reverse order.

				By default `false`.
				""")
	}
	.doc("""
		Returns photos from an album.

		Non-public albums require a token and the `photos:read` permission.
		""")

	RequestDef("photos.getAlbums", resultType: .paginatedList(.def(photoAlbum))) {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				Identifier of the user or minus identifier of the group whose
				albums need to be returned.

				Current user by default. Required if called without a token.
				""")

		offsetAndCountParams("album", defaultCount: nil)

		FieldDef("need_system", type: .bool)
			.doc("""
				Whether to return system albums (profile pictures, saved photos,
				etc).

				By default `false`.
				""")
		needCoversField()
	}
	.doc("""
		Returns a user’s or group’s photo albums.

		Getting non-public albums requires a token with `photos:read` permission.
		""")

	RequestDef("photos.getAlbumsById", resultType: .array(.def(photoAlbum))) {
		FieldDef("album_ids", type: .array(.def(photoAlbumID)))
			.required()
			.doc("A list of up to 100 album identifiers.")

		needCoversField()
	}
	.doc("""
		Returns photo albums.

		Getting non-public albums requires a token with `photos:read` permission.
		""")

	RequestDef("photos.getAll", resultType: .paginatedList(.def(photo))) {
		FieldDef("owner_id", type: .def(actorID))
			.doc("""
				Identifier of the user or group whose albums need to be returned.

				Current user by default. Required if called without a token.
				""")

		offsetAndCountParams("photo", defaultCount: 50)
		extendedField()
	}
	.doc("""
		Returns a user’s or group’s photo albums.

		Getting non-public albums requires a token with `photos:read` permission.
		""")

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

	RequestDef("photos.getById", resultType: .array(.def(photo))) {
		FieldDef("photo_ids", type: .array(.def(photoID)))
			.required()
			.doc("""
				A list of up to 1000 photo identifiers.
				""")
		extendedField()
	}
	.doc("""
		Returns photos.

		Photos that are in non-public albums require a token and
		the `photos:read` permission.
		""")


	RequestDef("photos.getCommentEditSource") {
		FieldDef("comment_id", type: .def(commentID))
			.required()
			.doc("""
				The identifier of the comment for which the source needs
				to be returned.
				""")

		StructDef("Result") {
			FieldDef("text", type: .string)
				.doc("The text itself.")
			FieldDef("format", type: .def(textFormat))
				.required()
				.doc("The format of the text.")
			FieldDef("attachments", type: .array(.def(attachmentToCreate)))
				.required()
				.doc("The array of input attachment objects.")
		}
	}
	.doc("""
		Returns the source of the text and attachments of a comment,
		as submitted when creating it, so they could be used for editing.
		""")
	.requiresPermissions("photos")

	commentsRequest(
		"photos.getComments",
		commentID: commentID,
		targetField: FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("The identifier of the photo.")
	)
}

@StructDefBuilder
private func commentContent() -> any StructDefPart {
	FieldDef("message", type: .string)
		.doc("""
			The text of the comment.
			**Required** if there are no ``attachments``.
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
			**Required** if there is no ``message``.
			""")

	FieldDef("content_warning", type: .string)
		.doc("""
			If this is not empty, make the content of the comment hidden
			by default, requiring a click to reveal.
			This text will be shown instead of the content.
			""")
}

private func needCoversField() -> FieldDef {
	FieldDef("need_covers", type: .bool)
		.doc("""
			Whether to return a cover photo for each album.

			By default `false`.
			""")
}

private func extendedField() -> FieldDef {
	FieldDef("extended", type: .bool)
		.doc("""
			Whether to return extra fields about likes, comments,
			and tags for each photo.

			By default `false`.
			""")
}
