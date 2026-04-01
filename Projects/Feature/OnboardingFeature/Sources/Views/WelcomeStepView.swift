import DesignSystem
import SwiftUI

struct WelcomeStepView: View {

  // MARK: Internal

  var body: some View {
    VStack(spacing: 48) {
      Spacer()

      // Logo
      ZStack {
        Circle()
          .fill(Color.welpBgCardAlt)
          .frame(width: 120, height: 120)

        Circle()
          .fill(Color.welpTextAccent)
          .frame(width: 88, height: 88)
          .overlay {
            Text("wtd?")
              .font(.sbAggroBold(22))
              .foregroundStyle(Color.welpTextPrimary)
              .kerning(-1)
          }
      }
      .scaleEffect(logoScale)

      // Text
      VStack(spacing: 16) {
        Text("What Should I Do?")
          .font(.sbAggroBold(32))
          .foregroundStyle(Color.welpTextPrimary)
          .kerning(-1)
          .multilineTextAlignment(.center)

        Text("When decisions get tough,\nwe'll give you an instant answer.")
          .font(.sbAggroLight(16))
          .foregroundStyle(Color.welpTextSpoken)
          .lineSpacing(10)
          .multilineTextAlignment(.center)
      }
      .opacity(textOpacity)
      .offset(y: textOffset)

      Spacer()
    }
    .padding(.horizontal, 32)
    .onAppear {
      withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1)) {
        logoScale = 1
      }
      withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
        textOpacity = 1
        textOffset = 0
      }
    }
  }

  // MARK: Private

  @State private var logoScale: CGFloat = 0.7
  @State private var textOpacity: Double = 0
  @State private var textOffset: CGFloat = 28

}
