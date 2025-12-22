import SwiftSyntax

protocol DeclarationDef: Sendable {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol
}

struct Verbatim: DeclarationDef {
	var syntax: DeclSyntax
	init(_ syntax: DeclSyntax) {
		self.syntax = syntax
	}
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol {
		syntax
	}
}
