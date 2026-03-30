import Foundation

private let kOnboardingComplete = "onboarding_complete"

public func hasCompletedOnboarding() -> Bool {
    UserDefaults.standard.bool(forKey: kOnboardingComplete)
}

public func markOnboardingComplete() {
    UserDefaults.standard.set(true, forKey: kOnboardingComplete)
}

public func resetOnboarding() {
    UserDefaults.standard.removeObject(forKey: kOnboardingComplete)
}
