import SwiftUI
import Shared

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
    Mode(id: "oracle",    name: "Oracle",    description: "Mystical clarity",       tone: "Trust the unknown.",   accentColor: Color(hex: "#8B70D8")),
    Mode(id: "practical", name: "Practical", description: "Logic-first",            tone: "What makes sense?",    accentColor: Color(hex: "#5B9BD5")),
    Mode(id: "optimist",  name: "Optimist",  description: "Best-case perspective",  tone: "Why not?",             accentColor: Color(hex: "#5BBD8B")),
    Mode(id: "cynic",     name: "Cynic",     description: "Reality check",          tone: "Are you sure?",        accentColor: Color(hex: "#D55B5B")),
]

public let defaultMode = allModes[0]
