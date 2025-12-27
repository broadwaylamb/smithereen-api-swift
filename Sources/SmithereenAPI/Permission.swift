public struct Permission: RawRepresentable, Codable, Sendable {
	public var rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	private init(_ scope: String, isReadOnly: Bool = false) {
		rawValue = scope
		if isReadOnly {
			rawValue += ":read"
		}
	}

	/// If `isReadOnly` is `true`:
	/// read-only access to friend requests and private friend lists.
	///
	/// If `isReadOnly` is `false`:
	/// full access to perform friends-related actions, like adding and
	/// removing friends, editig lists, on behalf of the user.
	public static func friends(isReadOnly: Bool = false) -> Permission {
		Permission("friends", isReadOnly: isReadOnly)
	}

	/// If `isReadOnly` is `true`:
	/// read-only access to all photos and photo albums available to
	/// the user, including private ones.
	///
	/// If `isReadOnly` is `false`:
	/// full access to perform photos-related actions, like creating,
	/// editing or deleting albums and photos on behalf of the user.
	public static func photos(isReadOnly: Bool = false) -> Permission {
		Permission("photos", isReadOnly: isReadOnly)
	}

	/// Access to edit user’s profile and change their settings.
	public static let account = Permission("account")

	/// If `isReadOnly` is `true`:
	/// read-only access to all wall posts and comments, including
	/// those in non-public groups, other people’s posts on walls
	/// whose owners limit who can see them, and followers-only
	/// posts received from other fediverse servers which support
	/// such a thing.
	///
	/// If `isReadOnly` is `false`:
	/// access to create wall posts and comments.
	public static func wall(isReadOnly: Bool = false) -> Permission {
		Permission("wall", isReadOnly: isReadOnly)
	}

	/// If `isReadOnly` is `true`:
	/// Read-only access to all of the user’s groups and events,
	/// including non-public ones, and to group and event invitations.
	///
	/// If `isReadOnly` is `false`:
	/// Access to join and leave groups on user’s behalf, edit
	/// the groups they manage, and invite friends to groups.
	public static func groups(isReadOnly: Bool = false) -> Permission {
		Permission("groups", isReadOnly: isReadOnly)
	}

	/// If `isReadOnly` is `true`:
	/// Read-only access to user’s private messages.
	///
	/// If `isReadOnly` is `false`:
	/// Access to send private messages on behalf of the user.
	public static func messages(isReadOnly: Bool = false) -> Permission {
		Permission("messages", isReadOnly: isReadOnly)
	}

	/// If `isReadOnly` is `true`:
	/// Read-only access to user’s likes and bookmarks.
	///
	/// If `isReadOnly` is `false`:
	/// Access to like objects on behalf of the user and add and
	/// remove their bookmarks.
	public static func likes(isReadOnly: Bool = false) -> Permission {
		Permission("likes", isReadOnly: isReadOnly)
	}

	/// Access to the news feeds (friends, groups, comments).
	public static let newsfeed = Permission("newsfeed")

	/// Access to user’s notifications.
	public static let notifications = Permission("notifications")

	/// Causes a permanent access token to be issued instead of
	/// a short-lived one. Intended for use with client apps where
	/// users expect to log in once and stay logged in forever.
	public static let offline = Permission("offline")
}

extension Permission: CaseIterable {
	public static let allCases: [Permission] = [
		.friends(isReadOnly: true),
		.friends(),
		.photos(isReadOnly: true),
		.photos(),
		.account,
		.wall(isReadOnly: true),
		.wall(),
		.groups(isReadOnly: true),
		.groups(),
		.messages(isReadOnly: true),
		.messages(),
		.likes(isReadOnly: true),
		.likes(),
		.newsfeed,
		.notifications,
		.offline,
	]
}
