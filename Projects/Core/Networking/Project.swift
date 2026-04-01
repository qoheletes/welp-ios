import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Core.Networking.rawValue,
  targets: [
    .implement(
      module: .core(.Networking),
      dependencies: [
        .shared(target: .ThirdPartyLibrary)
      ],
    )
  ],
)
