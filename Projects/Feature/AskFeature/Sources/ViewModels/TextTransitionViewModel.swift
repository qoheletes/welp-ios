import Foundation
import Observation

// MARK: - TextTransitionViewModel

@Observable
@MainActor
final class TextTransitionViewModel {

    // MARK: - State

    private(set) var inputText: String = ""
    private(set) var submittedText: String = ""
    private(set) var isSubmitted: Bool = false

    // MARK: - Internal setter for TextField binding

    func updateInputText(_ text: String) {
        inputText = text
    }

    // MARK: - Public API

    func submit() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        submittedText = trimmed
        isSubmitted = true
    }

    func reset() {
        isSubmitted = false
        inputText = ""
        submittedText = ""
    }
}
