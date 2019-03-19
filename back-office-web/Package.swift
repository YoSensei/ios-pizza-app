// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "back-office-web",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git",
                 .upToNextMajor(from: "2.0.0")),
        // 3
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git",
                 .upToNextMajor(from: "1.0.0")),
        // 4
        .package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git",
                 .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.11.0")

        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "back-office-web",
            dependencies: ["Kitura" , "HeliumLogger", "CouchDB", "KituraStencil"],
            path: "Sources"
        ),
        .testTarget(
            name: "back-office-webTests",
            dependencies: ["back-office-web"]),
    ]
)
