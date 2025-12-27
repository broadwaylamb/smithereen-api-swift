import Foundation
import Hammond
import HammondEncoders

private let urlFormEncoder = URLEncodedFormEncoder(
	configuration: URLEncodedFormEncoder.Configuration(
		arrayEncoding: .separator(","),
		dateEncodingStrategy: .secondsSince1970,
		stableKeyOrder: true,
	),
)

extension URLRequest {
	/// Creates a ready-to-use URL request for the provided Smithereen API request.
	///
	/// `globalParameters` are always passed in the query part.
	///
	/// - parameters:
	///	  - host: The Smithereen instance server address.
	///     Must be a valid host name.
	///   - request: The Smithereen API method to call.
	///   - globalParameters: The [global parameters](https://smithereen.software/docs/api/requests/)
	///     to specify for this request.
	///   - passAccessTokenInHeader: Whether to pass the access token as
	///     a request parameter or a header. Those are always passed in the query part.
	///   - cachePolicy: The cache policy for the request.
	///   - timeoutInterval: The timeout interval for the request. The default is 60.0.
	public init<Request: SmithereenAPIRequest>(
		host: String,
		request: Request,
		globalParameters: GlobalRequestParameters,
		passAccessTokenInHeader: Bool = true,
		cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
		timeoutInterval: TimeInterval = 60.0,
	) throws {
		let accessToken = globalParameters.accessToken
		var globalParameters = globalParameters
		if passAccessTokenInHeader {
			globalParameters.accessToken = nil
		}
		var queryItems = [URLQueryItem]()
		try urlFormEncoder.encode(globalParameters, into: &queryItems)
		if let query = request.encodableQuery {
			try urlFormEncoder.encode(query, into: &queryItems)
		}
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = request.path
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else {
			fatalError("Could not create a URL for the method: \(urlComponents)")
		}
		self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
		httpMethod = Request.method.rawValue
		if let accessToken, passAccessTokenInHeader {
			addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		}
		if let body = request.encodableBody {
			addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			httpBody = try Data(urlFormEncoder.encode(body).utf8)
		}
		addValue("application/json", forHTTPHeaderField: "Accept")
	}
}
