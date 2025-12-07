let photo = StructDef("Photo") {
	FieldDef("id", type: .def(photoID))
		.required()
		.id()
		.doc("The (server-wide) unique identifier of this photo.")
	
	activityPubIDField("photo")
	
	FieldDef("url", type: .url)
		.required()
			.doc("""
				The URL of the web page representing this photo.
				For photos uploaded by remote users, points to their home server.
				""")

	FieldDef("album_id", type: .def(albumID))
		.doc("If this photo is in an album, the identifier of that album.")
	
	FieldDef("owner_id", type: .def(actorID))
		.required()
		.doc("The identifier of the owner of this photo.")
	
	FieldDef("user_id", type: .def(userID))
		.doc("""
			For a photo in an album in a group, the identifier of the user
			who uploaded this photo to the album.
			""")

	FieldDef("text", type: .string)
		.doc("""
			A textual description of the photo. In case of post attachments,
			often used as an “alt text” to describe the image for
			the visually-impaired.
			""")
	
	FieldDef("date", type: .unixTimestamp)
		.required()
		.doc("The unixtime timestamp when this photo was uploaded.")
	
	blurhashField()

	FieldDef("has_tags", type: .bool)
		.required()
		.doc("Whether there are tagged people in this photo.")
	
	let sizeTypeEnum = EnumDef<String>("SizeType") {
		EnumCaseDef("s")
			.swiftName("thumbSmall")
			.doc("Scaled to fit into a 100x100 square")
		EnumCaseDef("m")
			.swiftName("thumbMedium")
			.doc("Scaled to fit into a 320x320 square")
		EnumCaseDef("x")
			.swiftName("small")
			.doc("Scaled to fit into a 640x640 square")
		EnumCaseDef("y")
			.swiftName("medium")
			.doc("Scaled to fit into a 800x800 square")
		EnumCaseDef("z")
			.swiftName("large")
			.doc("Scaled to fit into a 1280x1280 square")
		EnumCaseDef("w")
			.swiftName("original")
			.doc("Scaled to fit into a 2560x2560 square")
	}
	
	let sizeStruct = StructDef("Size") {
		FieldDef("url", type: .url)
			.required()
			.doc("""
				The URL of this image size.
				The format of the image is determined by the `image_format`
				global parameter.
				""")
		
		FieldDef("width", type: .int)
			.required()
			.doc("The width of this size in pixels.")
		
		FieldDef("height", type: .int)
			.required()
			.doc("The height of this size in pixels.")
		
		FieldDef("type", type: .def(sizeTypeEnum))
			.required()
			.doc("The designator for this size.")
	}

	FieldDef("sizes", type: .array(.def(sizeStruct)))
		.required()
		.doc("""
			An array describing the differently-sized images available for this
			photo.
			""")
	
	sizeTypeEnum
	sizeStruct

	FieldDef("width", type: .int)
		.required()
		.doc("The width of the largest-size image for this photo in pixels.")
	
	FieldDef("height", type: .int)
		.required()
		.doc("The height of the largest-size image for this photo in pixels.")
	
	FieldDef("likes", type: .def(likeInfo))
		.extendedFieldDoc("Information about likes of this photo.")
	
	FieldDef("comments", type: .int)
		.extendedFieldDoc("The total number of comments on this photo.")
	
	FieldDef("can_comment", type: .bool)
		.extendedFieldDoc("Whether the current user can comment on this photo.")
	
	FieldDef("tags", type: .int)
		.extendedFieldDoc("The total number of people tagged in this photo.")
}

extension FieldDef {
	func extendedFieldDoc(_ text: String) -> FieldDef {
		doc("""
			\(text)

			- Note: this field is returned by some `photos.*` methods
				which take the `extended` parameter, when that parameter is set
				to `true`.
			""")
	}
}
