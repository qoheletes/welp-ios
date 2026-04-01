import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Feature.OnboardingFeature.rawValue,
  targets: [
    .demo(
      module: .feature(.OnboardingFeature),
      dependencies: [
        .feature(target: .OnboardingFeature)
      ],
    ),
    .tests(
      module: .feature(.OnboardingFeature),
      dependencies: [
        .feature(target: .OnboardingFeature),
        .feature(target: .OnboardingFeature, type: .testing),
      ],
    ),
    .implement(
      module: .feature(.OnboardingFeature),
      dependencies: [
        .feature(target: .OnboardingFeature, type: .interface),
        .shared(target: .FeatureFoundation),
        .shared(target: .DesignSystem),
        .shared(target: .Utils),
      ],
    ),
    .testing(
      module: .feature(.OnboardingFeature),
      dependencies: [
        .feature(target: .OnboardingFeature, type: .interface)
      ],
    ),
    .interface(
      module: .feature(.OnboardingFeature),
      dependencies: [
        .shared(target: .FeatureFoundation)
      ],
    ),
  ],
)
