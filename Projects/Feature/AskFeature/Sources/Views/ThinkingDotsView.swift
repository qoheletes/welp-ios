import SwiftUI
import Shared

struct ThinkingDotsView: View {
    let visible: Bool
    @State private var animating = false

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.welpTextAccent)
                    .frame(width: 12, height: 12)
                    .scaleEffect(animating ? 1.0 : 0.45)
                    .opacity(animating ? 1 : 0.3)
                    .animation(
                        .easeInOut(duration: 0.55)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.2),
                        value: animating
                    )
            }
        }
        .opacity(visible ? 1 : 0)
        .onChange(of: visible) { _, isVisible in
            animating = isVisible
        }
        .onAppear {
            animating = visible
        }
    }
}
