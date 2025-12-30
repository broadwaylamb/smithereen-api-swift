import Foundation
import SmithereenAPIInternals

public struct Birthday: Hashable, Codable, Sendable, CustomStringConvertible {
	public var day: Int
	public var month: Int
	public var year: Int?

	public init(day: Int, month: Int, year: Int?) {
		self.day = day
		self.month = month
		self.year = year
	}

	public var description: String {
		if let year {
			return "\(day).\(month).\(year)"
		} else {
			return "\(day).\(month)"
		}
	}

	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(description)
	}

	public init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		let components = try container.decode(String.self).split(separator: ".", maxSplits: 2)
		let error = "Invalid date, expected format DD.MM.YYYY or DD.MM"
		if components.count >= 2 || components.count <= 3 {
			day = try parseInt(components[0], container, error: error)
			month = try parseInt(components[1], container, error: error)
			if components.count == 3 {
				year = try parseInt(components[2], container, error: error)
			}
		} else {
			throw DecodingError.dataCorruptedError(in: container, debugDescription: error)
		}
	}
}

extension User.RelationshipStatus {
	public var canHavePartner: Bool {
		switch self {
		case .single, .activelySearching:
			return false
		default:
			return true
		}
	}

	public var needsPartnerApproval: Bool {
		return canHavePartner && self != .inLove
	}
}

extension ActorID {
	public init(_ userID: UserID) {
		self.init(rawValue: Int32(userID.rawValue))
	}

	public init(_ groupID: GroupID) {
		self.init(rawValue: Int32(groupID.rawValue))
	}

	public var userID: UserID? {
		if rawValue > 0 {
			return UserID(rawValue: UInt32(rawValue))
		}
		return nil
	}

	public var groupID: GroupID? {
		if (rawValue < 0) {
			return GroupID(rawValue: UInt32(-rawValue))
		}
		return nil
	}

	public func map<R>(userID: (UserID) -> R, groupID: (GroupID) -> R) -> R {
		if rawValue >= 0 {
			return userID(UserID(rawValue: UInt32(rawValue)))
		} else {
			return groupID(GroupID(rawValue: UInt32(-rawValue)))
		}
	}
}

public struct BlurHash: Hashable, Sendable {
	public var string: String // TODO: Make byte array-backed?

	public init(string: String) throws {
		self.string = string
	}
}

extension BlurHash: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(string)
	}
}

extension BlurHash: Decodable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		try self.init(string: container.decode(String.self))
	}
}

extension Photo.SizeType {
	public var maxSize: Int {
		switch self {
		case .thumbSmall:
			return 100
		case .thumbMedium:
			return 320
		case .small:
			return 640
		case .medium:
			return 800
		case .large:
			return 1280
		case .original:
			return 2560
		default:
			return 0
		}
	}
}

extension Friends.GetRequests {
	@available(
		*,
		deprecated,
		message: "You need to pass at least one argument to 'extended'"
	)
	public func extended() -> Extended {
		extended(extended: nil, needMutual: nil, fields: nil)
	}
}

extension ActorField {
	public init(_ userField: User.Field) {
		self.init(rawValue: userField.rawValue)
	}

	public init(_ groupField: Group.Field) {
		self.init(rawValue: groupField.rawValue)
	}
}

extension Groups.GetMembers {
	public func deserializeResult(from body: Data) throws -> Result {
		if filter == .managers {
			return .managers(try deserializeRequestResult(from: body))
		} else {
			return .ids(try deserializeRequestResult(from: body))
		}
	}

	public enum Result: Hashable, Sendable {
		case ids(PaginatedList<UserID, PaginatedListExtras.Empty>)
		case managers(PaginatedList<User.GroupAdmin, PaginatedListExtras.Empty>)
	}
}

extension PhotoAlbumID {
	/// A "magic" identifier to request photos from the system album
	/// using ``Photos/Get``.
	public static let profile = PhotoAlbumID(rawValue: "profile")

	/// A "magic" identifier to request photos from the system album
	/// using ``Photos/Get``.
	public static let saved = PhotoAlbumID(rawValue: "saved")
}
