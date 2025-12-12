package protocol Identifier
	:	RawRepresentable,
		Equatable,
		Hashable,
		Codable,
		Sendable,
		CustomStringConvertible,
		CustomDebugStringConvertible {}

extension Identifier {
	public var description: String {
		String(describing: rawValue)
	}

	public var debugDescription: String {
		String(reflecting: rawValue)
	}
}
