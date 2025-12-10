let photoAlbum = StructDef("PhotoAlbum") {
	FieldDef("id", type: .def(photoAlbumID))
		.required()
		.id()
		.doc("Unique (server-wide) identifier of this photo album.")

	activityPubIDField("album")

	FieldDef("url", type: .url)
		.required()
		.doc("""
			The URL of the web page representing this album.
			For albums owned by remote actors, points to their home server.
			""")

	FieldDef("owner_id", type: .def(actorID))
		.required()
		.doc("User or group identifier of this album’s owner.")

	FieldDef("is_system", type: .bool)
		.required()
		.doc("""
			Whether this is a system album. System albums are those which have
			special purposes, like “profile pictures” or “saved photos”.
			They can’t be edited or deleted, and photos can’t be arbitrarily
			uploaded to them.
			""")

	FieldDef("title", type: .string)
		.required()
		.doc("The title of this album.")

	FieldDef("description", type: .string)
		.doc("The description of this album.")

	FieldDef("cover_id", type: .def(photoID))
		.doc("Identifier of the photo which is this album’s cover.")

	FieldDef("created", type: .unixTimestamp)
		.required()
		.doc("The timestamp when this album was created.")

	FieldDef("updated", type: .unixTimestamp)
		.required()
		.doc("The timestamp when this album was last updated.")

	FieldDef("size", type: .int)
		.required()
		.doc("The number of photos in this album.")

	FieldDef("cover", type: .def(photo))
		.doc("""
			If `need_covers` was `true`, an object representing
			this album’s cover photo.
			""")

	FieldDef("privacy_view", type: .def(privacySetting))
		.doc("""
			Privacy setting determining who can see this album.

			Only returned for current user's non-system albums.
			""")

	FieldDef("privacy_comment", type: .def(privacySetting))
		.doc("""
			Privacy setting determining who can comment on photos in this album.

			Only returned for current user's non-system albums.
			""")

	FieldDef("can_upload", type: .bool)
		.doc("""
			Whether the current user can upload new photos to this album.

			Only returned for non-system group albums.
			""")

	FieldDef("uploads_by_admins_only", type: .bool)
		.doc("""
			Whether uploading new photos to this album is restricted to the group managers.

			Only returned for non-system albums in groups managed by the current user.
			""")

	FieldDef("comments_disabled", type: .bool)
		.doc("""
			Whether commenting on photos in this album is disabled.

			Only returned for non-system albums in groups managed by the current user.
			""")
}
