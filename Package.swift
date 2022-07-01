// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CalmingNotificationsModule",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CalmingNotificationsModule",
            targets: ["CalmingNotificationsModule"]),
    ],
    dependencies: [
        .package(name: "BabyNet",
                 url: "https://github.com/4440449/BabyNet.git",
                 .branch("master")),
        .package(name: "MommysEye",
                 url: "https://github.com/4440449/MommysEye.git",
                 branch: ("master"))
    ],
    targets: [
        .target(
            name: "CalmingNotificationsModule",
            dependencies: ["BabyNet", "MommysEye"],
            resources: [.process("LaunchScreen.storyboard"),
                        .process("CalmingNotifications.xcdatamodeld")]
        ),
        .testTarget(
            name: "CalmingNotificationsModuleTests",
            dependencies: ["CalmingNotificationsModule"]),
    ]
)
