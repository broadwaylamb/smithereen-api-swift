import Foundation
import Hammond

public protocol SmithereenAPIRequest
	:	EncodableRequestProtocol,
		DecodableRequestProtocol
	where ServerError == SmithereenAPIError, ResponseBody == Data 
{
	associatedtype Result
}

private let smithereenJSONDecoder = JSONDecoder()

extension SmithereenAPIRequest where Result: Decodable {
	public func deserializeError(from body: Data) throws -> SmithereenAPIError {
		let response = try smithereenJSONDecoder
			.decode(SmithereenAPIResponse<Result>.self, from: body)
		
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

    public func deserializeResult(from body: Data) throws -> Result {
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
