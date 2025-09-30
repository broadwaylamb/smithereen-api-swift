import Foundation
import SmithereenAPIInternals
import Testing

private struct S: Codable, Equatable {
	@LenientBool var a: Bool
	@LenientBool var b: Bool?
	var c: Bool?
	@LenientBool @LenientBool var d: Bool
	@LenientBool @LenientBool var e: Bool?
}
private let encoder: JSONEncoder = {
	let e = JSONEncoder()
	e.outputFormatting = .sortedKeys
	return e
}()

private let decoder = JSONDecoder()

extension JSONEncoder {
	fileprivate func encodeToString<T: Encodable>(_ encodable: T) throws -> String {
		String(decoding: try encode(encodable), as: UTF8.self)
	}
}

extension JSONDecoder {
	fileprivate func decode<T: Decodable>(_ type: T.Type, from string: String) throws -> T {
		try decode(type, from: Data(string.utf8))
	}
}

@Test func encodingLenientBools() throws {
	try #expect(encoder.encodeToString(S(a: true, b: true, c: true, d: true, e: true)) == #"{"a":true,"b":true,"c":true,"d":true,"e":true}"#)
	try #expect(encoder.encodeToString(S(a: true, b: nil, c: nil, d: true, e: nil)) == #"{"a":true,"d":true}"#)
}

@Test func decodingLenientBools() throws {
	try #expect(decoder.decode(S.self, from: #"{"a":true,"b":true,"c":true,"d":true,"e":true}"#) == S(a: true, b: true, c: true, d: true, e: true))
	try #expect(decoder.decode(S.self, from: #"{"a":true,"d":true}"#) == S(a: true, b: nil, c: nil, d: true, e: nil))
	try #expect(decoder.decode(S.self, from: #"{"a":0,"b":1,"d":0,"e":1}"#) == S(a: false, b: true, c: nil, d: false, e: true))
	try #expect(decoder.decode(S.self, from: #"{"a":42,"b":null,"d":42,"e":null}"#) == S(a: true, b: nil, c: nil, d: true, e: nil))
}
