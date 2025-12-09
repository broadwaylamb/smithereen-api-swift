/// A strongly-typed dictionary of API versions that a Smithereen server
/// supports.
public struct APIVersionDictionary: Hashable, Sendable {
	public private(set) var storage: [String : String]

	public init() {
		storage = [:]
	}

	public subscript<Entry: APIVersionDictionaryEntry>(
		entryType: Entry.Type
	) -> Entry? {
		get {
			storage[entryType.dictionaryKey].flatMap(Entry.init(rawValue:))
		}
		set {
			storage[entryType.dictionaryKey] = newValue?.rawValue
		}
	}
}

extension APIVersionDictionary: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try storage.encode(to: encoder)
	}
}

extension APIVersionDictionary: Decodable {
	public init(from decoder: any Decoder) throws {
		storage = try .init(from: decoder)
	}
}

extension APIVersionDictionary: CustomDebugStringConvertible {
	public var debugDescription: String {
		String(reflecting: storage)
	}
}

public protocol APIVersionDictionaryEntry: RawRepresentable where RawValue == String {
	static var dictionaryKey: String { get }
}
