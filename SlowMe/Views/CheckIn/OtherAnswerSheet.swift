import SwiftUI

struct OtherAnswerSheet: View {
    let prompt: String
    let onSubmit: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""

    var body: some View {
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()

            ContentContainer {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Others?")
                        .font(AppFonts.gamja(.title))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                        .padding(.top, 20)
                    
                    Rectangle()
                        .fill(SlowMeTheme.textPrimary.opacity(0.35))
                        .frame(height: 2)
                        .padding(.vertical, -10)

                    Text(prompt)
                        .font(AppFonts.gamja(.title2))
                        .foregroundStyle(SlowMeTheme.textPrimary.opacity(0.85))

                    TextField("Type your answer…", text: $text)
                        .font(AppFonts.gamja(.body))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.9))
                        )
                        .frame(height: 70)
                        .padding(.vertical, 6)

                    Button {
                        let final = text.trimmed()
                        guard !final.isEmpty else { return }
                        onSubmit(final)
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(AppFonts.gamja(.body))
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .frame(width: 130, height: 15)
                    .padding(.vertical, 8)

                    Spacer()
                }
                .padding(.top, 12)
            }
        }
    }
}
