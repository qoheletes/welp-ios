import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription

private let infoPlist: [String: Plist.Value] = [
  "CFBundleDisplayName": "wtd?",
  "UIUserInterfaceStyle": "Dark",
  "UILaunchScreen": .dictionary([:]),
  "UIAppFonts": .array([
    "SBAggroOTF B.otf",
    "SBAggroOTF M.otf",
    "SBAggroOTF L.otf",
  ]),
]

let project = Project(
  name: environment.name,
  targets: [
    .target(
      name: environment.name,
      destinations: environment.destination,
      product: .app,
      bundleId: "\(environment.organizationName).\(environment.name.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: Module.Feature.allCases.map { .feature(target: $0) },
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ])
    )
  ]
)
