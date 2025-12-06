import SwiftSyntax

struct RequestDef: Documentable {
	var name: String
	var structDef: StructDef
	
	var doc: String? {
		get {
			structDef.doc
		}
		set {
			structDef.doc = newValue
		}
	}

	static let defaultConformances: [TypeRef] = [
		TypeRef(name: "SmithereenAPIRequest"),
		.hashable,
		.encodable,
	]

	init(
		_ name: String,
		conformances: [TypeRef] = defaultConformances,
		@StructDefBuilder build: () -> any StructDefPart,
	) {
		self.name = name
		structDef = StructDef(
			(name.split(separator: ".").last.map(String.init) ?? name).capitalized,
			conformances: conformances,
			build: build,
		)
	}
}

extension RequestDef: GroupPart {
	var file: FileDef? {
		FileDef(
			name
				.split(separator: ".")
				.map { $0.capitalized }
				.joined(separator: ".") + ".swift",
			additionalImports: ["Hammond"],
		) {
			self
		}
	}
}

extension RequestDef: StructDefPart {
	var components: [any StructDefPart] { [self] }

	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		visitor.printRequest(self)
	}
}
