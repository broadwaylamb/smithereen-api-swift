let userID = IdentifierStruct("UserID", rawValue: .int)
let friendListID = IdentifierStruct("FriendListID", rawValue: .int)
let photoID = IdentifierStruct("PhotoID", rawValue: .string)
let serverRuleID = IdentifierStruct("ServerRuleID", rawValue: .int)

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

let deactivatedStatus = EnumDef("DeactivatedStatus") {
	EnumCaseDef("banned")
		.doc("The user's account or the group is frozen or suspended.")
	EnumCaseDef("hidden")
		.doc("""
			The server staff made this profile/group only visible to
			authenticated users.
			""")
	EnumCaseDef("deleted")
		.doc("""
			The user has deleted their own profile,
			or the group was deleted by its creator.
			""")
}
.doc("""
	For restricted users and groups, their restriction status.
	""")

func deactivatedStatusField(_ entity: String) -> FieldDef {
	FieldDef("deactivated", type: .def(deactivatedStatus))
		.excludeFromFields()
		.doc("""
			For restricted \(entity)s, their restriction status.
			If this is set, none of the optional fields will be returned.
			""")
}

func activityPubIDField(_ entity: String) -> FieldDef {
	FieldDef("ap_id", type: .url)
		.excludeFromFields()
		.swiftName("activityPubID")
		.doc(
			"""
			Globally unique ActivityPub identifier for this \(entity).
			Use this to match \(entity)s across servers.

			Always non-nil for Smithereen, always nil for OpenVK
			""")
}

@StructDefBuilder
func profilePictureFields(_ entity: String) -> any StructDefPart {
	for size in photoSizes(50, 100, 200, 400, .max) {
		let doc = size == "max" 
			? nil 
			: "URL of a square \(size)x\(size) version of the profile picture."
		FieldDef("photo_\(size)", type: .url)
			.optionalFieldDoc(doc, objectName: entity.capitalized)
	}

	for size in photoSizes(200, 400, .max) {
		let doc = size == "max"
			? nil
			: "URL of a rectangular \(size)px wide version of the profile picture."
		FieldDef("photo_\(size)_orig", type: .url)
			.optionalFieldDoc(doc, objectName: entity.capitalized)
	}

	FieldDef("photo_id", type: .def(photoID))
		.optionalFieldDoc("""
			If this \(entity) has a “profile pictures” system photo album,
			ID of the photo used for the current profile picture in that album.
			""", objectName: entity.capitalized)
}

private func photoSizes(_ s: Int...) -> [String] {
	s.map {
		if $0 == .max {
			return "max"
		} else {
			return String($0)
		}
	}
}

extension Documentable {
	func optionalFieldDoc(_ text: String?, objectName: String) -> Self {
		guard let text else { return self }
		return self.doc("""
			\(text)

			- Note: This is an **optional** field.
			Request it by passing it in `fields` to any method that returns
			``\(objectName)`` objects.
			""")
	}
}