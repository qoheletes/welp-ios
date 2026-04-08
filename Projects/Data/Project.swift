import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Data.Database.rawValue,
  targets: [
    // MARK: - Interface

    .interface(
      module: .data(.Database),
      dependencies: [
      ],
    )
  ],
)
