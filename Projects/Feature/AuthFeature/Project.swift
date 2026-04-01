import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.AuthFeature.rawValue,
  targets: [
    .demo(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature)
      ],
    ),
    .tests(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature),
        .feature(target: .AuthFeature, type: .testing),
      ],
    ),
    .implement(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature, type: .interface),
        .shared(target: .FeatureFoundation),
        .shared(target: .DesignSystem),
        .shared(target: .Utils),
      ],
    ),
    .testing(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature, type: .interface)
      ],
    ),
    .interface(
      module: .feature(.AuthFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ],
    ),
  ],
)
