import SwiftUI
import Shared

struct ModeSelectorView: View {
    @Binding var selectedMode: Mode
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.welpBg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                ZStack {
                    Text("Choose a Mode")
                        .font(.sbAggroBold(20))
                        .foregroundStyle(Color.welpTextPrimary)
                        .kerning(-0.3)

                    HStack {
                        Spacer()
                        Button {
                            isPresented = false
                        } label: {
                            Text("✕")
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
                .padding(.top, 24)

                Text("Each mode shapes how the answer is framed.")
                    .font(.sbAggroLight(13))
                    .foregroundStyle(Color.welpTextMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 32)

                // Mode cards — horizontally scrollable
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(allModes) { mode in
                            ModeCard(
                                mode: mode,
                                isSelected: selectedMode.id == mode.id
                            ) {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                    selectedMode = mode
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    isPresented = false
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - ModeCard

private struct ModeCard: View {
    let mode: Mode
    let isSelected: Bool
    let onSelect: () -> Void

    private let cardWidth = UIScreen.main.bounds.width * 0.72

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 10) {
                Circle()
                    .fill(mode.accentColor)
                    .frame(width: 10, height: 10)

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
                    .padding(.top, 12)
            }
            .padding(28)
            .frame(width: cardWidth, alignment: .leading)
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
                        lineWidth: 2
                    )
            )
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Text("Active")
                        .font(.sbAggroMedium(11))
                        .foregroundStyle(Color.welpTextPrimary)
                        .kerning(0.3)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(mode.accentColor)
                        .clipShape(Capsule())
                        .padding(20)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
