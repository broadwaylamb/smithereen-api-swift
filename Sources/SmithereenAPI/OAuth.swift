import Foundation
import Hammond
import SmithereenAPIInternals

public enum OAuth {
	public enum AuthorizationCodeError: Swift.Error {
		/// The expected state string doesn't match the actual state string
		/// in the redirected URL.
		case stateMismatch(expected: String, actual: String?)

		/// The redirected URL is malformed.
		case invalidURL(URL)
	}

	public struct AuthorizationCode: Identifier {
		public var rawValue: String
		public init(rawValue: String) {
			self.rawValue = rawValue
		}
	}

	/// Returns a URL for opening in a browser to obtain the access token.
	/// - parameters:
	///   - host: The Smithereen instance server address.
	///   - clientID: The ActivityPub identifier of the application.
	///     See https://smithereen.software/docs/api/creating-app.
	///   - redirectURI: the URL where you will receive your
	///     authorization code. Must be specified in the app’s metadata.
	///   - permissions: The list of permissions you’re requesting.
	///   - state: An opaque string that will passed back to your app.
	///   - pkceCodeChallenge: If using PKCE, the SHA-256 hash of
	///     the code verifier string.
	public func urlForAuthorizationCodeFlow(
		host: String,
		clientID: URL,
		redirectURI: URL,
		permissions: [Permission]? = nil,
		state: String? = nil,
		pkceCodeChallenge: Data? = nil,
	) -> URL {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = host
		urlComponents.path = "/oauth/authorize"
		var queryItems = [
			URLQueryItem(name: "client_id", value: clientID.absoluteString),
			URLQueryItem(name: "response_type", value: "code"),
			URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
		]
		if let permissions {
			queryItems.append(
				URLQueryItem(
					name: "scope",
					value: permissions
						.lazy
						.map { $0.rawValue }
						.joined(separator: " "),
				)
			)
		}
		if let state {
			queryItems.append(URLQueryItem(name: "state", value: state))
		}
		if let pkceCodeChallenge {
			queryItems.append(URLQueryItem(name: "code_challenge_method", value: "S256"))
			queryItems.append(
				URLQueryItem(
					name: "code_challenge",
					value: pkceCodeChallenge.base64EncodedString(),
				)
			)
		}
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else {
			fatalError("Could not create URL: \(urlComponents)")
		}
		return url
	}

	/// Gets the authorization code from the provided URL, optionally
	/// verifying the `state` string.
	///
	/// - parameters:
	///   - url: The app-specific URL that the browser session was
	///     redirected to. It should include the `code` query parameter.
	///   - expectedState: If this is not `nil`, the string against which to verify
	///     the `url`'s query parameter `state`. If they don't match,
	///     ``AuthorizationCodeError/stateMismatch(expected:actual:)`` is thrown.
	public func extractAuthorizationCode(
		from url: URL,
		expectedState: String?,
	) throws(AuthorizationCodeError) -> AuthorizationCode {
		guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
			let queryItems = urlComponents.queryItems
		else {
			throw AuthorizationCodeError.invalidURL(url)
		}

		guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
			throw AuthorizationCodeError.invalidURL(url)
		}

		if let expectedState {
			let actualState = queryItems.first { $0.name == "state" }?.value
			if expectedState != actualState {
				throw AuthorizationCodeError
					.stateMismatch(expected: expectedState, actual: actualState)
			}
		}

		return AuthorizationCode(rawValue: code)
	}
}

public protocol SmithereenOAuthTokenRequest
	:	EncodableRequestProtocol,
		DecodableRequestProtocol
	where
		ServerError == OAuth.TokenError,
		ResponseBody == Data,
		Result == OAuth.AccessTokenResponse
{
}

extension SmithereenOAuthTokenRequest {
	public func deserializeError(from body: Data) throws -> OAuth.TokenError {
		try smithereenJSONDecoder.decode(OAuth.TokenError.self, from: body)
	}

	public func deserializeResult(from body: Data) throws -> OAuth.AccessTokenResponse {
		try smithereenJSONDecoder.decode(OAuth.AccessTokenResponse.self, from: body)
	}
}

extension OAuth.TokenError: ServerErrorProtocol {
	public static func defaultError(for statusCode: HTTPStatusCode) -> OAuth.TokenError {
		OAuth.TokenError(code: .invalidRequest)
	}
}
