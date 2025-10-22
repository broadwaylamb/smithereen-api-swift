let serverRule = StructDef("ServerRule") {
	FieldDef("id", type: TypeRef(name: "ServerRuleID"))
		.required()
		.id()
	
	FieldDef("title", type: .string)
		.required()
		
	FieldDef("description", type: .string)
}

let serverSignupMode = EnumDef("ServerSignupMode") {
	EnumCaseDef("open")
	EnumCaseDef("closed")
	EnumCaseDef("invite_only")
	EnumCaseDef("manual_approval")
}
