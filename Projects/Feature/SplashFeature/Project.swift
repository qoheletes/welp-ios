import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.SplashFeature.rawValue,
  targets: [
    .interface(
      module: .feature(.SplashFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ]
    ),
    .implement(
      module: .feature(.SplashFeature),
      dependencies: [
        .feature(target: .SplashFeature, type: .interface),
        .shared(target: .FeatureFoundation),
      ]
    ),
  ]
)
