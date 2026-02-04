import SwiftUI

struct ReflectionCardView: View {
    let line: String

    var body: some View {
        Text(.init(line))
            .foregroundStyle(SlowMeTheme.textPrimary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(SlowMeTheme.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(SlowMeTheme.textPrimary.opacity(0.12), lineWidth: 1))
    }
}
