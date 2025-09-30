import Foundation

@propertyWrapper
public struct UnixTimestamp<T: PotentiallyOptional<Date>>: PropertyWrapperWithPotentiallyOptional {
	public var wrappedValue: T

	public init(wrappedValue: T) {
		self.wrappedValue = wrappedValue
	}
}

extension UnixTimestamp: Equatable where T: Equatable {}
extension UnixTimestamp: Hashable where T: Hashable {}
extension UnixTimestamp: Sendable where T: Sendable {}

extension UnixTimestamp: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try encode(to: encoder) { $0.timeIntervalSince1970 }
	}
}

extension UnixTimestamp: Decodable {
	public init(from decoder: any Decoder) throws {
		try self.init(from: decoder) { container in
			try container.decode(TimeInterval?.self).map(Date.init(timeIntervalSince1970:))
		}
	}
}

extension Date: PotentiallyOptional {}
