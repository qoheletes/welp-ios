import FeatureFoundation
import SwiftUI

@Observable
@MainActor
public final class SettingsRouter: FeatureRouter {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public enum Destination: Hashable {
    // Future destinations: case about, case account
  }

  public var path = NavigationPath()

}
