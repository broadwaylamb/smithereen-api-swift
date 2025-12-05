let graffiti = StructDef("Graffiti") {
	FieldDef("url", type: .url)
		.required()
		.doc("The URL of the full-size graffiti image.")
	
	FieldDef("preview_url", type: .url)
		.required()
		.doc("The URL of the smaller graffiti image for preview purposes.")
	
	FieldDef("width", type: .int)
		.required()
		.doc("The width of the graffiti.")
	
	FieldDef("height", type: .int)
		.required()
		.doc("The height of the graffiti.")
}
.doc("Only exists on top-level wall posts.")