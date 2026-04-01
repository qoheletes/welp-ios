import AskFeature
import AuthFeature
import FeatureFoundation
import ProfileFeature
import SwiftUI
import Utils

@Observable
@MainActor
final class AppRouter {

  // MARK: Lifecycle

  init() {
    onboardingComplete = hasCompletedOnboarding()
  }

  // MARK: Internal

  var onboardingComplete: Bool
  var selectedTab = Tab.ask

  let askRouter = AskRouter()
  let profileRouter = ProfileRouter()
  let settingsRouter = SettingsRouter()

  func completeOnboarding() {
    onboardingComplete = true
  }

  func switchTo(_ tab: Tab) {
    selectedTab = tab
  }
}
