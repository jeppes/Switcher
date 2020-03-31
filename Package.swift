// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Switcher",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Switcher",
            targets: ["Switcher"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "Switcher",
            dependencies: ["CasePaths"]),
        .testTarget(
            name: "SwitcherTests",
            dependencies: ["Switcher"]),
    ]
)
