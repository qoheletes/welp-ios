import SwiftUI

// MARK: - ResponseViewModel

@Observable
@MainActor
final class ResponseViewModel {

  // MARK: Internal

  enum FetchState: Equatable {
    case idle
    case loading
    case success(text: String)
    case failure(message: String)
  }

  private(set) var fetchState = FetchState.idle

  var responseText: String? {
    if case .success(let text) = fetchState { return text }
    return nil
  }

  var isLoading: Bool {
    fetchState == .loading
  }

  func fetchResponse() {
    fetchTask?.cancel()
    fetchState = .loading

    fetchTask = Task {
      // Simulate a 1-second network delay, then return a hardcoded response.
      // Replace this body with a real service call when integrating the network layer.
      do {
        try await Task.sleep(nanoseconds: 1_000_000_000)
      } catch {
        // Task was cancelled — bail out silently.
        return
      }

      guard !Task.isCancelled else { return }

      fetchState = .success(text: "Go for it")
    }
  }

  func reset() {
    fetchTask?.cancel()
    fetchTask = nil
    fetchState = .idle
  }

  // MARK: Private

  private var fetchTask: Task<Void, Never>?

}
