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

extension TypeRef {
	static let int = TypeRef(Int.self)
	static let string = TypeRef(String.self)
	static let bool = TypeRef(Bool.self)
	static let url = TypeRef(URL.self)
	static let unixTimestamp = TypeRef(Date.self)
	static let timeZone = TypeRef(TimeZone.self)

	static let hashable = TypeRef(name: "Hashable")
	static let codable = TypeRef(name: "Codable")
	static let sendable = TypeRef(name: "Sendable")
	static let identifier = TypeRef(name: "Identifier")

	static let userID = TypeRef(name: "UserID")
}
