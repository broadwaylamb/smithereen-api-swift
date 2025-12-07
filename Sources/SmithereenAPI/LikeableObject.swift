public enum LikeableObject: Hashable, Encodable, Sendable {
	case post(WallPostID)
	case photo(PhotoID)
	case photoComment(PhotoCommentID)
	case topicComment(TopicCommentID)

	private enum Tag: String, Codable {
		case post
		case photo
		case photoComment = "photo_comment"
		case topicComment = "topic_comment"
	}

	private enum CodingKeys: String, CodingKey {
		case type
		case itemID = "item_id"
	}
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		let tag: Tag
		let itemID: String
		switch self {
		case .post(let id):
			tag = .post
			itemID = String(describing: id)
		case .photo(let id):
			tag = .photo
			itemID = String(describing: id)
		case .photoComment(let id):
			tag = .photoComment
			itemID = String(describing: id)
		case .topicComment(let id):
			tag = .topicComment
			itemID = String(describing: id)
		}
		try container.encode(tag, forKey: .type)
		try container.encode(itemID, forKey: .itemID)
	}
}
