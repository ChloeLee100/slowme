import SwiftUI

struct WeekEntryCardView: View {
    let entry: AnswerEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(entry.date.homeDateString())
                .font(AppFonts.gamja(.title2))
                .bold()
                .foregroundStyle(SlowMeTheme.textPrimary)

            Text(entry.questionPrompt)
                .font(AppFonts.gamja(.body))
                .foregroundStyle(SlowMeTheme.textPrimary.opacity(0.9))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(entry.answerText)
                .font(AppFonts.gamja(.body))
                .foregroundStyle(SlowMeTheme.textPrimary)
                .bold()
                .lineLimit(1)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SlowMeTheme.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(SlowMeTheme.textPrimary.opacity(0.12), lineWidth: 1)
        )
    }
}
