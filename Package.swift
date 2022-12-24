// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "QuickLookLikeFramework",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "QuickLookLikeFramework",
            targets: ["QuickLookLikeFramework"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "QuickLookLikeFramework",
            dependencies: [])
    ]
)
