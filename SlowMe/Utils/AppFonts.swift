import SwiftUI

enum AppFonts {
    static func gamja(_ style: Font.TextStyle) -> Font {
        switch style {
        case .largeTitle: return .custom("Gamja Flower", size: 32)
        case .title:      return .custom("Gamja Flower", size: 28)
        case .title2:     return .custom("Gamja Flower", size: 24)
        case .title3:     return .custom("Gamja Flower", size: 22)
        case .body:       return .custom("Gamja Flower", size: 20)
        case .callout:    return .custom("Gamja Flower", size: 17)
        case .subheadline:return .custom("Gamja Flower", size: 16)
        case .footnote:   return .custom("Gamja Flower", size: 14)
        case .caption:    return .custom("Gamja Flower", size: 13)
        case .caption2:   return .custom("Gamja Flower", size: 12)
        default:          return .custom("Gamja Flower", size: 18)
        }
    }
}
