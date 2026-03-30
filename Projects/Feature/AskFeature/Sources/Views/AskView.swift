import SwiftUI
import Shared

private enum ScreenState: Equatable {
    case idle
    case loading
    case result(answer: String, reason: String)
}

public struct AskView: View {
    @State private var screenState: ScreenState = .idle
    @State private var inputText = ""
    @State private var activeQuestion = ""
    @State private var selectedMode: Mode = defaultMode
    @State private var modeSelectorVisible = false
    @State private var errorMessage: String? = nil
    @State private var actionsVisible = false

    // Animation states
    @State private var typingTextOpacity: Double = 1
    @State private var questionOpacity: Double = 0
    @State private var questionOffset: CGFloat = 60
    @State private var answerScale: CGFloat = 0.5
    @State private var answerOpacity: Double = 0
    @State private var reasonOpacity: Double = 0
    @State private var actionsOpacity: Double = 0
    @State private var errorOpacity: Double = 0
    @State private var errorTask: Task<Void, Never>?

    // Mode button animation states
    @State private var modeButtonScale: CGFloat = 1.0
    @State private var chevronRotation: Double = 0

    public init() {}

    public var body: some View {
        ZStack(alignment: .top) {
            Color.welpBg.ignoresSafeArea()

            // Mode selector button — top center
            modeSelectorButton
                .zIndex(10)

            // Ambient typing text — idle only
            VStack {
                Spacer().frame(height: UIScreen.main.bounds.height * 0.38)
                TypingTextView()
                    .allowsHitTesting(false)
                Spacer()
            }
            .opacity(typingTextOpacity)

            // Active question bubble
            GeometryReader { geo in
                let top = geo.safeAreaInsets.top
                Text(activeQuestion)
                    .font(.sbAggroMedium(16))
                    .foregroundStyle(Color.welpTextPrimary)
                    .lineSpacing(8)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color.welpBgCardAlt)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 24)
                    .padding(.top, top + 72)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(questionOpacity)
                    .offset(y: questionOffset)
                    .allowsHitTesting(false)
            }

            // Thinking dots — loading
            ThinkingDotsView(visible: screenState == .loading)

            // Answer — result
            if case .result(let answer, let reason) = screenState {
                answerView(answer: answer, reason: reason)
            }

            // Error banner
            if let error = errorMessage {
                errorBanner(message: error)
            }

            // Input + actions at bottom
            GeometryReader { geo in
                let bottom = geo.safeAreaInsets.bottom
                VStack {
                    Spacer()

                    // Share + Ask Again
                    if actionsVisible {
                        actionButtons
                            .padding(.horizontal, 24)
                            .padding(.bottom, bottom + 120)
                            .opacity(actionsOpacity)
                    }

                    // Text input — idle only
                    if screenState == .idle {
                        QuestionInputView(
                            text: $inputText,
                            onSubmit: handleSubmit,
                            onTextChange: { if errorMessage != nil { errorMessage = nil } }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, bottom + 24)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $modeSelectorVisible) {
            ModeSelectorView(selectedMode: $selectedMode, isPresented: $modeSelectorVisible)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Subviews

    private var modeSelectorButton: some View {
        GeometryReader { geo in
            let top = geo.safeAreaInsets.top
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    modeButtonScale = 0.9
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                        modeButtonScale = 1.0
                    }
                }
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    chevronRotation = 180
                }
                modeSelectorVisible = true
            } label: {
                HStack(spacing: 6) {
                    Circle()
                        .fill(selectedMode.accentColor)
                        .frame(width: 7, height: 7)
                    Text(selectedMode.name)
                        .font(.sbAggroMedium(13))
                        .foregroundStyle(selectedMode.accentColor)
                        .kerning(0.3)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(selectedMode.accentColor)
                        .rotationEffect(.degrees(chevronRotation))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.welpBgCardAlt)
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(selectedMode.accentColor.opacity(0.4), lineWidth: 1.5)
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedMode.id)
            }
            .buttonStyle(.plain)
            .scaleEffect(modeButtonScale)
            .frame(maxWidth: .infinity)
            .padding(.top, top + 16)
        }
        .frame(height: 80)
        .onChange(of: modeSelectorVisible) { _, isVisible in
            if !isVisible {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    chevronRotation = 0
                }
            }
        }
    }

    private func answerView(answer: String, reason: String) -> some View {
        let color = answer.lowercased().contains("no") ? Color.welpNo : Color.welpYes

        return VStack(spacing: 16) {
            Text(answer)
                .font(.sbAggroBold(96))
                .foregroundStyle(color)
                .kerning(-4)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .scaleEffect(answerScale)
                .opacity(answerOpacity)
                .allowsHitTesting(false)

            Text(reason)
                .font(.sbAggroLight(18))
                .foregroundStyle(Color.welpTextSpoken)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .padding(.horizontal, 32)
                .opacity(reasonOpacity)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorBanner(message: String) -> some View {
        GeometryReader { geo in
            let bottom = geo.safeAreaInsets.bottom
            Text(message)
                .font(.sbAggroMedium(13))
                .foregroundStyle(Color(hex: "#D55B5B"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "#3A1A1A"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(hex: "#D55B5B").opacity(0.27), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, bottom + 130)
                .opacity(errorOpacity)
                .allowsHitTesting(false)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Share
            Button {
                handleShare()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16))
                    Text("Share")
                        .font(.sbAggroMedium(15))
                }
                .foregroundStyle(Color.welpTextSpoken)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.welpBgCardAlt)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            // Ask Again
            Button(action: handleAskAgain) {
                Text("Ask Again")
                    .font(.sbAggroBold(15))
                    .foregroundStyle(selectedMode.accentColor)
                    .kerning(0.2)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(selectedMode.accentColor, lineWidth: 2)
                    )
            }
            .buttonStyle(.plain)
            .layoutPriority(1)
        }
    }

    // MARK: - Actions

    private func handleSubmit() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, screenState == .idle else { return }

        activeQuestion = trimmed
        inputText = ""
        actionsVisible = false
        screenState = .loading

        // Reset animation values
        questionOpacity = 0
        questionOffset = 60
        answerScale = 0.5
        answerOpacity = 0
        reasonOpacity = 0
        actionsOpacity = 0

        withAnimation(.easeOut(duration: 0.35)) {
            typingTextOpacity = 0
            questionOpacity = 1
            questionOffset = 0
        }

        Task {
            do {
                let result = try await askQuestion(trimmed)
                await MainActor.run {
                    screenState = .result(answer: result.answer, reason: result.reason)
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
                        answerScale = 1
                        answerOpacity = 1
                    }
                    withAnimation(.easeOut(duration: 0.35).delay(0.4)) {
                        reasonOpacity = 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        actionsVisible = true
                        withAnimation(.easeOut(duration: 0.35)) {
                            actionsOpacity = 1
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    screenState = .idle
                    withAnimation(.easeOut(duration: 0.3)) {
                        typingTextOpacity = 1
                        questionOpacity = 0
                    }
                    showError(error.localizedDescription)
                }
            }
        }
    }

    private func handleAskAgain() {
        withAnimation(.easeIn(duration: 0.2)) {
            answerOpacity = 0
            reasonOpacity = 0
            actionsOpacity = 0
            questionOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            screenState = .idle
            actionsVisible = false
            activeQuestion = ""
            questionOffset = 60
            answerScale = 0.5
            withAnimation(.easeOut(duration: 0.3)) {
                typingTextOpacity = 1
            }
        }
    }

    private func handleShare() {
        guard case .result(let answer, let reason) = screenState else { return }
        let text = "\"\(activeQuestion)\" → \(answer)\n\n\(reason)\n\nAsked on wtd?"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let vc = scene.windows.first?.rootViewController {
            vc.present(av, animated: true)
        }
    }

    private func showError(_ message: String) {
        errorMessage = message
        errorTask?.cancel()
        withAnimation(.easeOut(duration: 0.25)) { errorOpacity = 1 }
        errorTask = Task {
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeIn(duration: 0.3)) { errorOpacity = 0 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    errorMessage = nil
                }
            }
        }
    }
}

// MARK: - QuestionInputView

private struct QuestionInputView: View {
    @Binding var text: String
    let onSubmit: () -> Void
    let onTextChange: () -> Void
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 10) {
            TextField("", text: $text, prompt: Text("Ask anything...").foregroundColor(Color.welpTextMuted))
                .font(.sbAggroMedium(15))
                .foregroundStyle(Color.welpTextPrimary)
                .tint(Color.welpTextAccent)
                .focused($focused)
                .submitLabel(.send)
                .onSubmit(onSubmit)
                .onChange(of: text) { _, _ in onTextChange() }

            Button(action: onSubmit) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? Color.welpBgTrack
                            : Color.welpTextAccent
                    )
            }
            .buttonStyle(.plain)
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .animation(.easeOut(duration: 0.15), value: text.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.welpBgCardAlt)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
