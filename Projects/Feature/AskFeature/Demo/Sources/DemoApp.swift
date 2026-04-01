import AskFeature
import SwiftUI

@main
struct AskFeatureDemoApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack(path: $router.path) {
        AskView()
          .preferredColorScheme(.dark)
          .navigationDestination(for: Route.self, destination: { route in
            switch route {
            case .modeSelect(let content):
              ModeSelectorView()
                .navigationTransition(.zoom(sourceID: "modeBackground", in: content))
            }
          })
      }
      .environment(router)
    }
  }

  @State private var router = AskRouter()

}
