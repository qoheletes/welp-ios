import SwiftUI

// FeatureFoundation: Base types and protocols shared across feature modules

// MARK: - Tab

public enum Tab: String, Hashable, CaseIterable {
  case ask
  case profile
  case settings
}

// MARK: - FeatureRouter

@MainActor
public protocol FeatureRouter: AnyObject {
  associatedtype Destination: Hashable

  var path: NavigationPath { get set }
}

extension FeatureRouter {
  public func push(_ destination: Destination) {
    path.append(destination)
  }

  public func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  public func popToRoot() {
    path = NavigationPath()
  }
}
