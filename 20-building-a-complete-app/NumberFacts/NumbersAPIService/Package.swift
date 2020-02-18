// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NumbersAPIService",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "NumbersAPIService",
            targets: [
                "NumbersAPIService",
            ]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../Common"),
        
        .package(url: "https://github.com/CypherPoet/CypherPoetNetStack.git", from: "0.0.28"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "NumbersAPIService",
            dependencies: [
                "Common",
                "CypherPoetNetStack",
            ],
            path: "Sources/"
        ),
        
        .testTarget(
            name: "NumbersAPIServiceTests",
            dependencies: [
                "NumbersAPIService",
            ],
            path: "Tests/NumbersAPIService"
        ),
    ]
)
