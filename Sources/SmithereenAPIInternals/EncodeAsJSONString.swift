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

private let jsonEncoder: JSONEncoder = {
	let encoder = JSONEncoder()
	encoder.outputFormatting = .sortedKeys
	encoder.dateEncodingStrategy = .secondsSince1970
	return encoder
}()

extension EncodeAsJSONString: Encodable {
	public func encode(to encoder: any Encoder) throws {
		if let isURLEncodedFormEncoder =
			encoder.userInfo[isURLEncodedFormEncoderCodingUserInfoKey] as? Bool,
			isURLEncodedFormEncoder
		{
			try encode(to: encoder) { value, _ in
				String(decoding: try jsonEncoder.encode(value), as: UTF8.self)
			}
		} else {
			try wrappedValue._optional.encode(to: encoder)
		}
	}
}

extension EncodeAsJSONString: PotentiallyOptional {}

package let isURLEncodedFormEncoderCodingUserInfoKey =
	CodingUserInfoKey(rawValue: "software.smithereen.api.swift.CodingUserInfoKey.isURLFormEncoded")!
