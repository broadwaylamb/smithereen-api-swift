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
		.package(url: "https://github.com/broadwaylamb/Hammond.git", revision: "f55009b14ce32c98127466cea2bcc51f22f6c751"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.7"),
	],
	targets: [
		.target(name: "SmithereenAPIInternals"),
		.target(
			name: "SmithereenAPI",
			dependencies: [
				.product(name: "Hammond", package: "Hammond"),
				.product(name: "HammondEncoders", package: "Hammond"),
				.target(name: "SmithereenAPIInternals"),
			]
		),
		.testTarget(
			name: "SmithereenAPITests",
			dependencies: [
				.target(name: "SmithereenAPI"),
				.product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
			],
		)
	]
)
