import Foundation

struct TypeRef: Equatable {
	var name: String
	var isOptional: Bool = false
}

extension TypeRef {
	init(_ type: Any.Type) {
		self.name = String(describing: type)
	}

	func optional(_ optional: Bool = true) -> TypeRef {
		copyWith(self, \.isOptional, optional)
	}
}

extension TypeRef: CustomStringConvertible {
	var description: String {
		name + (isOptional ? "?" : "")
	}
}

extension TypeRef {
	static let void = TypeRef(Void.self)
	static let int = TypeRef(Int.self)
	static let double = TypeRef(Double.self)
	static let string = TypeRef(String.self)
	static let bool = TypeRef(Bool.self)
	static let url = TypeRef(URL.self)
	static let unixTimestamp = TypeRef(Date.self)
	static let timeZone = TypeRef(TimeZone.self)
	static let uuid = TypeRef(UUID.self)

	static let hashable = TypeRef(name: "Hashable")
	static let encodable = TypeRef(name: "Encodable")
	static let decodable = TypeRef(name: "Decodable")
	static let codable = TypeRef(name: "Codable")
	static let sendable = TypeRef(name: "Sendable")
	static let identifier = TypeRef(name: "Identifier")
	static let rawRepresentable = TypeRef(name: "RawRepresentable")

	static let blurhash = TypeRef(name: "BlurHash")
	static let likeableObject = TypeRef(name: "LikeableObject")

	static let paginatedListEmptyExtras =
		TypeRef(name: "PaginatedListExtras.Empty")
	static let paginatedListExtrasProfiles =
		TypeRef(name: "PaginatedListExtras.Profiles")
	static let paginatedListExtrasProfilesAndGroups =
		TypeRef(name: "PaginatedListExtras.ProfilesAndGroups")
	static let paginatedListExtrasCommentView =
		TypeRef(name: "PaginatedListExtras.CommentView")
	static let paginatedListExtrasCommentViewWithProfilesAndGroups =
		TypeRef(name: "PaginatedListExtras.CommentViewWithProfilesAndGroups")

	static func paginatedList(
		_ element: TypeRef,
		extras: TypeRef = .paginatedListEmptyExtras
	) -> TypeRef {
		return TypeRef(name: "PaginatedList<\(element), \(extras)>")
	}

	static func array(_ element: TypeRef) -> TypeRef {
		return TypeRef(name: "[\(element)]")
	}

	static func dict(key: TypeRef, value: TypeRef) -> TypeRef {
		return TypeRef(name: "[\(key) : \(value)]")
	}

	static func def(_ s: StructDef) -> TypeRef {
		return TypeRef(name: s.name)
	}

	static func def<RawValue: Sendable>(_ s: EnumDef<RawValue>) -> TypeRef {
		return TypeRef(name: s.name)
	}

	static func def(_ s: TaggedUnionDef) -> TypeRef {
		return TypeRef(name: s.name)
	}
}
