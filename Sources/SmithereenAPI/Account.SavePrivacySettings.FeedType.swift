extension Account.SavePrivacySettings {
	public enum FeedTypes: Hashable, Encodable, Sendable {
		/// All updates.
		case all

		/// No updates.
		case none

		/// Specific updates.
		case specific([PrivacySetting.FeedType])

		public func encode(to encoder: any Encoder) throws {
			var container = encoder.unkeyedContainer()
			switch self {
			case .all:
				try container.encode("all")
			case .none:
				try container.encode("none")
			case .specific(let feedTypes):
				try feedTypes.encode(to: encoder)
			}
		}
	}
}
