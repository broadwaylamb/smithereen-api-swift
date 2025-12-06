import SwiftSyntax

struct FileDef {
	var path: String
	var decls: [any StructDefPart]
	var additionalImports: [String] = []

	init(
		_ path: String,
		additionalImports: [String] = [],
		@FileDefBuilder build: () -> [any StructDefPart],
	) {
		self.path = path.hasSuffix(".swift") ? path : path + ".swift"
		self.additionalImports = additionalImports
		self.decls = build()
	}
}

@resultBuilder
struct FileDefBuilder {
	static func buildBlock(_ components: any StructDefPart...) -> [any StructDefPart] {
		return components
	}
}

extension FileDef: GroupPart {
	var file: FileDef? { self }
}
