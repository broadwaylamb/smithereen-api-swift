import Foundation
import Hammond

public protocol SmithereenAPIRequest
	:	EncodableRequestProtocol,
		DecodableRequestProtocol,
		Sendable
	where
		ServerError == SmithereenAPIError,
		ResponseBody == Data,
		Result: Sendable
{
}

internal let smithereenJSONDecoder: JSONDecoder = {
	let decoder = JSONDecoder()
	decoder.dateDecodingStrategy = .secondsSince1970
	return decoder
}()

extension SmithereenAPIRequest {
	public func deserializeError(from body: Data) throws -> SmithereenAPIError {
		let response = try smithereenJSONDecoder
			.decode(SmithereenAPIResponse<NeverCodable>.self, from: body)

		if let error = response.error {
			return error
		}

		throw DecodingError.valueNotFound(
			SmithereenAPIError.self,
			DecodingError.Context(
				codingPath: [SmithereenAPIResponse<Result>.CodingKeys.error],
				debugDescription: "Missing error"
			),
		)
	}
}

extension SmithereenAPIRequest where Result: Decodable {
    public func deserializeResult(from body: Data) throws -> Result {
		try deserializeRequestResult(from: body)
	}
}

internal func deserializeRequestResult<Result: Decodable>(
	from body: Data
) throws -> Result {
	let response = try smithereenJSONDecoder
		.decode(SmithereenAPIResponse<Result>.self, from: body)

	if let result = response.response {
		return result
	}

	throw DecodingError.valueNotFound(
		Result.self,
		DecodingError.Context(
			codingPath: [SmithereenAPIResponse<Result>.CodingKeys.response],
			debugDescription: "Missing response",
		)
	)
}

extension SmithereenAPIError: ServerErrorProtocol {
    public static func defaultError(
		for statusCode: HTTPStatusCode
	) -> SmithereenAPIError {
        let code: SmithereenAPIError.Code = switch statusCode.category {
		case .clientError: .invalidRequest
		case .serverError: .internalServerError
		default: .init(rawValue: -statusCode.rawValue)
		}
		return SmithereenAPIError(
			code: code,
			message: String(describing: statusCode),
		)
    }
}
