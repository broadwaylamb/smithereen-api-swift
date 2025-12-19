import SwiftSyntax

struct FileDef {
	var path: String
	var decls: [any DeclarationDef]
	var additionalImports: [String] = []

	init(
		_ path: String,
		additionalImports: [String] = [],
		@FileDefBuilder build: () -> [any DeclarationDef],
	) {
		self.path = path.hasSuffix(".swift") ? path : path + ".swift"
		self.additionalImports = additionalImports
		self.decls = build()
	}
}

@resultBuilder
struct FileDefBuilder {
	static func buildBlock(_ components: any DeclarationDef...) -> [any DeclarationDef] {
		return components
	}
}

extension FileDef: GroupPart {
	var file: FileDef? { self }
}
