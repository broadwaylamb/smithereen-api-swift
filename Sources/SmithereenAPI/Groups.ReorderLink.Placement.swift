extension Groups.ReorderLink {
	public enum Placement: Hashable, Encodable, Sendable {
		/// Place this link at the beginning of the list.
		case beginning

		/// Place this link after the link with the identifier
		/// specified in the associated value.
		case afterLink(GroupLinkID)

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.singleValueContainer()
			switch self {
			case .beginning:
				try container.encode(0)
			case .afterLink(let id):
				try container.encode(id)
			}
		}
	}
}
