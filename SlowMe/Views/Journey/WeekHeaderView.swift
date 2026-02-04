import SwiftUI

struct WeekHeaderView: View {
    let weekStart: Date
    let answeredDays: Set<Date>
    let canGoPrev: Bool
    let canGoNext: Bool
    let onPrev: () -> Void
    let onNext: () -> Void

    private let dayLabels = ["M","T","W","T","F","S","S"]

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: onPrev) {
                    Text("‹")
                        .font(AppFonts.gamja(.largeTitle))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                }
                .disabled(!canGoPrev)
                .opacity(canGoPrev ? 1 : 0.35)

                Spacer()

                Text(dayLabels.joined(separator: "   "))
                    .font(AppFonts.gamja(.title2))
                    .foregroundStyle(SlowMeTheme.textPrimary)

                Spacer()

                Button(action: onNext) {
                    Text("›")
                        .font(AppFonts.gamja(.largeTitle))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                }
                .disabled(!canGoNext)
                .opacity(canGoNext ? 1 : 0.35)
            }

            HStack(spacing: 20.5) {
                ForEach(0..<7, id: \.self) { visualIndex in
                    let date = dateForVisualIndex(visualIndex)
                    let isAnswered = answeredDays.contains(Calendar.current.startOfDay(for: date))

                    Circle()
                        .fill(isAnswered ? SlowMeTheme.primaryButton : Color.clear)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(SlowMeTheme.textPrimary.opacity(0.25), lineWidth: 1))
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func dateForVisualIndex(_ idx: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: idx, to: weekStart)!
    }
}
