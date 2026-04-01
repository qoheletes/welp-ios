import OnboardingFeature
import SwiftUI

// MARK: - WelpApp

@main
struct WelpApp: App {
  var body: some Scene {
    WindowGroup {
      Group {
        if router.onboardingComplete {
          MainTabView()
        } else {
          OnboardingView(onComplete: router.completeOnboarding)
            .transition(.opacity)
        }
      }
      .animation(.easeInOut(duration: 0.35), value: router.onboardingComplete)
      .environment(router)
    }
  }

  @State private var router = AppRouter()
}
