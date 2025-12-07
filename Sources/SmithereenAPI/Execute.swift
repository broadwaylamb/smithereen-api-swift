import Hammond

/// Runs your JavaScript-like script on the server to make multiple API calls
/// and post-process their results.
/// 
/// You can use this, for example, to retrieve different data in one go to
/// display a complex screen, like a user’s profile, or to make several API
/// calls that depend on each other’s results.
/// You can make up to 25 API calls in one execute.
///
/// The server will compile your code into an intermediate representation and
/// cache that. Thus, it is more efficient to pass extra parameters and retrieve
/// them using the Args.param_name syntax rather than dynamically generate
/// the code itself.
public struct Execute<Args: Encodable, Result: Decodable>: SmithereenAPIRequest {
	public var code: String
	public var args: Args

	public init(code: String, args: Args) {
		self.code = code
		self.args = args
	}

	public var path: String { "/method/execute" }
	public static var method: HTTPMethod { .post }

	public var encodableBody: Self { self }

	fileprivate enum CodingKeys: String, CodingKey {
		case code
	}
}

extension Execute: Encodable {
	public func encode(to encoder: any Encoder) throws {
		try args.encode(to: encoder)
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(code, forKey: .code)
	}
}
