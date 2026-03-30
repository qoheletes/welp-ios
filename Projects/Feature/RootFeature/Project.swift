import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.RootFeature.rawValue,
  targets: [
    .interface(
      module: .feature(.RootFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ]
    ),
    .implement(
      module: .feature(.RootFeature),
      dependencies: [
        .feature(target: .RootFeature, type: .interface),
        .feature(target: .SplashFeature),
        .feature(target: .AskFeature),
        .feature(target: .AuthFeature, type: .interface),
        .feature(target: .ProfileFeature, type: .interface),
        .feature(target: .OnboardingFeature, type: .interface),
        .shared(target: .FeatureFoundation),
      ]
    ),
  ]
)
