import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.AskFeature.rawValue,
  targets: [
    .demo(
      module: .feature(.AskFeature),
      dependencies: [
        .feature(target: .AskFeature)
      ],
    ),
    .tests(
      module: .feature(.AskFeature),
      dependencies: [
        .feature(target: .AskFeature),
        .feature(target: .AskFeature, type: .testing),
      ],
    ),
    .implement(
      module: .feature(.AskFeature),
      dependencies: [
        .feature(target: .AskFeature, type: .interface),
        .shared(target: .FeatureFoundation),
        .shared(target: .DesignSystem),
        .domain(target: .AskDomain, type: .interface),
      ],
    ),
    .testing(
      module: .feature(.AskFeature),
      dependencies: [
        .feature(target: .AskFeature, type: .interface)
      ],
    ),
    .interface(
      module: .feature(.AskFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ],
    ),
  ],
  schemes: [
    .scheme(
      name: "AskFeatureDemo",
      buildAction: .buildAction(targets: ["AskFeatureDemo"]),
      runAction: .runAction(executable: "AskFeatureDemo"),
    )
  ],
)
