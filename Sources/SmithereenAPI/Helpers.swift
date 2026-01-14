import Foundation
import SmithereenAPIInternals

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
		self.init(rawValue: -Int32(groupID.rawValue))
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

extension NotificationID: Comparable {
	public static func < (lhs: NotificationID, rhs: NotificationID) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension Notification.Payload {
	public var canBeGrouped: Bool {
		switch self {
		case .like, .repost, .inviteSignup, .follow, .friendAccept:
			return true
		case .comment, .mention, .reply, .wallPost:
			return false
		}
	}
}

extension KeyedDecodingContainer {
	internal func decodeFromString<T: RawRepresentable>(
		_ type: T.Type,
		forKey key: K,
	) throws -> T where T.RawValue: BinaryInteger {
		guard let int = UInt64(try decode(String.self, forKey: key)) else {
			throw DecodingError.dataCorruptedError(
				forKey: key,
				in: self,
				debugDescription: "Could not parse an integer from the string",
			)
		}
		guard let rawValue = T.RawValue(exactly: int), let result = T(rawValue: rawValue) else {
			throw DecodingError.dataCorruptedError(
				forKey: key,
				in: self,
				debugDescription: "Could not initize \(T.self) from raw value",
			)
		}
		return result
	}
}

extension KeyedEncodingContainer {
	internal mutating func encodeToString<T: RawRepresentable>(
		_ value: T,
		forKey key: K,
	) throws where T.RawValue: BinaryInteger {
		try encode(String(value.rawValue), forKey: key)
	}
}

extension CodingUserInfoKey {
	/// A special userInfo key to indicate that a URL-encoded form encoder
	/// is being used to encode the method parameters.
	///
	/// This has the effect on methods that accept JSON strings for some
	/// parameters, like ``Wall/Post/attachments``.
	///
	/// If the method body is being encoded as URL-encoded form,
	/// set `true` for this key in the `userInfo` dictionary of
	/// encoder.
	///
	/// If the method body is being encoded as JSON rather than
	/// URL-encoded form, no value for this key should be passed.
	public static var isURLEncodedFormEncoder: CodingUserInfoKey {
		SmithereenAPIInternals.isURLEncodedFormEncoderCodingUserInfoKey
	}
}

extension SmithereenAPIError {
	public subscript(requestParameter key: String) -> String? {
		requestParams.first { $0.key == key }?.value
	}
}
