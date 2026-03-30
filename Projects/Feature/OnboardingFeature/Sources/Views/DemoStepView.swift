import SwiftUI
import Shared

struct DemoStepView: View {
    @State private var phase: DemoPhase = .idle
    @State private var questionOffset: CGFloat = 60
    @State private var questionOpacity: Double = 0
    @State private var answerScale: CGFloat = 0.5
    @State private var answerOpacity: Double = 0
    @State private var reasonOpacity: Double = 0

    private enum DemoPhase { case idle, loading, result }

    private let demoQuestion = "Should I switch careers?"
    private let demoAnswer   = "Go for it"
    private let demoReason   = "You've been thinking about it long enough. Trust the instinct."

    var body: some View {
        ZStack {
            Color.welpBg

            VStack(spacing: 0) {
                Spacer()

                // Question bubble
                HStack {
                    Text(demoQuestion)
                        .font(.sbAggroMedium(15))
                        .foregroundStyle(Color.welpTextPrimary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(Color.welpBgCardAlt)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Spacer()
                }
                .padding(.horizontal, 24)
                .opacity(questionOpacity)
                .offset(y: questionOffset)

                Spacer()

                // Loading dots or answer
                if phase == .loading {
                    ThinkingDotsPreview()
                        .transition(.opacity)
                } else if phase == .result {
                    VStack(spacing: 12) {
                        Text(demoAnswer)
                            .font(.sbAggroBold(64))
                            .foregroundStyle(Color.welpYes)
                            .kerning(-2)
                            .scaleEffect(answerScale)
                            .opacity(answerOpacity)

                        Text(demoReason)
                            .font(.sbAggroLight(16))
                            .foregroundStyle(Color.welpTextSpoken)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .opacity(reasonOpacity)
                    }
                    .padding(.horizontal, 32)
                    .transition(.opacity)
                }

                Spacer()

                Text("Ask anything. Get an instant answer.")
                    .font(.sbAggroMedium(13))
                    .foregroundStyle(Color.welpTextMuted)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
            }
        }
        .onAppear {
            runDemo()
        }
    }

    private func runDemo() {
        // Show question
        withAnimation(.easeOut(duration: 0.4).delay(0.4)) {
            questionOpacity = 1
            questionOffset = 0
        }
        // Enter loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation { phase = .loading }
        }
        // Show result
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation { phase = .result }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.05)) {
                answerScale = 1
                answerOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.35).delay(0.5)) {
                reasonOpacity = 1
            }
        }
        // Loop
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            resetDemo()
        }
    }

    private func resetDemo() {
        withAnimation(.easeIn(duration: 0.25)) {
            questionOpacity = 0
            answerOpacity = 0
            reasonOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            phase = .idle
            questionOffset = 60
            answerScale = 0.5
            runDemo()
        }
    }
}

// Minimal inline dots for the demo (no external dep needed)
private struct ThinkingDotsPreview: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.welpTextAccent)
                    .frame(width: 10, height: 10)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .opacity(animating ? 1 : 0.4)
                    .animation(
                        .easeInOut(duration: 0.55)
                        .repeatForever(autoreverses: true)
                        .delay(Double(i) * 0.18),
                        value: animating
                    )
            }
        }
        .onAppear { animating = true }
        .onDisappear { animating = false }
    }
}
