import SwiftUI

// MARK: - AskView

public struct AskView: View {

  // MARK: Lifecycle

  public init(viewModel: AskViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Public

  public var body: some View {
    @Bindable var viewModel = viewModel

    ZStack {
      Color.welpBg.ignoresSafeArea()

      // Input + actions at bottom
      VStack {
        modeSelectorButton

        Spacer()

        TypingTextView()

        Spacer()

        QuestionInputView(
          text: $inputText,
          onSubmit: { viewModel.ask(question: inputText) },
          onTextChange: { if errorMessage != nil { errorMessage = nil } },
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .task { viewModel.fetchModes() }
    .sheet(isPresented: $showModeSelector) {
      ModeSelectorView(viewModel: viewModel)
    }
    .fullScreenCover(item: $viewModel.responseViewModel) { vm in
      ResponseView(viewModel: vm)
    }
  }

  // MARK: Private

  @State private var inputText = ""
  @State private var errorMessage: String? = nil
  @State private var showModeSelector = false

  private let viewModel: AskViewModel

  private var modeSelectorButton: some View {
    HStack(spacing: 6) {
      Circle()
        .fill(viewModel.selectedMode.accentColor)
        .frame(width: 7, height: 7)
      Text(viewModel.selectedMode.name)
        .font(.sbAggroMedium(13))
        .foregroundStyle(viewModel.selectedMode.accentColor)
      Image(systemName: "chevron.down")
        .font(.system(size: 10, weight: .semibold))
        .foregroundStyle(viewModel.selectedMode.accentColor)
    }
    .padding(.horizontal, 14)
    .padding(.vertical, 8)
    .liquidGlassIfAvailable()
    .onTapGesture {
      showModeSelector = true
    }
  }

}

// MARK: - QuestionInputView

private struct QuestionInputView: View {

  // MARK: Internal

  @Binding var text: String

  let onSubmit: () -> Void
  let onTextChange: () -> Void

  var body: some View {
    VStack(spacing: 10) {
      TextField("", text: $text, prompt: Text("Ask anything...").foregroundColor(Color.welpTextMuted), axis: .vertical)
        .lineLimit(6)
        .font(.sbAggroMedium(15))
        .foregroundStyle(Color.welpTextPrimary)
        .tint(Color.welpTextAccent)
        .focused($focused)
        .submitLabel(.send)
        .onSubmit(onSubmit)
        .onChange(of: text) { _, _ in onTextChange() }

      HStack {
        Spacer()
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
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 14)
    .background(Color.welpBgCardAlt)
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }

  // MARK: Private

  @FocusState private var focused: Bool

}
