import DesignSystem
import SwiftUI
import Utils

public struct OnboardingView: View {

  // MARK: Lifecycle

  public init(onComplete: @escaping () -> Void) {
    self.onComplete = onComplete
  }

  // MARK: Public

  public let onComplete: () -> Void

  public var body: some View {
    ZStack {
      Color.welpBg.ignoresSafeArea()

      VStack(spacing: 0) {
        // Header — skip button on demo step only
        HStack {
          Spacer()
          if currentPage == 1 {
            Button("Skip") {
              finish()
            }
            .font(.sbAggroMedium(14))
            .foregroundStyle(Color.welpTextMuted)
          }
        }
        .frame(height: 44)
        .padding(.horizontal, 24)
        .padding(.top, 8)

        // Paged content
        TabView(selection: $currentPage) {
          WelcomeStepView()
            .tag(0)
          DemoStepView()
            .tag(1)
          ProfileStepView()
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.3), value: currentPage)

        // Bottom navigation
        VStack(spacing: 14) {
          // Page dots
          HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { i in
              Capsule()
                .fill(i == currentPage ? Color.welpTextAccent : Color.welpBgTrack)
                .frame(width: i == currentPage ? 22 : 6, height: 6)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
          }

          // CTA button
          Button(action: handleCTA) {
            Text(currentPage == totalPages - 1 ? "Get Started" : "Next")
              .font(.sbAggroBold(16))
              .foregroundStyle(Color.welpTextPrimary)
              .frame(maxWidth: .infinity)
              .frame(height: 54)
              .background(Color.welpTextAccent)
              .clipShape(RoundedRectangle(cornerRadius: 16))
          }
          .buttonStyle(.plain)

          // Skip for now — last page only
          if currentPage == totalPages - 1 {
            Button("Skip for now") {
              finish()
            }
            .font(.sbAggroMedium(14))
            .foregroundStyle(Color.welpTextMuted)
            .frame(height: 28)
          } else {
            Spacer().frame(height: 28)
          }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 20)
      }
    }
    .preferredColorScheme(.dark)
  }

  // MARK: Private

  @State private var currentPage = 0

  private let totalPages = 3

  private func handleCTA() {
    if currentPage < totalPages - 1 {
      withAnimation(.easeInOut(duration: 0.3)) {
        currentPage += 1
      }
    } else {
      finish()
    }
  }

  private func finish() {
    markOnboardingComplete()
    onComplete()
  }
}
