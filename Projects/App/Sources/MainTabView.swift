import AskFeature
import AuthFeature
import FeatureFoundation
import ProfileFeature
import SwiftUI

struct MainTabView: View {

  // MARK: Internal

  var body: some View {
    @Bindable var router = router

    TabView(selection: $router.selectedTab) {
      NavigationStack {
        AskView(viewModel: router.askViewModel)
      }
      .tag(Tab.ask)
      .tabItem {
        Label("Ask", systemImage: "bubble.left.fill")
      }

      NavigationStack(path: $router.profileRouter.path) {
        Text("Profile")
          .navigationDestination(for: ProfileRouter.Destination.self) { _ in
            EmptyView()
          }
      }
      .tag(Tab.profile)
      .tabItem {
        Label("Profile", systemImage: "person.fill")
      }

      NavigationStack(path: $router.settingsRouter.path) {
        SettingsModule.makeView()
          .navigationDestination(for: SettingsRouter.Destination.self) { _ in
            EmptyView()
          }
      }
      .tag(Tab.settings)
      .tabItem {
        Label("Settings", systemImage: "gearshape.fill")
      }
    }
    .preferredColorScheme(.dark)
  }

  // MARK: Private

  @Environment(AppRouter.self) private var router

}
