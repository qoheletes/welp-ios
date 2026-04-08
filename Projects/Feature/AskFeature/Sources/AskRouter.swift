import FeatureFoundation
import SwiftUI

// MARK: - AskRouter

@Observable
@MainActor
public final class AskRouter: FeatureRouter {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public enum Destination: Hashable { }

  public var path = NavigationPath()
}
