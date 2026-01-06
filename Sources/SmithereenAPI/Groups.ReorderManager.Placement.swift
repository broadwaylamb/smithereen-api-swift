extension Groups.ReorderManager {
	public enum Placement: Hashable, Encodable, Sendable {
		/// Place this user at the beginning of the manager list.
		case beginning

		/// Place this user after the user with the identifier
		/// specified in the associated value.
		case afterUser(UserID)

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.singleValueContainer()
			switch self {
			case .beginning:
				try container.encode(0)
			case .afterUser(let id):
				try container.encode(id)
			}
		}
	}
}
