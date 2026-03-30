import SwiftUI
import Ask
import Onboarding
import Settings
import Shared

@main
struct WelpApp: App {
    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            Group {
                if coordinator.onboardingComplete {
                    MainTabView()
                } else {
                    OnboardingView(onComplete: coordinator.completeOnboarding)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.35), value: coordinator.onboardingComplete)
            .environment(coordinator)
        }
    }
}

// MARK: - MainTabView

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                AskView()
                    .tag(0)

                SettingsView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom tab bar
            OracleTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

// MARK: - OracleTabBar

private struct OracleTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("sparkles", "Ask"),
        ("gearshape", "Settings"),
    ]

    var body: some View {
        GeometryReader { geo in
            let bottom = geo.safeAreaInsets.bottom

            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { i in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedTab = i
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: selectedTab == i ? tabs[i].icon + ".fill" : tabs[i].icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(selectedTab == i ? Color.welpTextAccent : Color.welpTextMuted)
                                .scaleEffect(selectedTab == i ? 1.08 : 1.0)
                                .animation(.spring(response: 0.25, dampingFraction: 0.65), value: selectedTab)

                            Text(tabs[i].label)
                                .font(.sbAggroMedium(10))
                                .foregroundStyle(selectedTab == i ? Color.welpTextAccent : Color.welpTextMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                        .padding(.bottom, bottom + 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(
                Color.welpBgTabBar
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(Color(hex: "#2A2A40"))
                            .frame(height: 1)
                    }
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}
