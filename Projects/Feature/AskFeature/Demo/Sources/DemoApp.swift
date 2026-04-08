import AskDomain
import AskFeature
import AskFeatureTesting
import SwiftUI

@main
struct AskFeatureDemoApp: App {
  var body: some Scene {
    WindowGroup {
      AskView(viewModel: viewModel)
        .preferredColorScheme(.dark)
    }
  }

  @State private var viewModel = AskViewModel(
    fetchModesUseCase: FetchModesUseCase(repository: MockAskRepository()),
    askUseCase: MockAskUseCase(),
  )
}
