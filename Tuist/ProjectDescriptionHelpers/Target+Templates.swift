import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription

// MARK: - Demo

extension Target {
  public static func demo(
    module: Module,
    dependencies: [TargetDependency] = [],
    hasEntitlements: Bool = false,
  ) -> Target {
    let moduleName = module.targetName(type: .demo)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .app,
      bundleId: "\(environment.organizationName).\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      infoPlist: .extendingDefault(with: [
        "UILaunchStoryboardName": "LaunchScreen",
        "CFBundleVersion": "1.0",
      ]),
      sources: ["Demo/Sources/**"],
      resources: ["Demo/Resources/**"],
      entitlements: hasEntitlements ? .file(path: "Demo/\(moduleName).entitlements") : nil,
      dependencies: dependencies,
      settings: .settings(
        base: ["DEVELOPE_TEAM": "KL2HAQ9H72"],
        configurations: [
          .debug(name: "Debug"),
          .release(name: "Release"),
        ],
      ),
    )
  }
}

// MARK: - Tests

extension Target {
  public static func tests(
    module: Module,
    dependencies: [TargetDependency] = [],
  ) -> Target {
    let moduleName = module.targetName(type: .tests)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .unitTests,
      bundleId: "\(environment.organizationName).\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      sources: ["Tests/**"],
      dependencies: dependencies + [.xctest],
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }
}

// MARK: - Interface

extension Target {
  public static func interface(
    module: Module,
    dependencies: [TargetDependency] = [],
  ) -> Target {
    let moduleName = module.targetName(type: .interface)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .framework,
      bundleId: "\(environment.organizationName).\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      sources: ["Interface/**"],
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }
}

// MARK: - Implement

extension Target {
  public static func implement(
    module: Module,
    dependencies: [TargetDependency] = [],
  ) -> Target {
    let moduleName = module.targetName(type: .sources)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .framework,
      bundleId: "\(environment.organizationName).\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      sources: ["Sources/**"],
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }

  public static func implement(
    module: Module,
    resources: ProjectDescription.ResourceFileElements,
    dependencies: [TargetDependency] = [],
  ) -> Target {
    let moduleName = module.targetName(type: .sources)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .framework,
      bundleId: "com.\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      sources: ["Sources/**"],
      resources: resources,
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }
}

// MARK: - Testing

extension Target {
  public static func testing(module: Module, dependencies: [TargetDependency] = []) -> Target {
    let moduleName = module.targetName(type: .testing)
    return .target(
      name: moduleName,
      destinations: environment.destination,
      product: .framework,
      bundleId: "\(environment.organizationName).\(moduleName.lowercased())",
      deploymentTargets: environment.deploymentTargets,
      sources: ["Testing/**"],
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }
}
