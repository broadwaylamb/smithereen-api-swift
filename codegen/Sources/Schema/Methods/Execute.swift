let execute = FileDef("Execute", additionalImports: ["Hammond"]) {
	let executeArgsTP = TypeParameterDef(name: "Args", upperBound: .encodable)
	RequestDef(
		"execute",
		conformances: [TypeRef(name: "SmithereenAPIRequest"), .encodable],
		typeParameters: [
			executeArgsTP,
			TypeParameterDef(name: "Result", upperBound: .decodable),
		],
	) {
			FieldDef("code", type: .string)
				.required()
			FieldDef("args", type: .def(executeArgsTP))
				.required()
				.flatten()
	}
	.doc("""
		Runs your JavaScript-like script on the server to make multiple API calls
		and post-process their results.

		You can use this, for example, to retrieve different data in one go to
		display a complex screen, like a user’s profile, or to make several API
		calls that depend on each other’s results.
		You can make up to 25 API calls in one execute.

		The server will compile your code into an intermediate representation and
		cache that. Thus, it is more efficient to pass extra parameters and retrieve
		them using the `Args.param_name` syntax rather than dynamically generate
		the code itself.
		""")

	Verbatim("extension Execute: Equatable where Args: Equatable {}")
	Verbatim("extension Execute: Hashable where Args: Hashable {}")
	Verbatim("extension Execute: Sendable where Args: Sendable {}")
}
