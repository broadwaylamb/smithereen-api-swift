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

	RequestDef("photos.createComment", resultType: .def(photoCommentID)) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo on which to comment.")

		commentCreationParameters(group: "Photos", replyToID: photoCommentID)
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
		FieldDef("comment_id", type: .def(photoCommentID))
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

	RequestDef("photos.editComment", resultType: .def(photoCommentID)) {
		FieldDef("comment_id", type: .def(photoCommentID))
			.required()
			.doc("The identifier of the comment to be updated.")

		commentParameters()
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
		revField()
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

	getUploadServerRequest("photos.getAttachmentUploadServer", parameters: {})
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
		FieldDef("comment_id", type: .def(photoCommentID))
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
		commentID: photoCommentID,
		comment: photoComment,
		targetField: FieldDef("photo_id", type: .def(photoID))
			.doc("The identifier of the photo.")
	)

	RequestDef("photos.getFeedEntry", resultType: .paginatedList(.def(photo))) {
		FieldDef("list_id", type: .def(photoFeedEntryID))
			.required()
			.doc("A list ID returned by ``Newsfeed/Get`` or ``Newsfeed/GetGroups``.")

		offsetAndCountParams("photo", defaultCount: 50)
		extendedField()
	}
	.doc("Returns a complete list of photos for a newsfeed entry.")

	RequestDef("photos.getNewTags", resultType: .paginatedList(.def(photo))) {
		offsetAndCountParams("photo", defaultCount: 50)
		extendedField()
	}
	.doc("Returns photos with unconfirmed tags of the current user.")

	getUploadServerRequest("photos.getOwnerPhotoUploadServer", parameters: {})
		.doc("""
			Returns a URL for uploading a new profile picture for the current
			user or a group they manage.

			If updating a group’s profile picture, `groups` permission is
			also required.
			""")

	let tagDef = StructDef("Tag") {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				Identifier of the tagged user. If the tag is unconfirmed or if
				it was created by entering a name instead of selecting a user
				from the friend list, this field will be absent.
				""")
		FieldDef("id", type: .def(photoTagID))
			.required()
			.id()
			.doc("Tag identifier.")
		FieldDef("placer_id", type: .def(userID))
			.required()
			.doc("Identifier of the user who created the tag.")
		FieldDef("name", type: .string)
			.required()
			.doc("The name of the tagged person.")
		FieldDef("area", type: .def(imageRect))
			.required()
			.flatten()
			.doc("The coordinates of the tag area.")
		FieldDef("date", type: .unixTimestamp)
			.required()
			.doc("When this tag was created.")
		FieldDef("confirmed", type: .bool)
			.doc("""
				Whether this tag was confirmed by the tagged user.
				`nil` iff ``userID`` is `nil`.
				""")
	}
	RequestDef("photos.getTags", resultType: .array(.def(tagDef))) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")

		tagDef
	}
	.doc("""
		Returns tags for a photo.

		Photos in non-public albums require a token and the `photos:read` permission.
		""")

	getUploadServerRequest("photos.getUploadServer") {
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("Identifier of the photo album to which to upload the photo.")
	}
	.doc("""
		Returns a URL for uploading a new photo to a photo album.

		Photos can’t be uploaded to system albums using this method.
		System albums are special and each has its own way of adding new photos.
		""")
	.requiresPermissions("photos")

	RequestDef("photos.getUserPhotos", resultType: .paginatedList(.def(photo))) {
		FieldDef("user_id", type: .def(userID))
			.doc("""
				Identifier of the user whose tagged photos need to be returned.

				By default, the current user. Required when called without a token.
				""")

		offsetAndCountParams("photo", defaultCount: 50)
		extendedField()
		revField()
	}
	.doc("""
		Returns photos that a user is tagged in.

		If the target user has the “who can see photos of me” privacy setting set
		to prevent public access, a token and the `photos:read` permission are required.
		""")

	RequestDef("photos.makeCover", resultType: .void) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("Identifier of the album.")
	}
	.doc("Sets a photo as the album cover.")
	.requiresPermissions("photos")

	RequestDef("photos.putTag", resultType: .def(photoTagID)) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")

		let taggeeDef = TaggedUnionDef(
			"Taggee",
			conformances: [.hashable, .encodable, .sendable],
		) {
			TaggedUnionVariantDef("user", payloadFieldName: "user_id", type: .def(userID))
				.doc("""
					Identifier of the user to tag.
					The user must be the current user’s friend.
					""")
			TaggedUnionVariantDef("name", payloadFieldName: "name", type: .string)
				.doc("""
					The name to tag. Pass instead of ``user`` to create a tag with
					just a name, without linking to anyone’s profile.
					""")
		}
		.frozen()
		.tagless()
		FieldDef("taggee", type: .def(taggeeDef))
			.required()
			.flatten()
			.doc("Who to tag.")
		taggeeDef
		FieldDef("area", type: .def(imageRect))
			.required()
			.flatten()
			.doc("The tag area.")
	}
	.doc("""
		Creates a new tag on a photo.

		You can only create tags on photos owned or uploaded to a group by
		the current user, or owned by a group managed by the current user.
		""")
	.requiresPermissions("photos")

	RequestDef("photos.removeTag", resultType: .void) {
		FieldDef("photo_id", type: .def(photoID))
			.required()
			.doc("Identifier of the photo.")
		FieldDef("tag_id", type: .def(photoTagID))
			.required()
			.doc("Identifier of the tag.")
	}
	.doc("Deletes a tag from a photo.")
	.requiresPermissions("photos")

	RequestDef("photos.save", resultType: .def(photo)) {
		FieldDef("album_id", type: .def(photoAlbumID))
			.required()
			.doc("Identifier of the photo album.")
		FieldDef("id", type: .def(uploadedImageID))
			.required()
			.doc("A parameter returned by the upload endpoint.")
		FieldDef("hash", type: .def(uploadedImageHash))
			.required()
			.doc("A parameter returned by the upload endpoint.")
		FieldDef("caption", type: .string)
			.doc("The caption for the photo.")
		FieldDef("text_format", type: .def(textFormat))
			.doc("The format of the text in ``caption``.")
	}
	.doc("Saves a newly uploaded photo to an album.")
	.requiresPermissions("photos")

	RequestDef("photos.saveOwnerPhoto", resultType: .def(photo)) {
		FieldDef("group_id", type: .def(groupID))
			.doc("If updating a group’s profile picture, identifier of that group.")
		FieldDef("id", type: .def(uploadedImageID))
			.required()
			.doc("A parameter returned by the upload endpoint.")
		FieldDef("hash", type: .def(uploadedImageHash))
			.required()
			.doc("A parameter returned by the upload endpoint.")
		FieldDef("cropRects", type: TypeRef(name: "AvatarCropRects"))
			.flatten()
			.doc("""
				If this parameter is `nil`:

				- The entire photo will be used for the rectangular version
				- The square will be taken from the top of the rectangular version
				  if it’s vertical, or from its center if it’s horizontal
				""")
	}
	.doc("Saves a newly uploaded profile picture")
	.requiresPermissions("photos")
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

private func revField() -> FieldDef {
	FieldDef("rev", type: .bool)
		.doc("""
			Whether to return the photos in reverse order.

			By default `false`.
			""")
}

private func getUploadServerRequest(_ name: String, @StructDefBuilder parameters: () -> any StructDefPart) -> RequestDef {
	RequestDef(name) {
		parameters()
		StructDef("Result") {
			FieldDef("upload_url", type: .url)
				.required()
				.doc("""
					The URL to which to send the POST request to
					[upload your image](https://smithereen.software/docs/api/uploads).
					""")
		}
	}
}
