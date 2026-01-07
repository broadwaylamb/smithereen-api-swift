/// See [Smithereen API versions](https://smithereen.software/docs/api/versions/).
public struct SmithereenAPIVersion: APIVersionDictionaryEntry, Hashable, Codable, Sendable {
	public static let dictionaryKey: String = "smithereen"

	public var major: Int
	public var minor: Int

	public init(major: Int, minor: Int) {
		self.major = major
		self.minor = minor
	}

	public var rawValue: String {
		"\(major).\(minor)"
	}

	public init?(rawValue: String) {
		let components = rawValue.split(
			separator: ".",
			maxSplits: 1,
			omittingEmptySubsequences: false,
		)
		if components.count != 2 {
			return nil
		}
		guard let major = Int(components[0]), let minor = Int(components[1]) else {
			return nil
		}
		self.major = major
		self.minor = minor
	}

	public static let v1_0 = Self(major: 1, minor: 0)
}

extension SmithereenAPIVersion: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		if lhs.major == rhs.major {
			return lhs.minor < rhs.minor
		} else {
			return lhs.major < rhs.major
		}
	}
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
