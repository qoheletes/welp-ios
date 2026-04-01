import SwiftUI
import ThirdPartyLibrary

// MARK: - AskView

public struct AskView: View {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public var body: some View {
    ZStack {
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
      Text(activeQuestion)
        .font(.sbAggroMedium(16))
        .foregroundStyle(Color.welpTextPrimary)
        .lineSpacing(8)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.welpBgCardAlt)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.horizontal, 24)
        .padding(.top, 72)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(questionOpacity)
        .offset(y: questionOffset)
        .allowsHitTesting(false)

      // Input + actions at bottom
      VStack {
        Spacer()

        QuestionInputView(
          text: $inputText,
//            onSubmit: handleSubmit,
          onTextChange: { if errorMessage != nil { errorMessage = nil } },
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .preferredColorScheme(.dark)
  }

  // MARK: Private

  @Namespace private var heroNamespace

  @State private var inputText = ""
  @State private var activeQuestion = ""
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

  @Environment(AskRouter.self) private var router

  private var modeSelectorButton: some View {
    Button {
      router.navigate(to: .modeSelect(namespace: heroNamespace))
    } label: {
      HStack(spacing: 6) {
        Circle()
          .fill(router.selectedMode.accentColor)
          .frame(width: 7, height: 7)
        Text(router.selectedMode.name)
          .font(.sbAggroMedium(13))
          .foregroundStyle(router.selectedMode.accentColor)
          .kerning(0.3)
        Image(systemName: "chevron.down")
          .font(.system(size: 10, weight: .semibold))
          .foregroundStyle(router.selectedMode.accentColor)
      }
      .matchedTransitionSource(id: "modeBackground", in: heroNamespace)
//      .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedMode.id)
    }
    .glassButtonStyleIfAvailable()
    .scaleEffect(modeButtonScale)
    .frame(maxWidth: .infinity)
    .padding(.top, 16)
//    .matchedTransitionSource(id: "modeBackground", in: heroNamespace)
  }

}

// MARK: - QuestionInputView

private struct QuestionInputView: View {

  // MARK: Internal

  @Binding var text: String

  ///  let onSubmit: () -> Void
  let onTextChange: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      TextField("", text: $text, prompt: Text("Ask anything...").foregroundColor(Color.welpTextMuted))
        .font(.sbAggroMedium(15))
        .foregroundStyle(Color.welpTextPrimary)
        .tint(Color.welpTextAccent)
        .focused($focused)
        .submitLabel(.send)
//        .onSubmit(onSubmit)
        .onChange(of: text) { _, _ in onTextChange() }

//      Button(action: onSubmit) {
//        Image(systemName: "arrow.up.circle.fill")
//          .font(.system(size: 32))
//          .foregroundStyle(
//            text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
//              ? Color.welpBgTrack
//              : Color.welpTextAccent
//          )
//      }
//      .buttonStyle(.plain)
//      .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
//      .animation(.easeOut(duration: 0.15), value: text.isEmpty)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(Color.welpBgCardAlt)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }

  // MARK: Private

  @FocusState private var focused: Bool

}

//
// #Preview {
//  AskView()
// }
