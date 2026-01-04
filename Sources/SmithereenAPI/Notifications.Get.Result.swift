extension Notifications.Get {
	public enum Event: Hashable, Codable, Sendable {

		/// Someone commented on a piece of content created
		/// by the current user.
		case comment(UserID, Feedback)

		/// Someone replied to a current user's comment.
		case reply(UserID, Feedback)

		/// Someone mentioned the current user.
		case mention(UserID, Feedback)

		/// Someone reposted a current user's post or comment.
		case repost(UserIDs)

		/// Someone liked a piece of content created by
		/// the current user.
		case like(UserIDs)

		/// Someone posted on the current user's wall.
		case wallPost(UserID, Feedback)

		/// Someone signed up using an invitation from
		/// the current user.
		case inviteSignup(UserIDs)

		/// Someone started following the current user.
		case follow(UserIDs)

		/// Someone accepted a current user's friend request.
		case friendAccept(UserIDs)

		/// Whether events of this type should can be grouped together
		/// within a day.
		public var canBeGrouped: Bool {
			switch self {
			case .like, .repost, .inviteSignup, .friendAccept, .follow:
				return true
			case .comment, .mention, .reply, .wallPost:
				return false
			}
		}
	}

	/// The post or comment object that this notification is about.
	public enum Feedback: Hashable, Sendable {
		case wallPost(WallPostID)
		case wallComment(WallPostID)
		case photoComment(PhotoCommentID)
		case topicComment(TopicCommentID)
	}
}
