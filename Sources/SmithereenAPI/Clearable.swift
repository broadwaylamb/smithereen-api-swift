import Foundation
import SmithereenAPIInternals

/// Some value that can be unspecified.
///
/// It's like `Optional`, but the ``unspecified`` value is
/// encoded as an empty string.
///
/// ``T`` must be encodable to a string value.
public enum Clearable<T> {
	case unspecified
	case specified(T)
}

extension Clearable: Equatable where T: Equatable {}
extension Clearable: Hashable where T: Hashable {}
extension Clearable: Sendable where T: Sendable {}

extension Clearable: Encodable where T: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		let unspecifiedMagicValue = (T.self as? HasUnspecifiedMagicValue.Type)?
			.unspecifiedMagicValue ?? ""
		switch self {
		case .unspecified:
			try container.encode(unspecifiedMagicValue)
		case .specified(let value as Date):
			try UnixTimestamp(wrappedValue: value).encode(to: encoder)
		case .specified(let value as URL):
			try URLAsString(wrappedValue: value).encode(to: encoder)
		case .specified(let value):
			try value.encode(to: encoder)
		}
	}
}

extension Clearable: Decodable where T: Decodable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(String.self)
		let unspecifiedMagicValue = (T.self as? HasUnspecifiedMagicValue.Type)?
			.unspecifiedMagicValue ?? ""
		if value == unspecifiedMagicValue {
			self = .unspecified
		} else if T.self is Date.Type {
			self = .specified(try UnixTimestamp<Date>(from: decoder).wrappedValue as! T)
		} else if T.self is URL.Type {
			self = .specified(try URLAsString<URL>(from: decoder).wrappedValue as! T)
		} else {
			self = .specified(try T(from: decoder))
		}
	}
}

private protocol HasUnspecifiedMagicValue {
	static var unspecifiedMagicValue: String { get }
}

extension Birthday: HasUnspecifiedMagicValue {
	static var unspecifiedMagicValue: String { "" }
}

extension User.Gender: HasUnspecifiedMagicValue {
	static var unspecifiedMagicValue: String { "none" }
}

extension User.RelationshipStatus: HasUnspecifiedMagicValue {
	static var unspecifiedMagicValue: String { "none" }
}
