import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Shared.DesignSystem.rawValue,
  targets: [
    .implement(
      module: .shared(.DesignSystem),
      resources: ["Resources/**"],
      dependencies: [],
    )
  ],
)
