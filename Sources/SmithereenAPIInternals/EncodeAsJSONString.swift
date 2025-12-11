import Foundation

@propertyWrapper
public struct EncodeAsJSONString<T: PotentiallyOptional>: PropertyWrapperWithPotentiallyOptional
	where T.Wrapped: Encodable
{
	public var wrappedValue: T

	public init(wrappedValue: T) {
		self.wrappedValue = wrappedValue
	}
}

extension EncodeAsJSONString: Equatable where T: Equatable {}
extension EncodeAsJSONString: Hashable where T: Hashable {}
extension EncodeAsJSONString: Sendable where T: Sendable {}

private let jsonEncoder = JSONEncoder()

extension EncodeAsJSONString: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try encode(to: encoder) { String(decoding: try jsonEncoder.encode($0), as: UTF8.self) }
	}
}

extension EncodeAsJSONString: PotentiallyOptional {}
