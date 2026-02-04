import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(SlowMeTheme.textPrimary)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(SlowMeTheme.primaryButton.opacity(configuration.isPressed ? 0.9 : 0.8))
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(SlowMeTheme.brown.opacity(0.7), lineWidth: 4)
            )

    }
}
