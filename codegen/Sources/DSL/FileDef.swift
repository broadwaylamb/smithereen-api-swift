import SwiftSyntax

struct FileDef {
	var path: String
	var decls: [any DeclarationDef]
	var additionalImports: [String] = []
	var schemaPath: String

	init(
		_ path: String,
		additionalImports: [String] = [],
		schemaPath: String = #filePath,
		@FileDefBuilder build: () -> [any DeclarationDef],
	) {
		self.path = path.hasSuffix(".swift") ? path : path + ".swift"
		self.additionalImports = additionalImports
		self.schemaPath = schemaPath
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
