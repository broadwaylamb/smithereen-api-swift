import Foundation
import SwiftSyntax
import SwiftBasicFormat

@MainActor
private let format = BasicFormat(indentationWidth: .tabs(1))

@MainActor
func printScheme(_ part: any GroupPart, baseDir: String) throws {
	if let group = part as? Group {
		let dir = baseDir.appendingPathComponent(group.path)
		try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
		for part in group.nested {
			try printScheme(part, baseDir: dir)
		}
	} else if let file = part.file {
		let rootPath = URL(filePath: #filePath)
			.deletingLastPathComponent()
			.deletingLastPathComponent()
			.deletingLastPathComponent()
			.deletingLastPathComponent()
		let visitor = PrinterVisitor(rootPath: rootPath.path)
		let syntax = visitor.printFile(file)
		try syntax
			.formatted(using: format)
			.description
			.write(toFile: baseDir.appendingPathComponent(file.path), atomically: true, encoding: .utf8)
	}
}

extension String {
	fileprivate func appendingPathComponent(_ component: String) -> String {
		if hasSuffix("/") {
			return self + component
		} else {
			return self + "/" + component
		}
	}
}
