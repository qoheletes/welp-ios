import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Shared.ThirdPartyLibrary.rawValue,
  targets: [
    .implement(
      module: .shared(.ThirdPartyLibrary),
      dependencies: [
        .external(name: "Swinject", condition: .none),
        .external(name: "Alamofire", condition: .none),
      ],
    )
  ],
)
