import FeatureFoundation
import SwiftUI

@Observable
@MainActor
public final class ProfileRouter: FeatureRouter {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public enum Destination: Hashable {
    // Future destinations: case editProfile
  }

  public var path = NavigationPath()

}
