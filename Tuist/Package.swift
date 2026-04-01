// swift-tools-version: 5.10
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
  productTypes: [
    "Swinject": .framework,
    "Alamofire": .framework,
  ]
)
#endif

let package = Package(
  name: "Welp",
  dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
    .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0"),

  ],
)
