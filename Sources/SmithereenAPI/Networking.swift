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
	private init<Request: EncodableRequestProtocol>(
		host: String,
		port: Int?,
		useHTTPS: Bool,
		request: Request,
		cachePolicy: URLRequest.CachePolicy,
		timeoutInterval: TimeInterval,
		additionalQueryItems: (inout [URLQueryItem]) throws -> Void,
	) throws {
		var queryItems = [URLQueryItem]()
		try additionalQueryItems(&queryItems)
		if let query = request.encodableQuery {
			try urlFormEncoder.encode(query, into: &queryItems)
		}
		var urlComponents = URLComponents()
		urlComponents.scheme = useHTTPS ? "https" : "http"
		urlComponents.host = host
		urlComponents.port = port
		urlComponents.path = request.path
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else {
			fatalError("Could not create a URL for the method: \(urlComponents)")
		}
		self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
		httpMethod = Request.method.rawValue
		if let body = request.encodableBody {
			addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
			httpBody = try Data(urlFormEncoder.encode(body).utf8)
		}
		addValue("application/json", forHTTPHeaderField: "Accept")
	}

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
		port: Int? = nil,
		useHTTPS: Bool = true,
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
		try self.init(
			host: host,
			port: port,
			useHTTPS: useHTTPS,
			request: request,
			cachePolicy: cachePolicy,
			timeoutInterval: timeoutInterval,
		) { queryItems in
			try urlFormEncoder.encode(globalParameters, into: &queryItems)
		}
		if let accessToken, passAccessTokenInHeader {
			addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
		}
	}

	/// Creates a ready-to-use URL request for the provided Smithereen OAuth request.
	///
	/// - parameters:
	///	  - host: The Smithereen instance server address.
	///     Must be a valid host name.
	///   - request: The OAuth request to perform.
	///   - cachePolicy: The cache policy for the request.
	///   - timeoutInterval: The timeout interval for the request. The default is 60.0.
	public init<Request: SmithereenOAuthTokenRequest>(
		host: String,
		port: Int? = nil,
		useHTTPS: Bool = true,
		request: Request,
		cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
		timeoutInterval: TimeInterval = 60.0,
	) throws {
		try self.init(
			host: host,
			port: port,
			useHTTPS: useHTTPS,
			request: request,
			cachePolicy: cachePolicy,
			timeoutInterval: timeoutInterval,
			additionalQueryItems: { _ in },
		)
	}
}
