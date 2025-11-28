/// A slice of some long list, returned by all methods that take
/// `offset` and `count``.
public struct PaginatedList<Element> {

	/// The total number of items in the list.
	public private(set) var totalCount: Int

	/// The array of items you requested.
	public private(set) var items: [Element]

	private init(items: [Element], totalCount: Int) {
		precondition(totalCount >= items.count, "totalCount exceeds items.count")
		self.items = items
		self.totalCount = totalCount
	}

	public init<S: Sequence<Element>>(_ elements: S, totalCount: Int) {
		self.init(items: Array(elements), totalCount: totalCount)
	}

	public init<S: Sequence<Element>>(_ elements: S) {
		let items = Array(elements)
		self.init(items: items, totalCount: items.count)
	}

	fileprivate enum CodingKeys: String, CodingKey {
		case totalCount = "count"
		case items
	}
}

extension PaginatedList: Equatable where Element: Equatable {}
extension PaginatedList: Hashable where Element: Hashable {}
extension PaginatedList: Sendable where Element: Sendable {}
extension PaginatedList: Decodable where Element: Decodable {}
extension PaginatedList: Encodable where Element: Encodable {}

extension PaginatedList : RandomAccessCollection, MutableCollection {
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

extension PaginatedList: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: Element...) {
		self.init(items: elements, totalCount: elements.count)
	}
}
