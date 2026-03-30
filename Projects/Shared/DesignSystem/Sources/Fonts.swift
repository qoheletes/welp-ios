import SwiftUI

// PostScript names extracted from the OTF files:
//   OTSBAggroB  (Bold)
//   OTSBAggroM  (Medium)
//   OTSBAggroL  (Light)
//
// Font files are bundled in App/Resources/Fonts/ and registered via
// UIAppFonts in the App target's Info.plist.
public extension Font {
    static func sbAggroBold(_ size: CGFloat) -> Font {
        .custom("OTSBAggroB", size: size, relativeTo: .headline)
    }

    static func sbAggroMedium(_ size: CGFloat) -> Font {
        .custom("OTSBAggroM", size: size, relativeTo: .body)
    }

    static func sbAggroLight(_ size: CGFloat) -> Font {
        .custom("OTSBAggroL", size: size, relativeTo: .body)
    }
}
