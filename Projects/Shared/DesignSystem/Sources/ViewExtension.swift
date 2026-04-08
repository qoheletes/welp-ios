import SwiftUI

extension View {
  @ViewBuilder
  public func liquidGlassIfAvailable() -> some View {
    if #available(iOS 26, *) {
      glassEffect()
    } else {
      background(.regularMaterial)
    }
  }
}
