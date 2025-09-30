import SwiftSyntax

struct Group {
	var path: String
	var nested: [any GroupPart]

	init(_ path: String = ".", @GroupBuilder build: () -> [any GroupPart]) {
		self.path = path
		self.nested = build()
	}
}

@resultBuilder
struct GroupBuilder {
	static func buildBlock(_ components: any GroupPart...) -> [any GroupPart] {
		return components
	}
}

protocol GroupPart: Sendable {
	var file: FileDef? { get }
}

extension Group: GroupPart {
	var file: FileDef? { nil }
}
