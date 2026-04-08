import AskDomainInterface
import Combine
import SwiftUI

// MARK: - AskViewModel

@Observable
@MainActor
open class AskViewModel {

  // MARK: Lifecycle

  public init(
    fetchModesUseCase: any FetchModesUseCaseProtocol,
    askUseCase: any AskUseCaseProtocol,
  ) {
    self.fetchModesUseCase = fetchModesUseCase
    self.askUseCase = askUseCase
  }

  // MARK: Open

  open func fetchModes() {
    fetchModesUseCase.execute()
      .map { $0.map(Mode.init(entity:)) }
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure = completion {
            self?.modes = allModes
          }
        },
        receiveValue: { [weak self] modes in
          self?.modes = modes
          if let first = modes.first {
            self?.selectedMode = first
          }
        },
      )
      .store(in: &cancellables)
  }

  // MARK: Public

  public var modes = [Mode]()
  public var selectedMode: Mode = defaultMode
  public var responseViewModel: ResponseViewModel?

  public func selectMode(_ mode: Mode) {
    selectedMode = mode
  }

  public func ask(question: String) {
    responseViewModel = ResponseViewModel(
      useCase: askUseCase,
      question: question,
      modeID: selectedMode.id,
    )
  }

  // MARK: Private

  private let fetchModesUseCase: any FetchModesUseCaseProtocol
  private let askUseCase: any AskUseCaseProtocol
  private var cancellables = Set<AnyCancellable>()
}
