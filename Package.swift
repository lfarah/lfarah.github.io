// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Blog",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "Blog",
            targets: ["Blog"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
        .package(name: "SplashPublishPlugin", url: "https://github.com/johnsundell/splashpublishplugin.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "Blog",
            dependencies: ["Publish", "SplashPublishPlugin"]
        )
    ]
)
