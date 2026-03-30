import SwiftUI
import Shared

@Observable
final class AppCoordinator {
    var onboardingComplete: Bool

    init() {
        onboardingComplete = hasCompletedOnboarding()
    }

    func completeOnboarding() {
        onboardingComplete = true
    }
}
