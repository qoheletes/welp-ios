import Foundation
import Observation

// MARK: - TextTransitionViewModel

@Observable
@MainActor
final class TextTransitionViewModel {

  private(set) var inputText = ""
  private(set) var submittedText = ""
  private(set) var isSubmitted = false

  func updateInputText(_ text: String) {
    inputText = text
  }

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
