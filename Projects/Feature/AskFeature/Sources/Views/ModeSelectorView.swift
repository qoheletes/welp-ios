import SwiftUI
import ThirdPartyLibrary

// MARK: - ModeSelectorView

public struct ModeSelectorView: View {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  public var body: some View {
    ZStack {
      Color.welpBg
        .ignoresSafeArea()

      VStack(spacing: 0) {
        // Header
        header
          .opacity(contentVisible ? 1 : 0)
          .offset(y: contentVisible ? 0 : -20)

        // Subtitle
        Text("Each mode shapes how the answer is framed.")
          .font(.sbAggroLight(13))
          .foregroundStyle(Color.welpTextMuted)
          .multilineTextAlignment(.center)
          .padding(.horizontal, 24)
          .padding(.top, 8)
          .padding(.bottom, 28)
          .opacity(contentVisible ? 1 : 0)

        // Mode cards — vertical list
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 14) {
            ForEach(Array(allModes.enumerated()), id: \.element.id) { index, mode in
              ModeCard(
                mode: mode,
                isSelected: router.selectedMode.id == mode.id,
              ) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                  router.selectedMode = mode
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                  dismissSelector()
                }
              }
              .opacity(contentVisible ? 1 : 0)
              .offset(y: contentVisible ? 0 : 40)
              .animation(
                .spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.06),
                value: contentVisible,
              )
            }
          }
          .padding(.horizontal, 24)
        }

        Spacer(minLength: 0)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .preferredColorScheme(.dark)
    .onAppear {
      withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
        contentVisible = true
      }
    }
  }

  // MARK: Private

  @State private var contentVisible = false
  @Environment(AskRouter.self) private var router

  private var header: some View {
    ZStack {
      Text("Choose a Mode")
        .font(.sbAggroBold(20))
        .foregroundStyle(Color.welpTextPrimary)
        .kerning(-0.3)

      HStack {
        Spacer()
        Button {
          dismissSelector()
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

  private func dismissSelector() {
    withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
      contentVisible = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      router.pop()
    }
  }
}

// MARK: - ModeCard

private struct ModeCard: View {
  let mode: Mode
  let isSelected: Bool
  let onSelect: () -> Void

  var body: some View {
    Button(action: onSelect) {
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Circle()
            .fill(mode.accentColor)
            .frame(width: 10, height: 10)

          Spacer()

          if isSelected {
            Text("Active")
              .font(.sbAggroMedium(11))
              .foregroundStyle(Color.welpTextPrimary)
              .kerning(0.3)
              .padding(.horizontal, 10)
              .padding(.vertical, 4)
              .background(mode.accentColor)
              .clipShape(Capsule())
          }
        }

        Text(mode.name)
          .font(.sbAggroBold(28))
          .foregroundStyle(mode.accentColor)
          .kerning(-0.8)

        Text(mode.description)
          .font(.sbAggroMedium(15))
          .foregroundStyle(Color.welpTextSpoken)

        Text("\"\(mode.tone)\"")
          .font(.sbAggroLight(13))
          .italic()
          .foregroundStyle(Color.welpTextSpoken)
          .padding(.horizontal, 14)
          .padding(.vertical, 10)
          .background(Color.welpBgTrack)
          .clipShape(RoundedRectangle(cornerRadius: 12))
          .padding(.top, 4)
      }
      .padding(24)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        isSelected
          ? mode.accentColor.opacity(0.1)
          : Color.welpBgCardAlt
      )
      .clipShape(RoundedRectangle(cornerRadius: 24))
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .strokeBorder(
            mode.accentColor.opacity(isSelected ? 1.0 : 0.26),
            lineWidth: 2,
          )
      )
    }
    .buttonStyle(.plain)
  }
}
