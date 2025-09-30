@propertyWrapper
public struct LenientBool<T: PotentiallyOptional<Bool>>: PropertyWrapperWithPotentiallyOptional {
	public var wrappedValue: T

	public init(wrappedValue: T) {
		self.wrappedValue = wrappedValue
	}
}

extension LenientBool: Equatable where T: Equatable {}
extension LenientBool: Hashable where T: Hashable {}
extension LenientBool: Sendable where T: Sendable {}

extension LenientBool: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try encode(to: encoder) { $0 }
	}
}

extension LenientBool: Decodable {
	public init(from decoder: any Decoder) throws {
		try self.init(from: decoder) { container in
			do {
				return try container.decode(Bool?.self)
			} catch DecodingError.typeMismatch {
				return try container.decode(Int?.self).map { $0 != 0 }
			}
		}
	}
}

extension Bool: PotentiallyOptional {}

extension LenientBool: PotentiallyOptional {
	public var _optional: Bool? { wrappedValue._optional }

	public init?(_fromOptional optional: Bool?) {
		if let value = WrappedValue(_fromOptional: optional) {
			self.init(wrappedValue: value)
		} else {
			return nil
		}
	}
}

extension LenientBool<Bool?>: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self.init(wrappedValue: nil)
	}
}
