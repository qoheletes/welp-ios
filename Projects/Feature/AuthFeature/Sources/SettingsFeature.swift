// Public interface for the Settings feature module.
@_exported import SwiftUI

public struct SettingsModule {
    public static func makeView() -> some View {
        SettingsView()
    }
}
