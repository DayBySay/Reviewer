// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPMTools",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", .branch("swift-5.2-branch")),
    ],
	targets: [
			.target(
				name: "SwiftPMTools",
				dependencies: []),
		]
)
