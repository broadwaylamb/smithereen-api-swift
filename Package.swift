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
		.package(url: "https://github.com/broadwaylamb/Hammond.git", revision: "03c1769564f2819ebbad52f98cbda94f5626e449"),
	],
	targets: [
		.target(name: "SmithereenAPIInternals"),
		.target(name: "SmithereenAPI", dependencies: ["Hammond", "SmithereenAPIInternals"]),
	]
)
