import AskDomainInterface
import Combine
import Foundation

// MARK: - FetchModesUseCase

public struct FetchModesUseCase: FetchModesUseCaseProtocol {

  // MARK: Lifecycle

  public init(repository: some AskRepository) {
    self.repository = repository
  }

  // MARK: Public

  public func execute() -> AnyPublisher<[ModeEntity], Error> {
    Deferred {
      Future { promise in
        Task {
          do {
            promise(.success(try await repository.fetchModes()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }

  // MARK: Private

  private let repository: any AskRepository
}

// MARK: - AskUseCase

public struct AskUseCase: AskUseCaseProtocol {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func execute(question: String, modeID: String) async throws -> AnswerResult {
    guard let url = URL(string: "\(serverURL)/api/ask") else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONSerialization.data(withJSONObject: ["question": question, "modeID": modeID])

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
      let body = String(data: data, encoding: .utf8) ?? "unknown"
      throw NSError(
        domain: "AskUseCase",
        code: (response as? HTTPURLResponse)?.statusCode ?? -1,
        userInfo: [NSLocalizedDescriptionKey: "API error: \(body)"],
      )
    }

    guard
      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
      let answer = json["answer"] as? String,
      let reason = json["reason"] as? String
    else {
      throw NSError(
        domain: "AskUseCase",
        code: -2,
        userInfo: [NSLocalizedDescriptionKey: "Invalid response format."],
      )
    }

    return AnswerResult(answer: answer, reason: reason)
  }

  // MARK: Private

  private let serverURL = ProcessInfo.processInfo.environment["WELP_SERVER_URL"] ?? "http://localhost:3001"
}
