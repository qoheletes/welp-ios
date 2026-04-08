import AskDomainInterface
import DesignSystem
import SwiftUI

// MARK: - Mode

public struct Mode: Identifiable, Equatable {
  public init(id: String, name: String, description: String, tone: String, accentColor: Color) {
    self.id = id
    self.name = name
    self.description = description
    self.tone = tone
    self.accentColor = accentColor
  }

  public let id: String
  public let name: String
  public let description: String
  public let tone: String
  public let accentColor: Color
}

extension Mode {
  init(entity: ModeEntity) {
    self.init(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      tone: entity.tone,
      accentColor: .welpColor(forToken: entity.colorToken),
    )
  }
}

let allModes: [Mode] = [
  Mode(
    id: "oracle",
    name: "Oracle",
    description: "Mystical clarity",
    tone: "Trust the unknown.",
    accentColor: .welpTextAccent,
  ),
  Mode(
    id: "practical",
    name: "Practical",
    description: "Logic-first",
    tone: "What makes sense?",
    accentColor: .welpTextLight,
  ),
  Mode(
    id: "optimist",
    name: "Optimist",
    description: "Best-case perspective",
    tone: "Why not?",
    accentColor: .welpYes,
  ),
  Mode(
    id: "cynic",
    name: "Cynic",
    description: "Reality check",
    tone: "Are you sure?",
    accentColor: .welpNo,
  ),
]

let defaultMode = allModes[0]

extension Color {
  fileprivate static func welpColor(forToken token: String) -> Color {
    switch token {
    case "accent": .welpTextAccent
    case "light": .welpTextLight
    case "yes": .welpYes
    case "no": .welpNo
    default: .welpTextAccent
    }
  }
}
