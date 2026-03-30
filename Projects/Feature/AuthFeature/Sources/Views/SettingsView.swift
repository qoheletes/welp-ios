import SwiftUI
import Shared

public struct SettingsView: View {
    @State private var appeared = false

    public init() {}

    public var body: some View {
        ZStack {
            Color.welpBg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    Text("Settings")
                        .font(.sbAggroBold(32))
                        .foregroundStyle(Color.welpTextPrimary)
                        .kerning(-1)

                    SettingsSection(title: "App") {
                        SettingsRow(
                            icon: "arrow.counterclockwise",
                            label: "Reset Onboarding",
                            tint: Color.welpTextAccent
                        ) {
                            resetOnboarding()
                        }
                    }

                    SettingsSection(title: "About") {
                        SettingsInfoRow(label: "Version", value: "1.0.0")
                        SettingsInfoRow(label: "App", value: "wtd?")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) { appeared = true }
        }
    }
}

// MARK: - SettingsSection

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.sbAggroMedium(12))
                .foregroundStyle(Color.welpTextMuted)
                .textCase(.uppercase)
                .kerning(0.6)
                .padding(.bottom, 10)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.welpBgCardAlt)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - SettingsRow

private struct SettingsRow: View {
    let icon: String
    let label: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(tint)
                    .frame(width: 28)

                Text(label)
                    .font(.sbAggroMedium(15))
                    .foregroundStyle(Color.welpTextPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.welpTextMuted)
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - SettingsInfoRow

private struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.sbAggroMedium(15))
                .foregroundStyle(Color.welpTextPrimary)
            Spacer()
            Text(value)
                .font(.sbAggroLight(15))
                .foregroundStyle(Color.welpTextMuted)
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
    }
}
