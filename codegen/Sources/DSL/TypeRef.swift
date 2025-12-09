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

	static let hashable = TypeRef(name: "Hashable")
	static let encodable = TypeRef(name: "Encodable")
	static let codable = TypeRef(name: "Codable")
	static let sendable = TypeRef(name: "Sendable")
	static let identifier = TypeRef(name: "Identifier")

	static let blurhash = TypeRef(name: "BlurHash")

	static func paginatedList(_ element: TypeRef) -> TypeRef {
		return TypeRef(name: "PaginatedList<\(element)>")
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
