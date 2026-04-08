import AskDomainInterface
import SwiftUI

// MARK: - ResponseViewModel

@Observable
@MainActor
public final class ResponseViewModel: Identifiable {

  // MARK: Lifecycle

  public init(useCase: any AskUseCaseProtocol, question: String, modeID: String) {
    self.useCase = useCase
    self.question = question
    self.modeID = modeID
  }

  // MARK: Public

  public enum FetchState: Equatable {
    case idle
    case loading
    case success(text: String)
    case failure(message: String)
  }

  public let id = UUID()

  public private(set) var fetchState = FetchState.idle

  public var responseText: String? {
    if case .success(let text) = fetchState { return text }
    return nil
  }

  public var isLoading: Bool {
    fetchState == .loading
  }

  public func fetchResponse() {
    fetchTask?.cancel()
    fetchState = .loading

    fetchTask = Task {
      do {
        let result = try await useCase.execute(question: question, modeID: modeID)
        guard !Task.isCancelled else { return }
        fetchState = .success(text: result.answer)
      } catch {
        guard !Task.isCancelled else { return }
        fetchState = .failure(message: error.localizedDescription)
      }
    }
  }

  public func reset() {
    fetchTask?.cancel()
    fetchTask = nil
    fetchState = .idle
  }

  // MARK: Private

  private let useCase: any AskUseCaseProtocol
  private let question: String
  private let modeID: String
  private var fetchTask: Task<Void, Never>?

}
