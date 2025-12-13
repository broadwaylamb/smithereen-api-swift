/// A slice of some long list, returned by all methods that take
/// `offset` and `count``.
@dynamicMemberLookup
public struct PaginatedList<Element, Extras> {

	/// The total number of items in the list.
	public private(set) var totalCount: Int

	/// The array of items you requested.
	public private(set) var items: [Element]

	private var extras: Extras

	private init(items: [Element], totalCount: Int, extras: Extras) {
		self.items = items
		self.totalCount = Swift.max(totalCount, items.count)
		self.extras = extras
	}

	public init<S: Sequence<Element>>(_ elements: S, totalCount: Int, extras: Extras) {
		self.init(items: Array(elements), totalCount: totalCount, extras: extras)
	}

	public init<S: Sequence<Element>>(_ elements: S, extras: Extras) {
		let items = Array(elements)
		self.init(items: items, totalCount: items.count, extras: extras)
	}

	public subscript<T>(dynamicMembet keyPath: KeyPath<Extras, T>) -> T {
		extras[keyPath: keyPath]
	}

	public subscript<T>(dynamicMember keyPath: WritableKeyPath<Extras, T>) -> T {
		get {
			extras[keyPath: keyPath]
		}
		set {
			extras[keyPath: keyPath] = newValue
		}
	}

	private enum CodingKeys: String, CodingKey {
		case totalCount = "count"
		case items
	}
}

extension PaginatedList: Equatable where Element: Equatable, Extras: Equatable {}
extension PaginatedList: Hashable where Element: Hashable, Extras: Hashable {}
extension PaginatedList: Sendable where Element: Sendable, Extras: Sendable {}

extension PaginatedList: Encodable where Element: Encodable, Extras: Encodable {
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(items, forKey: .items)
		try container.encode(totalCount, forKey: .totalCount)
		try extras.encode(to: encoder)
	}
}

extension PaginatedList: Decodable where Element: Decodable, Extras: Decodable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.init(
			try container.decode([Element].self, forKey: .items),
			totalCount: try container.decode(Int.self, forKey: .totalCount),
			extras: try Extras(from: decoder),
		)
	}
}

extension PaginatedList: RandomAccessCollection, MutableCollection {
	public typealias Index = Int
	public var startIndex: Int { items.startIndex }
	public var endIndex: Int { items.endIndex }
	public func index(after i: Int) -> Int { items.index(after: i) }
	public func formIndex(after i: inout Int) { items.formIndex(after: &i) }
	public func index(_ i: Int, offsetBy distance: Int) -> Int {
		items.index(i, offsetBy: distance)
	}
	public func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
		items.index(i, offsetBy: distance, limitedBy: limit)
	}
	public func index(before i: Int) -> Int { items.index(before: i) }
	public func formIndex(before i: inout Int) { items.formIndex(before: &i) }
	public func distance(from start: Int, to end: Int) -> Int {
		items.distance(from: start, to: end)
	}
	public var count: Int { items.count }
	public var isEmpty: Bool { items.isEmpty }
	public subscript(position: Int) -> Element {
		get {
			items[position]
		}
		set {
			items[position] = newValue
		}
	}
	public subscript(bounds: Range<Int>) -> ArraySlice<Element> {
		get {
			items[bounds]
		}
		set {
			items[bounds] = newValue
		}
	}
	public mutating func swapAt(_ i: Int, _ j: Int) {
		items.swapAt(i, j)
	}
	public mutating func partition(
		by belongsInSecondPartition: (Element) throws -> Bool
	) rethrows -> Int {
		try items.partition(by: belongsInSecondPartition)
	}
	public func withContiguousStorageIfAvailable<R>(
		_ body: (UnsafeBufferPointer<Element>
	) throws -> R) rethrows -> R? {
		try items.withContiguousStorageIfAvailable(body)
	}
	public mutating func withContiguousMutableStorageIfAvailable<R>(
		_ body: (inout UnsafeMutableBufferPointer<Element>
	) throws -> R) rethrows -> R? {
		try items.withContiguousMutableStorageIfAvailable(body)
	}
}

extension PaginatedList where Extras == PaginatedListExtras.Empty {
	public init<S: Sequence<Element>>(_ elements: S, totalCount: Int) {
		self.init(items: Array(elements), totalCount: totalCount, extras: PaginatedListExtras.Empty())
	}

	public init<S: Sequence<Element>>(_ elements: S) {
		let items = Array(elements)
		self.init(items: items, totalCount: items.count, extras: PaginatedListExtras.Empty())
	}
}

extension PaginatedList: ExpressibleByArrayLiteral where Extras == PaginatedListExtras.Empty {
	public init(arrayLiteral elements: Element...) {
		self.init(elements, totalCount: elements.count)
	}
}

public enum PaginatedListExtras {
	public struct Empty: Hashable, Sendable, Codable {}

	public struct Profiles: Hashable, Sendable, Codable {
		public var profiles: [User]

		public init(profiles: [User]) {
			self.profiles = profiles
		}
	}

	public struct ProfilesAndGroups: Hashable, Sendable, Codable {
		public var profiles: [User]
		public var groups: [Group]
		public init(profiles: [User], groups: [Group]) {
			self.profiles = profiles
			self.groups = groups
		}
	}

	public struct CommentView: Hashable, Sendable, Codable {
		public var viewType: SmithereenAPI.CommentView

		public init(viewType: SmithereenAPI.CommentView) {
			self.viewType = viewType
		}

		private enum CodingKeys: String, CodingKey {
			case viewType = "view_type"
		}
	}

	public struct CommentViewWithProfilesAndGroups: Hashable, Sendable, Codable {
		public var profiles: [User]
		public var groups: [Group]
		public var viewType: SmithereenAPI.CommentView

		public init(
			profiles: [User],
			groups: [Group],
			viewType: SmithereenAPI.CommentView,
		) {
			self.profiles = profiles
			self.groups = groups
			self.viewType = viewType
		}

		private enum CodingKeys: String, CodingKey {
			case profiles
			case groups
			case viewType = "view_type"
		}
	}
}
