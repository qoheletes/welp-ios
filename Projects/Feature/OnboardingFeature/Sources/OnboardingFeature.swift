// Public interface for the Onboarding feature module.
@_exported import SwiftUI

public enum OnboardingModule {
  public static func makeView(onComplete: @escaping () -> Void) -> some View {
    OnboardingView(onComplete: onComplete)
  }
}
