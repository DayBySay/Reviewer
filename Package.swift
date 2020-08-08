// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reviewer",
    products: [
        .executable(name: "Reviewer", targets: ["Reviewer"]),
        .library(name: "ReviewerFramework", targets: ["ReviewerFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-tools-support-core.git", .exact("0.1.5"))
    ],
    targets: [
        .target(
            name: "Reviewer",
            dependencies: [
                "ReviewerFramework",
                .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core"),
            ]),
        .target(name: "ReviewerFramework"),
        .testTarget(
            name: "ReviewerTests",
            dependencies: ["Reviewer"]),
    ]
)
