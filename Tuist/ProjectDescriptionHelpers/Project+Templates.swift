import EnvironmentPlugin
import ProjectDescription

extension Project {
  public static func framework(
    name: String,
    dependencies: [TargetDependency],
  ) -> Project {
    let target = makeFrameworkTarget(name: name, dependencies: dependencies)
    return Project(name: name, targets: [target])
  }

  //  public static func app(name: String,
  //                         targets: [Target]) -> Project {
  //
  //  }

  public static func makeFrameworkTarget(
    name: String,
    dependencies: [TargetDependency],
  ) -> Target {
    .target(
      name: name,
      destinations: .iOS,
      product: .framework,
      bundleId: "\(environment.organizationName).\(name)",
      sources: ["Sources/**"],
      dependencies: dependencies,
      settings: .settings(configurations: [
        .debug(name: "Debug"),
        .release(name: "Release"),
      ]),
    )
  }
}
