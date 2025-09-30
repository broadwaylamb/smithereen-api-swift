package func parseInt<S: StringProtocol>(
	_ s: S,
	_ container: any SingleValueDecodingContainer,
	error: @autoclosure () -> String
) throws -> Int {
	if let number = Int(s) {
		return number
	}
	throw DecodingError.dataCorruptedError(in: container, debugDescription: error())
}
