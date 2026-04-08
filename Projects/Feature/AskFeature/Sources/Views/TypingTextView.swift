import DesignSystem
import SwiftUI
import ThirdPartyLibrary

private let hints: [String] = [
  "not my fault if this answer flops, bestie 💀",
  "ask me anything. I literally cannot be wrong 🫡",
  "your fate is in my circuits now ⚡",
  "i consulted the vibes. you're welcome 🔮",
  "no cap, I've seen worse decisions 😇",
  "this is your sign. yes, that one 👇",
  "the oracle has entered the chat 🎱",
]

private let typeSpeed: UInt64 = 48_000_000
private let eraseSpeed: UInt64 = 22_000_000
private let pauseAfterType: UInt64 = 2_200_000_000
private let pauseAfterErase: UInt64 = 350_000_000
private let initialDelay: UInt64 = 500_000_000

// MARK: - TypingTextView

struct TypingTextView: View {

  // MARK: Internal

  var body: some View {
    Text(displayText)
      .font(.sbAggroBold(34))
      .foregroundStyle(Color.welpTextAccent)
      .lineSpacing(10)
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 28)
      .onAppear { startTyping() }
      .onDisappear {
        typingTask?.cancel()
        typingTask = nil
      }
  }

  // MARK: Private

  @State private var displayText = "not my fault if this answer flops, bestie 💀"
  @State private var typingTask: Task<Void, Never>?

  private func startTyping() {
    typingTask = Task { @MainActor in
      try? await Task.sleep(nanoseconds: initialDelay)

      var hintIndex = 0
      while !Task.isCancelled {
        let hint = hints[hintIndex]

        // Type
        for charCount in 1...hint.count {
          guard !Task.isCancelled else { return }
          displayText = String(hint.prefix(charCount))
          try? await Task.sleep(nanoseconds: typeSpeed)
        }

        try? await Task.sleep(nanoseconds: pauseAfterType)

        // Erase
        var remaining = hint.count
        while remaining > 0 {
          guard !Task.isCancelled else { return }
          remaining -= 1
          displayText = String(hint.prefix(remaining))
          try? await Task.sleep(nanoseconds: eraseSpeed)
        }

        try? await Task.sleep(nanoseconds: pauseAfterErase)
        hintIndex = (hintIndex + 1) % hints.count
      }
    }
  }
}
