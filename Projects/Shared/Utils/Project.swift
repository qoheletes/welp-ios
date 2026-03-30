import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Shared.Utils.rawValue,
  targets: [
    .implement(
      module: .shared(.Utils),
      dependencies: []
    )
  ]
)
