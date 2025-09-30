// swift-tools-version: 6.2

import PackageDescription

let package = Package(
	name: "SmithereenAPICodegen",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.executable(name: "SmithereenAPICodegen", targets: ["SmithereenAPICodegen"]),
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-syntax", from: "602.0.0"),
	],
	targets: [
		.executableTarget(
			name: "SmithereenAPICodegen",
			dependencies: [
				.product(name: "SwiftSyntaxBuilder", package: "swift-syntax")
			]
		),
	]
)
