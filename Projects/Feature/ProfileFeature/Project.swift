import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.ProfileFeature.rawValue,
  targets: [
    .demo(
      module: .feature(.ProfileFeature),
      dependencies: [
        .feature(target: .ProfileFeature)
      ]
    ),
    .tests(
      module: .feature(.ProfileFeature),
      dependencies: [
        .feature(target: .ProfileFeature),
        .feature(target: .ProfileFeature, type: .testing),
      ]
    ),
    .implement(
      module: .feature(.ProfileFeature),
      dependencies: [
        .feature(target: .ProfileFeature, type: .interface),
        .shared(target: .FeatureFoundation),
      ]
    ),
    .testing(
      module: .feature(.ProfileFeature),
      dependencies: [
        .feature(target: .ProfileFeature, type: .interface)
      ]
    ),
    .interface(
      module: .feature(.ProfileFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ]
    ),
  ]
)
