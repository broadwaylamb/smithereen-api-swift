import SmithereenAPIInternals

public struct Birthday: Equatable, Hashable, Codable, Sendable, CustomStringConvertible {
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
