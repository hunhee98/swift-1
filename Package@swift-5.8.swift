// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "AirbnbSwift",
  platforms: [.macOS(.v10_13)],
  products: [
    .plugin(name: "FormatSwift", targets: ["FormatSwift"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.3"),
  ],
  targets: [
    .plugin(
      name: "FormatSwift",
      capability: .command(
        intent: .custom(
          verb: "format",
          description: "Formats Swift source files according to the Airbnb Swift Style Guide"),
        permissions: [
          .writeToPackageDirectory(reason: "Format Swift source files"),
        ]),
      dependencies: [
        "AirbnbSwiftFormatTool",
        "SwiftFormat",
        "SwiftLintBinary",
      ]),

    .executableTarget(
      name: "AirbnbSwiftFormatTool",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ],
      resources: [
        .process("airbnb.swiftformat"),
        .process("swiftlint.yml"),
      ],
      swiftSettings: .airbnbDefault()),

    .binaryTarget(
      name: "SwiftFormat",
      url: "https://github.com/calda/SwiftFormat/releases/download/0.52-beta-3/SwiftFormat.artifactbundle.zip",
      checksum: "ecca7f964e7dcf2d846633cf394c0cffc7628a5ff89d85d2e206f41142f0a859"),

    .binaryTarget(
      name: "SwiftLintBinary",
      url: "https://github.com/realm/SwiftLint/releases/download/0.48.0/SwiftLintBinary-macos.artifactbundle.zip",
      checksum: "9c255e797260054296f9e4e4cd7e1339a15093d75f7c4227b9568d63edddba50"),
  ])

// Emit an error on Linux, so Swift Package Manager's platform support detection doesn't say this package supports Linux
// https://github.com/airbnb/swift/discussions/197#discussioncomment-4055303
#if os(Linux)
#error("Linux is currently not supported")
#endif

// Emit an error on Linux, so Swift Package Manager's platform support detection doesn't say this package supports Linux
// https://github.com/airbnb/swift/discussions/197#discussioncomment-4055303
#if os(Linux)
#error("Linux is currently not supported")
#endif

extension [SwiftSetting] {
  /// Default Swift compiler flags recommended by the Airbnb Swift Style Guide.
  /// Do not modify: updated automatically by Airbnb Swift Format Tool.
  ///
  /// - Parameter foundationModule: Whether or not this target is considered
  ///   a "foundation module". We currently only recommend using strict
  ///   concurrency checking in foundational modules, rather than feature modules.
  static func airbnbDefault(foundationModule: Bool = false) -> [SwiftSetting] {
    var settings = [SwiftSetting]()
    settings.append(.enableExperimentalFeature("BareSlashRegexLiterals"))
    settings.append(.enableExperimentalFeature("ConciseMagicFile"))
    settings.append(.enableExperimentalFeature("ImplicitOpenExistentials"))

    if foundationModule {
      settings.append(.enableUpcomingFeature("StrictConcurrency"))
    }

    return settings
  }
}