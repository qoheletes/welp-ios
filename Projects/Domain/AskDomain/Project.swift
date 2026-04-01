import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Domain.AskDomain.rawValue,
  targets: [
    .interface(
      module: .domain(.AskDomain),
      dependencies: [],
    ),
    .implement(
      module: .domain(.AskDomain),
      dependencies: [
        .domain(target: .AskDomain, type: .interface),
        .core(target: .Networking),
      ],
    ),
  ],
)
