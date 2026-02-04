import SwiftUI

enum SlowMeTheme {
    static let green = Color(hex: "A4B465")
    static let yellow = Color(hex: "FEC868")
    static let brown = Color(hex: "473C33")
    static let white = Color(hex: "FEFAE0")

    static let screenBackground = green
    static let primaryButton = yellow
    static let textPrimary = brown
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: 1)
    }
}
