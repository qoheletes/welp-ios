import AskDomainInterface
import Foundation

// MARK: - MockAskRepository

public final class MockAskRepository: AskRepository {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func fetchModes() async throws -> [ModeEntity] {
    [
      ModeEntity(id: "oracle", name: "Oracle", description: "Mystical clarity", tone: "Trust the unknown.", colorToken: "accent"),
      ModeEntity(id: "practical", name: "Practical", description: "Logic-first", tone: "What makes sense?", colorToken: "light"),
      ModeEntity(id: "optimist", name: "Optimist", description: "Best-case perspective", tone: "Why not?", colorToken: "yes"),
      ModeEntity(id: "cynic", name: "Cynic", description: "Reality check", tone: "Are you sure?", colorToken: "no"),
    ]
  }
}
