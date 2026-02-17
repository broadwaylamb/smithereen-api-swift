let captchaSID = IdentifierStruct("CaptchaSID", rawValue: .string)

let captcha = StructDef("Captcha") {
	FieldDef("url", type: .url)
		.required()
		.doc("The URL of the image to display.")
	FieldDef("width", type: .int)
		.required()
		.doc("The width of the captcha image.")
	FieldDef("height", type: .int)
		.required()
		.doc("The height of the captcha image.")
	FieldDef("sid", type: .def(captchaSID))
		.required()
		.doc("An opaque string that you need to pass back to the server in ``CaptchaAnswer/sid``.")
	FieldDef("hint", type: .string)
		.required()
		.doc("""
			A localized description of what the user needs to do to be displayed in the UI,
			e.g. enter the code from the image.
			""")
}

let captchaAnswer = StructDef("CaptchaAnswer") {
	FieldDef("captcha_sid", type: .def(captchaSID))
		.required()
		.swiftName("sid")
	FieldDef("captcha_answer", type: .string)
		.required()
		.swiftName("answer")
}
