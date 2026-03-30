import ProjectDescription

// MARK: - Module

public enum Module {
  case feature(Feature)
  case domain(Domain)
  case data(Data)
  case core(Core)
  case shared(Shared)

  // MARK: Public

  public func targetName(type: TargetType) -> String {
    switch self {
    case .feature(let feature):
      feature.targetName(type: type)
    case .domain(let domain):
      domain.targetName(type: type)
    case .data(let data):
      data.targetName(type: type)
    case .core(let core):
      core.targetName(type: type)
    case .shared(let shared):
      shared.targetName(type: type)
    }
  }
}

// MARK: Module.Feature

extension Module {
  public enum Feature: String, TargetPathConvertable, CaseIterable {
    case RootFeature
    case SplashFeature
    case AskFeature
    case AuthFeature
    case ProfileFeature
    case OnboardingFeature
  }
}

// MARK: Module.Domain

extension Module {
  public enum Domain: String, TargetPathConvertable {
    case AskDomain
  }
}

// MARK: Module.Data

extension Module {
  public enum Data: String, TargetPathConvertable {
    case Database
  }
}

// MARK: Module.Core

extension Module {
  public enum Core: String, TargetPathConvertable {
    case Networking
  }
}

// MARK: Module.Shared

extension Module {
  public enum Shared: String, TargetPathConvertable {
    case FeatureFoundation
    case DesignSystem
    case ThirdPartyLibrary
    case Utils
  }
}

// MARK: - TargetType

public enum TargetType: String {
  case interface = "Interface"
  case sources = ""
  case testing = "Testing"
  case tests = "Tests"
  case demo = "Demo"
}

// MARK: - TargetPathConvertable

public protocol TargetPathConvertable {
  func targetName(type: TargetType) -> String
}

extension TargetPathConvertable where Self: RawRepresentable {
  public func targetName(type: TargetType) -> String {
    "\(rawValue)\(type.rawValue)"
  }
}
