import SwiftUI

// MARK: - ModeSelectorView

public struct ModeSelectorView: View {

  // MARK: Lifecycle

  public init(viewModel: AskViewModel) {
    self.viewModel = viewModel
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: .top) {
      Color.welpBg.ignoresSafeArea()
      // Paged full-screen carousel
      TabView(selection: $currentIndex) {
        ForEach(viewModel.modes.indices, id: \.self) { index in
          ModeFullCard(
            mode: viewModel.modes[index],
            isSelected: viewModel.selectedMode.id == viewModel.modes[index].id,
            onSelect: { selectAndDismiss(viewModel.modes[index]) },
          )
          .tag(index)
        }
      }
      .tabViewStyle(.page(indexDisplayMode: .never))
      .ignoresSafeArea()

      // Fixed overlay: header + subtitle + page dots
      VStack(spacing: 0) {
        header
          .opacity(contentVisible ? 1 : 0)
          .offset(y: contentVisible ? 0 : -20)

        Text("Each mode shapes how the answer is framed.")
          .font(.sbAggroLight(13))
          .foregroundStyle(Color.welpTextMuted)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 24)
          .padding(.top, 8)
          .opacity(contentVisible ? 1 : 0)

        Spacer()

        modeIndicator
          .padding(.bottom, 40)
          .opacity(contentVisible ? 1 : 0)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      currentIndex = viewModel.modes.firstIndex(where: { $0.id == viewModel.selectedMode.id }) ?? 0
      withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
        contentVisible = true
      }
    }
  }

  // MARK: Private

  @State private var currentIndex = 0
  @State private var contentVisible = false
  @Environment(\.dismiss) private var dismiss

  private let viewModel: AskViewModel

  private var header: some View {
    ZStack {
      Text("Choose a Mode")
        .font(.sbAggroBold(20))
        .foregroundStyle(Color.welpTextPrimary)
        .kerning(-0.3)

      HStack {
        Spacer()
        Button {
          dismiss()
        } label: {
          Text("\u{2715}")
            .font(.sbAggroMedium(14))
            .foregroundStyle(Color.welpTextMuted)
            .frame(width: 32, height: 32)
            .background(Color.welpBgCardAlt)
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
      }
    }
    .padding(.horizontal, 24)
    .padding(.top, 16)
  }

  private var modeIndicator: some View {
    HStack(spacing: 8) {
      ForEach(viewModel.modes.indices, id: \.self) { i in
        Capsule()
          .fill(i == currentIndex ? viewModel.modes[i].accentColor : Color.welpBgTrack)
          .frame(width: i == currentIndex ? 20 : 6, height: 6)
          .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
      }
    }
  }

  private func selectAndDismiss(_ mode: Mode) {
    viewModel.selectedMode = mode
    dismiss()
  }
}

// MARK: - ModeFullCard

private struct ModeFullCard: View {

  let mode: Mode
  let isSelected: Bool
  let onSelect: () -> Void

  var body: some View {
    ZStack {
      Color.welpBg.ignoresSafeArea()
      mode.accentColor.opacity(0.06).ignoresSafeArea()

      VStack(spacing: 0) {
        Spacer()

        Circle()
          .fill(mode.accentColor)
          .frame(width: 14, height: 14)
          .padding(.bottom, 20)

        Text(mode.name)
          .font(.sbAggroBold(64))
          .foregroundStyle(mode.accentColor)
          .kerning(-1.5)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 24)

        Text(mode.description)
          .font(.sbAggroMedium(17))
          .foregroundStyle(Color.welpTextSpoken)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 40)
          .padding(.top, 16)

        Text("\"\(mode.tone)\"")
          .font(.sbAggroLight(14))
          .italic()
          .foregroundStyle(Color.welpTextMuted)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
          .background(Color.welpBgCardAlt)
          .clipShape(RoundedRectangle(cornerRadius: 14))
          .padding(.horizontal, 40)
          .padding(.top, 20)

        Spacer()

        Button(action: onSelect) {
          Text(isSelected ? "Active" : "Select")
            .font(.sbAggroMedium(15))
            .foregroundStyle(isSelected ? Color.welpBg : mode.accentColor)
            .padding(.horizontal, 36)
            .padding(.vertical, 14)
            .background(isSelected ? mode.accentColor : mode.accentColor.opacity(0.12))
            .liquidGlassIfAvailable()
        }
        .buttonStyle(.plain)
        .padding(.bottom, 100)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
//  ModeSelectorView()
}
