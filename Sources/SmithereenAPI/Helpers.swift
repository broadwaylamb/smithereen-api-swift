import SmithereenAPIInternals

public struct Birthday: Hashable, Codable, Sendable, CustomStringConvertible {
	var day: Int
	var month: Int
	var year: Int?

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
		self.init(rawValue: userID.rawValue)
	}

	public init(_ groupID: GroupID) {
		self.init(rawValue: -groupID.rawValue)
	}

	public var userID: UserID? {
		if rawValue > 0 {
			return UserID(rawValue: rawValue)
		}
		return nil
	}

	public var groupID: GroupID? {
		if (rawValue < 0) {
			return GroupID(rawValue: -rawValue)
		}
		return nil
	}
	
	public func map<R>(userID: (UserID) -> R, groupID: (GroupID) -> R) -> R {
		if rawValue >= 0 {
			return userID(UserID(rawValue: rawValue))
		} else {
			return groupID(GroupID(rawValue: -rawValue))
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
	public enum Result: Hashable, Sendable, Codable {
		case ids(PaginatedList<UserID>)
		case managers(PaginatedList<User.GroupAdmin>)

		public func encode(to encoder: any Encoder) throws {
			switch self {
			case .ids(let ids):
				try ids.encode(to: encoder)
			case .managers(let managers):
				try managers.encode(to: encoder)
			}
		}

		public init(from decoder: any Decoder) throws {
			do {
				self = .ids(try .init(from: decoder))
			} catch DecodingError.typeMismatch {
				self = .managers(try .init(from: decoder))
			}
		}
	}
}

extension Likes.Add {
	public func encode(to encoder: any Encoder) throws {
		try itemID.encode(to: encoder)
	}
}

extension Likes.Delete {
	public func encode(to encoder: any Encoder) throws {
		try itemID.encode(to: encoder)
	}
}
