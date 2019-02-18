// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BinarySize",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "BinarySize",
            dependencies: ["Core", "Core2"]),
        .target(
          name: "Core",
          dependencies: []),
        .target(
          name: "Core2",
          dependencies: []),
        .testTarget(
            name: "BinarySizeTests",
            dependencies: ["BinarySize"]),
    ]
)
