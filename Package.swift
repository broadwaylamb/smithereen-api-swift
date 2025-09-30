// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "SmithereenAPI",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13),
	],
	products: [
		.library(name: "SmithereenAPI", targets: ["SmithereenAPI"]),
	],
	dependencies: [
		.package(url: "https://github.com/broadwaylamb/Hammond.git", revision: "bb2ff0843c5bf61cb4ec3f6fa21fb7dcf31f9ceb"),
	],
	targets: [
		.target(name: "SmithereenAPIInternals"),
		.target(name: "SmithereenAPI", dependencies: ["Hammond", "SmithereenAPIInternals"]),
		.testTarget(name: "SmithereenAPITests", dependencies: ["SmithereenAPIInternals"])
	]
)
