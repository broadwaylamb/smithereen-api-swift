public struct SmithereenAPIVersion: APIVersionDictionaryEntry, Hashable, Codable, Sendable {
	public static let dictionaryKey: String = "smithereen"
	public var rawValue: String
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
	public static let v1_0 = Self(rawValue: "1.0")
}

extension APIVersionDictionary {
	public var smithereen: SmithereenAPIVersion? {
		get {
			self[SmithereenAPIVersion.self]
		}
		set {
			self[SmithereenAPIVersion.self] = newValue
		}
	}
}
