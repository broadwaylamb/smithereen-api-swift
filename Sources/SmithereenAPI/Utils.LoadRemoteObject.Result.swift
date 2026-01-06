extension Utils.LoadRemoteObject {
	public enum Result: Hashable, Codable, Sendable {
		case user(UserID)
		case group(GroupID)
		case wallPost(WallPostID)
		case wallComment(WallPostID, parent: WallPostID)
		case photoAlbum(PhotoAlbumID)
		case photo(PhotoID)
		case photoComment(PhotoCommentID, parent: PhotoID)
		case topic(BoardTopicID)
		case topicComment(TopicCommentID, parent: BoardTopicID)

		private enum Discriminant: String, Codable {
			case user
			case group
			case wallPost = "wall_post"
			case wallComment = "wall_comment"
			case photoAlbum = "photo_album"
			case photo
			case comment
			case topic
		}

		private enum CommentParentType: String, Codable {
			case wallPost = "wall_post"
			case photo
			case topic
		}

		private enum CodingKeys: String, CodingKey {
			case type
			case id
			case parentType = "parent_type"
			case parentID = "parent_id"
		}

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			let discriminant: Discriminant
			var parentType: CommentParentType?
			switch self {
			case .user(let id):
				discriminant = .user
				try container.encodeToString(id, forKey: .id)
			case .group(let id):
				discriminant = .group
				try container.encodeToString(id, forKey: .id)
			case .wallPost(let id):
				discriminant = .wallPost
				try container.encodeToString(id, forKey: .id)
			case .wallComment(let id, let parent):
				discriminant = .wallComment
				try container.encodeToString(id, forKey: .id)
				parentType = .wallPost
				try container.encodeToString(parent, forKey: .parentID)
			case .photoAlbum(let id):
				discriminant = .photoAlbum
				try container.encode(id, forKey: .id)
			case .photo(let id):
				discriminant = .photo
				try container.encode(id, forKey: .id)
			case .photoComment(let id, let parent):
				discriminant = .comment
				try container.encode(id, forKey: .id)
				parentType = .photo
				try container.encode(parent, forKey: .parentID)
			case .topic(let id):
				discriminant = .topic
				try container.encode(id, forKey: .id)
			case .topicComment(let id, let parent):
				discriminant = .comment
				try container.encode(id, forKey: .id)
				parentType = .topic
				try container.encode(parent, forKey: .parentID)
			}
			try container.encode(discriminant, forKey: .type)
			try container.encodeIfPresent(parentType, forKey: .parentType)
		}

		public init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let type = try container.decode(Discriminant.self, forKey: .type)
			switch type {
			case .user:
				self = .user(try container.decodeFromString(UserID.self, forKey: .id))
			case .group:
				self = .group(try container.decodeFromString(GroupID.self, forKey: .id))
			case .comment:
				let parentType = try container.decode(CommentParentType.self, forKey: .parentType)
				switch parentType {
				case .wallPost:
					self = .wallComment(
						try container.decodeFromString(WallPostID.self, forKey: .id),
						parent: try container.decodeFromString(WallPostID.self, forKey: .parentID),
					)
				case .photo:
					self = .photoComment(
						try container.decode(PhotoCommentID.self, forKey: .id),
						parent: try container.decode(PhotoID.self, forKey: .parentID),
					)
				case .topic:
					self = .topicComment(
						try container.decode(TopicCommentID.self, forKey: .id),
						parent: try container.decode(BoardTopicID.self, forKey: .parentID),
					)
				}
			case .photo:
				self = .photo(try container.decode(PhotoID.self, forKey: .id))
			case .photoAlbum:
				self = .photoAlbum(try container.decode(PhotoAlbumID.self, forKey: .id))
			case .topic:
				self = .topic(try container.decode(BoardTopicID.self, forKey: .id))
			case .wallComment:
				self = .wallComment(
					try container.decodeFromString(WallPostID.self, forKey: .id),
					parent: try container.decodeFromString(WallPostID.self, forKey: .parentID),
				)
			case .wallPost:
				self = .wallPost(try container.decodeFromString(WallPostID.self, forKey: .id))
			}
		}
	}
}
