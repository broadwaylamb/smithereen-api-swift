/// Allows to safely use Swift enums in DTOs without throwing on unknown value.
@propertyWrapper
public enum FutureProof<T: RawRepresentable> {
	case known(T)
	case unknown(T.RawValue)

	public var wrappedValue: T? {
		switch self {
		case .known(let value):
			return value
		case .unknown:
			return nil
		}
	}

	public var projectedValue: Self {
		return self
	}
}

extension FutureProof: RawRepresentable {
	public var rawValue: T.RawValue {
		switch self {
		case .known(let value):
			return value.rawValue
		case .unknown(let rawValue):
			return rawValue
		}
	}

	public init(rawValue: T.RawValue) {
		self = T(rawValue: rawValue).map(Self.known) ?? .unknown(rawValue)
	}
}

extension FutureProof where T.RawValue: Equatable {
	public static func ==(lhs: Self, rhs: T) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}

	public static func !=(lhs: Self, rhs: T) -> Bool {
		return !(lhs == rhs)
	}

	public static func ==(lhs: T, rhs: Self) -> Bool {
		return rhs == lhs
	}

	public static func !=(lhs: T, rhs: Self) -> Bool {
		return !(lhs == rhs)
	}
}

extension FutureProof: Equatable where T.RawValue: Equatable {
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.rawValue == rhs.rawValue
	}
}

extension FutureProof: Hashable where T.RawValue: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(rawValue)
	}
}

extension FutureProof: Encodable where T: Encodable, T.RawValue: Encodable {
	public func encode(to encoder: any Encoder) throws {
		switch self {
		case .known(let value):
			try value.encode(to: encoder)
		case .unknown(let rawValue):
			try rawValue.encode(to: encoder)
		}
	}
}

extension FutureProof: Decodable where T: Decodable, T.RawValue: Decodable {
	public init(from decoder: any Decoder) throws {
		do {
			self = .known(try T(from: decoder))
		} catch {
			self = .unknown(try T.RawValue(from: decoder))
		}
	}
}
