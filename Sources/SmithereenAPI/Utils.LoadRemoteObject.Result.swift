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
			let idString: String
			var parentType: CommentParentType?
			var parentIDString: String?
			switch self {
			case .user(let id):
				discriminant = .user
				idString = String(describing: id)
			case .group(let id):
				discriminant = .group
				idString = String(describing: id)
			case .wallPost(let id):
				discriminant = .wallPost
				idString = String(describing: id)
			case .wallComment(let id, let parent):
				discriminant = .wallComment
				idString = String(describing: id)
				parentType = .wallPost
				parentIDString = String(describing: parent)
			case .photoAlbum(let id):
				discriminant = .photoAlbum
				idString = String(describing: id)
			case .photo(let id):
				discriminant = .photo
				idString = String(describing: id)
			case .photoComment(let id, let parent):
				discriminant = .comment
				idString = String(describing: id)
				parentType = .photo
				parentIDString = String(describing: parent)
			case .topic(let id):
				discriminant = .topic
				idString = String(describing: id)
			case .topicComment(let id, let parent):
				discriminant = .comment
				idString = String(describing: id)
				parentType = .topic
				parentIDString = String(describing: parent)
			}
			try container.encode(discriminant, forKey: .type)
			try container.encode(idString, forKey: .id)
			try container.encodeIfPresent(parentType, forKey: .parentType)
			try container.encodeIfPresent(parentIDString, forKey: .parentID)
		}

		public init(from decoder: any Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let type = try container.decode(Discriminant.self, forKey: .type)
			switch type {
			case .user:
				self = .user(try container.decodeFromString(forKey: .id))
			case .group:
				self = .group(try container.decodeFromString(forKey: .id))
			case .comment:
				let parentType = try container.decode(CommentParentType.self, forKey: .parentType)
				switch parentType {
				case .wallPost:
					self = .wallComment(
						try container.decodeFromString(forKey: .id),
						parent: try container.decodeFromString(forKey: .parentID),
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
					try container.decodeFromString(forKey: .id),
					parent: try container.decodeFromString(forKey: .parentID),
				)
			case .wallPost:
				self = .wallPost(try container.decodeFromString(forKey: .id))
			}
		}
	}
}

extension KeyedDecodingContainer {
	fileprivate func decodeFromString<T: RawRepresentable>(forKey key: K) throws -> T where T.RawValue == Int {
		guard let int = Int(try decode(String.self, forKey: key)) else {
			throw DecodingError.dataCorruptedError(
				forKey: key,
				in: self,
				debugDescription: "Could not parse an integer from the string",
			)
		}
		guard let result = T(rawValue: int) else {
			throw DecodingError.dataCorruptedError(
				forKey: key,
				in: self,
				debugDescription: "Could not initize \(T.self) from raw value",
			)
		}
		return result
	}
}
