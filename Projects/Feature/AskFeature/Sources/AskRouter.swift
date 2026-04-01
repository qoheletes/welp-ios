import FeatureFoundation
import SwiftUI

// MARK: - Route

public enum Route: Hashable {
  case modeSelect(namespace: Namespace.ID)
}

// MARK: - AskRouter

@Observable
@MainActor
public final class AskRouter: FeatureRouter {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public enum Destination: Hashable { }

  public var path = NavigationPath()
  public var selectedMode: Mode = defaultMode

  // MARK: Internal

  func navigate(to route: Route) {
    path.append(route)
  }
}
