import SwiftSyntax

protocol DeclarationDef: Sendable {
	func accept(_ visitor: PrinterVisitor) -> any DeclSyntaxProtocol
}
