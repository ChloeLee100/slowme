import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(SlowMeTheme.textPrimary)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(SlowMeTheme.white.opacity(configuration.isPressed ? 0.92 : 1.0))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(SlowMeTheme.brown.opacity(0.7), lineWidth: 4)
            )
    }
}
