import SwiftUI

extension Button {
  @ViewBuilder
  public func glassButtonStyleIfAvailable() -> some View {
    if #available(iOS 26, *) {
      buttonStyle(.glass)
    } else {
      buttonStyle(.plain)
    }
  }
}
