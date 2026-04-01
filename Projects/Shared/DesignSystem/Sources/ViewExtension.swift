import SwiftUI

extension View {
  @ViewBuilder
  func liquidGlassIfAvaliable() -> some View {
    if #available(iOS 26, *) {
      glassEffect()
    } else {
      background(.regularMaterial)
    }
  }
}
