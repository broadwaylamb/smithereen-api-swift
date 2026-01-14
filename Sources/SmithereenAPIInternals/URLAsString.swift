import Foundation

/// By default, a URL is encoded/decoded as an object. We need to encode it as a string.
@propertyWrapper
public struct URLAsString<T: PotentiallyOptional<URL>>: PropertyWrapperWithPotentiallyOptional {
	public var wrappedValue: T

	public init(wrappedValue: T) {
		self.wrappedValue = wrappedValue
	}
}

extension URLAsString: Equatable where T: Equatable {}
extension URLAsString: Hashable where T: Hashable {}
extension URLAsString: Sendable where T: Sendable {}

extension URLAsString: CustomDebugStringConvertible {
	public var debugDescription: String {
		String(reflecting: wrappedValue)
	}
}

extension URLAsString: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try encode(to: encoder) { url, _ in url.absoluteString }
	}
}

extension URLAsString: Decodable {
	public init(from decoder: any Decoder) throws {
		try self.init(from: decoder) { container in
			guard let string = try container.decode(String?.self) else {
				return nil
			}
			guard let url = URL(string: string) else {
				throw DecodingError.dataCorruptedError(
					in: container,
					debugDescription: "Invalid URL format",
				)
			}
			return url
		}
	}
}

extension URL: PotentiallyOptional {}
extension URLAsString: PotentiallyOptional {}
