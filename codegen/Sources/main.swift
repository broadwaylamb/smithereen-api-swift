import Foundation

private struct ArgumentError: Error, CustomStringConvertible {
	var description: String

	init(_ description: String) {
		self.description = description
	}
}

if CommandLine.arguments.count < 2 {
	throw ArgumentError("Expected an output directory as the first argument")
}

try printScheme(schema, baseDir: CommandLine.arguments[1])
