// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SegmentFacebookAppEvents",
    platforms: [.iOS(.v10)],
    products: [.library(name: "SegmentFacebookAppEvents", targets: ["SegmentFacebookAppEvents"])],
    dependencies: [
      .package(name: "Segment", url: "https://github.com/segmentio/analytics-ios.git", from: "4.1.6"),
      .package(name: "Facebook", url: "https://github.com/facebook/facebook-ios-sdk", from: "12.3.2"),
    ],
    targets: [
        .target(
            name: "SegmentFacebookAppEvents",
            dependencies: [
              "Segment",
              .product(name: "FacebookCore", package: "Facebook"),
            ],
            path: "Segment-Facebook-App-Events/Classes",
            publicHeadersPath: ""
        )
    ]
)