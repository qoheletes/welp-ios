import AskDomainInterface
import Foundation

// MARK: - MockAskUseCase

public final class MockAskUseCase: AskUseCaseProtocol {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public func execute(question: String, modeID _: String) async throws -> AnswerResult {
    let delay = UInt64((800 + Double.random(in: 0..<600)) * 1_000_000)
    try await Task.sleep(nanoseconds: delay)

    let matched = mockRules.first {
      $0.pattern.firstMatch(in: question, range: NSRange(question.startIndex..., in: question)) != nil
    }
    let isYes = Bool.random()

    if let matched {
      return isYes ? matched.yes : matched.no
    }
    let pair = fallbackPairs.randomElement()!
    return isYes ? pair[0] : pair[1]
  }
}

// MARK: - MockRule

private struct MockRule {
  let pattern: NSRegularExpression
  let yes: AnswerResult
  let no: AnswerResult
}

private let mockRules: [MockRule] = [
  rule(
    "read|book",
    yes: .init(answer: "Read it", reason: "You'll definitely get something out of it"),
    no: .init(answer: "Skip it", reason: "Your time matters more right now"),
  ),
  rule(
    "watch|see|movie|show",
    yes: .init(answer: "Watch it", reason: "It's worth seeing at least once"),
    no: .init(answer: "Skip it", reason: "Not worth your time, do something else"),
  ),
  rule(
    "go|visit|attend",
    yes: .init(answer: "Go", reason: "You won't regret going"),
    no: .init(answer: "Stay", reason: "No need to go right now"),
  ),
  rule(
    "buy|purchase|get",
    yes: .init(answer: "Buy it", reason: "You'll regret it if you don't"),
    no: .init(answer: "Don't buy", reason: "Your wallet comes first"),
  ),
  rule(
    "eat|food|meal|lunch|dinner|breakfast",
    yes: .init(answer: "Eat it", reason: "Eat when you're craving it"),
    no: .init(answer: "Skip it", reason: "Save it for something tastier later"),
  ),
  rule(
    "call|text|contact|message|reach",
    yes: .init(answer: "Reach out", reason: "It takes courage to reach out first"),
    no: .init(answer: "Hold off", reason: "They might need space too"),
  ),
  rule(
    "sleep|nap|rest",
    yes: .init(answer: "Sleep", reason: "Rest when your body tells you to"),
    no: .init(answer: "Stay up", reason: "Hang in there a little longer"),
  ),
  rule(
    "workout|exercise|gym|run",
    yes: .init(answer: "Do it", reason: "Moving will definitely lift your mood"),
    no: .init(answer: "Rest", reason: "Your body needs time to recover"),
  ),
]

private let fallbackPairs: [[AnswerResult]] = [
  [
    .init(answer: "Go for it", reason: "Just doing it beats hesitating"),
    .init(answer: "Don't do it", reason: "Your gut is saying no"),
  ],
  [
    .init(answer: "Sounds good", reason: "It'll turn out better than you think"),
    .init(answer: "Not really", reason: "There might be a better option"),
  ],
  [
    .init(answer: "Let's go", reason: "You gotta try to find out"),
    .init(answer: "Stop it", reason: "Forced effort won't get results"),
  ],
  [
    .init(answer: "Absolutely", reason: "This is the right direction"),
    .init(answer: "No way", reason: "Doesn't feel right for now"),
  ],
]

private func rule(_ pattern: String, yes: AnswerResult, no: AnswerResult) -> MockRule {
  let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
  return MockRule(pattern: regex, yes: yes, no: no)
}
