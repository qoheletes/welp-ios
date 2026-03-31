import DesignSystem
import SwiftUI

public struct Mode: Identifiable, Equatable {
  public let id: String
  public let name: String
  public let description: String
  public let tone: String
  public let accentColor: Color

  public init(id: String, name: String, description: String, tone: String, accentColor: Color) {
    self.id = id
    self.name = name
    self.description = description
    self.tone = tone
    self.accentColor = accentColor
  }
}

public let allModes: [Mode] = [
  Mode(
    id: "oracle",
    name: "Oracle",
    description: "Mystical clarity",
    tone: "Trust the unknown.",
    accentColor: .welpTextAccent
  ),
  Mode(
    id: "practical",
    name: "Practical",
    description: "Logic-first",
    tone: "What makes sense?",
    accentColor: .welpTextLight
  ),
  Mode(
    id: "optimist",
    name: "Optimist",
    description: "Best-case perspective",
    tone: "Why not?",
    accentColor: .welpYes
  ),
  Mode(
    id: "cynic",
    name: "Cynic",
    description: "Reality check",
    tone: "Are you sure?",
    accentColor: .welpNo
  ),
]

public let defaultMode = allModes[0]
