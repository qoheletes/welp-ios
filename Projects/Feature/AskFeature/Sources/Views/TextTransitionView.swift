import SwiftUI
import Shared

// MARK: - TextTransitionView

public struct TextTransitionView: View {

    // MARK: - ViewModel

    @State private var viewModel = TextTransitionViewModel()

    // MARK: - Namespace

    @Namespace private var namespace

    // MARK: - Init

    public init() {}

    // MARK: - Body

    public var body: some View {
        ZStack {
            Color.welpBg.ignoresSafeArea()

            if viewModel.isSubmitted {
                resultState
                    .transition(.opacity)
            } else {
                inputState
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Subviews

    /// View 1 — centered text field + "Next" button.
    private var inputState: some View {
        VStack(spacing: 28) {
            Spacer()

            // The shared geometry element: a label above the field that flies to
            // the top when the user submits. It renders the live inputText so the
            // transition carries the actual typed content.
            Text(viewModel.inputText.isEmpty ? "What's on your mind?" : viewModel.inputText)
                .font(.sbAggroMedium(20))
                .foregroundStyle(
                    viewModel.inputText.isEmpty
                        ? Color.welpTextMuted
                        : Color.welpTextPrimary
                )
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 32)
                .matchedGeometryEffect(id: "userText", in: namespace)

            // TextField — separate from the matched element so the live input
            // is captured independently of the flying label.
            TextField(
                "",
                text: Binding(
                    get: { viewModel.inputText },
                    set: { viewModel.updateInputText($0) }
                ),
                prompt: Text("Type something…")
                    .foregroundColor(Color.welpTextMuted)
            )
            .font(.sbAggroLight(17))
            .foregroundStyle(Color.welpTextPrimary)
            .tint(Color.welpTextAccent)
            .multilineTextAlignment(.center)
            .submitLabel(.done)
            .onSubmit { handleNext() }
            .padding(.horizontal, 40)
            .padding(.vertical, 14)
            .background(Color.welpBgCardAlt)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.welpTextAccent.opacity(0.35), lineWidth: 1.5)
            )
            .padding(.horizontal, 24)

            nextButton

            Spacer()
        }
    }

    /// View 2 — submitted text pinned to the top + "Back" button.
    private var resultState: some View {
        VStack(spacing: 0) {
            Text(viewModel.submittedText)
                .font(.sbAggroMedium(20))
                .foregroundStyle(Color.welpTextPrimary)
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 60)
                .matchedGeometryEffect(id: "userText", in: namespace)

            backButton
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
        }
    }

    private var nextButton: some View {
        Button(action: handleNext) {
            Text("Next")
                .font(.sbAggroBold(16))
                .foregroundStyle(
                    viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.welpTextMuted
                        : Color.welpTextAccent
                )
                .kerning(0.2)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.welpBgCardAlt)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? Color.welpBgTrack
                                : Color.welpTextAccent,
                            lineWidth: 2
                        )
                )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .animation(.easeOut(duration: 0.15), value: viewModel.inputText.isEmpty)
        .padding(.horizontal, 24)
        .accessibilityLabel("Next")
        .accessibilityIdentifier("textTransition.nextButton")
    }

    private var backButton: some View {
        Button(action: handleBack) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 14, weight: .semibold))
                Text("Back")
                    .font(.sbAggroMedium(15))
            }
            .foregroundStyle(Color.welpTextSpoken)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.welpBgCardAlt)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
        .accessibilityIdentifier("textTransition.backButton")
    }

    // MARK: - Actions

    private func handleNext() {
        let trimmed = viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
            viewModel.submit()
        }
    }

    private func handleBack() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
            viewModel.reset()
        }
    }
}
