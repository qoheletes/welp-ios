import Combine
import Foundation

// MARK: - ModeEntity

public struct ModeEntity: Sendable {
  public init(id: String, name: String, description: String, tone: String, colorToken: String) {
    self.id = id
    self.name = name
    self.description = description
    self.tone = tone
    self.colorToken = colorToken
  }

  public let id: String
  public let name: String
  public let description: String
  public let tone: String
  public let colorToken: String

}

// MARK: - AnswerResult

public struct AnswerResult: Sendable {
  public init(answer: String, reason: String) {
    self.answer = answer
    self.reason = reason
  }

  public let answer: String
  public let reason: String

}

// MARK: - AskRepository

public protocol AskRepository: Sendable {
  func fetchModes() async throws -> [ModeEntity]
}

// MARK: - FetchModesUseCaseProtocol

public protocol FetchModesUseCaseProtocol: Sendable {
  func execute() -> AnyPublisher<[ModeEntity], Error>
}

// MARK: - AskUseCaseProtocol

public protocol AskUseCaseProtocol: Sendable {
  func execute(question: String, modeID: String) async throws -> AnswerResult
}
