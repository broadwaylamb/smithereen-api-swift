import Hammond

public struct SmithereenAPIResponse<Payload> {
	public var response: Payload?
	public var error: SmithereenAPIError?
	public var executeErrors: [SmithereenAPIError]?

	public init(
		response: Payload? = nil,
		error: SmithereenAPIError? = nil,
		executeErrors: [SmithereenAPIError]? = nil,
	) {
		self.response = response
		self.error = error
		self.executeErrors = executeErrors
	}

	internal enum CodingKeys: String, CodingKey {
		case response
		case error
		case executeErrors = "execute_errors"
	}
} 

extension SmithereenAPIResponse: Equatable where Payload: Equatable {}
extension SmithereenAPIResponse: Hashable where Payload: Hashable {}
extension SmithereenAPIResponse: Sendable where Payload: Sendable {}
extension SmithereenAPIResponse: Encodable where Payload: Encodable {}
extension SmithereenAPIResponse: Decodable where Payload: Decodable {}

extension SmithereenAPIResponse where Payload == NeverCodable {
	public init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		try self.init(
			error: container
				.decodeIfPresent(SmithereenAPIError.self, forKey: .error), 
			executeErrors: container
				.decodeIfPresent(
					[SmithereenAPIError].self,
					forKey: .executeErrors
				),
		)
	}
}
