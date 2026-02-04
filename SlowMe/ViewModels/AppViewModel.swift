import SwiftUI
import Combine
import Foundation

@MainActor
final class AppViewModel: ObservableObject {

    @Published private(set) var questions: [Question] = []
    @Published private(set) var answers: [AnswerEntry] = []
    @Published var path = NavigationPath()

    init() {
        questions = QuestionBank.shared.loadQuestions()
        answers = LocalStore.shared.loadAnswers().sorted { $0.date < $1.date }
    }
    
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        if !path.isEmpty { path.removeLast() }
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func goToJourneyFromAnywhere() {
        popToRoot()
        push(.journey)
    }

    var nextQuestion: Question? {
        guard !hasAnsweredToday() else { return nil }
        
        let idx = answers.count
        guard idx < questions.count else { return nil }
        return questions[idx]
    }

    func hasAnsweredToday() -> Bool { hasAnswered(on: Date()) }

    func hasAnswered(on date: Date) -> Bool {
        let cal = Calendar.current
        return answers.contains { cal.isDate($0.date, inSameDayAs: date) }
    }

    var canAnswerToday: Bool {
        nextQuestion != nil && !hasAnsweredToday()
    }

    func submitAnswer(option: QuestionOption?, otherText: String?) {
        guard let q = nextQuestion else { return }
        guard !hasAnsweredToday() else { return }

        let isOther = (option == nil)
        let finalText = isOther ? (otherText ?? "").trimmed() : (option?.text ?? "").trimmed()
        guard !finalText.isEmpty else { return }

        let entry = AnswerEntry(
            id: UUID().uuidString,
            date: Date(),
            questionId: q.id,
            questionPrompt: q.prompt,
            questionKind: q.kind,
            dimensionId: q.dimensionId,
            selectedOptionId: option?.id,
            selectedPole: option?.pole,
            answerText: finalText,
            isOther: isOther
        )

        answers.append(entry)
        answers.sort { $0.date < $1.date }
        LocalStore.shared.saveAnswers(answers)
    }

    // Journey helpers
    func entries(in week: WeekRange) -> [AnswerEntry] {
        answers
            .filter { $0.date >= week.start && $0.date < week.end }
            .sorted { $0.date > $1.date }
    }

    func answeredDays(in weekStart: Date) -> Set<Date> {
        let week = WeekRange(
            start: weekStart,
            end: Calendar.current.date(byAdding: .day, value: 7, to: weekStart)!
        )
        let cal = Calendar.current
        let entries = answers.filter { $0.date >= week.start && $0.date < week.end }
        let days = entries.map { cal.startOfDay(for: $0.date) }
        return Set(days)
    }

    // Reflection available on Sunday fortnightly (end of week)
    func isReflectionAvailable(forWeekStart weekStart: Date) -> Bool {
        let currentWeekStart = CalendarHelpers.startOfWeekMonday(for: Date())
        guard weekStart <= currentWeekStart else { return false }
        guard let firstAnswerDate = answers.first?.date else { return false }

        let firstWeekStart = CalendarHelpers.startOfWeekMonday(for: firstAnswerDate)
        let weeksBetween = CalendarHelpers.weeksBetween(from: firstWeekStart, to: weekStart)

        let isFortnightWeek = (weeksBetween % 2 == 1)
        guard isFortnightWeek else { return false }

        let sunday = CalendarHelpers.sundayOfWeek(startingMonday: weekStart)
        return sunday <= Date()
    }

    func reflectionSunday(forWeekStart weekStart: Date) -> Date {
        CalendarHelpers.sundayOfWeek(startingMonday: weekStart)
    }
}

enum Route: Hashable {
    case checkIn
    case confirmation
    case journey
    case reflection(Date)
}

//#if DEBUG
//extension AppViewModel {
//
//    func debugSeedAnswersForLastDays(_ days: Int = 14) {
//        guard !questions.isEmpty else { return }
//
//        let cal = Calendar.current
//        let todayStart = cal.startOfDay(for: Date())
//
//        var newAnswers = answers
//
//        for offset in stride(from: days - 1, through: 0, by: -1) {
//            guard let day = cal.date(byAdding: .day, value: -offset, to: todayStart) else { continue }
//            if hasAnswered(on: day) { continue }
//
//            // Choose a question index based on how many answers already exist (keeps it simple)
//            let qIndex = min(newAnswers.count, questions.count - 1)
//            let q = questions[qIndex]
//
//            // Pick a deterministic option, or fallback to "Other"
//            let chosenOption = q.options.first
//            let isOther = (chosenOption == nil)
//            let answerText = isOther ? "Debug seeded answer" : (chosenOption!.text)
//
//            let entry = AnswerEntry(
//                id: UUID().uuidString,
//                date: day,
//                questionId: q.id,
//                questionPrompt: q.prompt,
//                questionKind: q.kind,
//                dimensionId: q.dimensionId,
//                selectedOptionId: chosenOption?.id,
//                selectedPole: chosenOption?.pole,
//                answerText: answerText,
//                isOther: isOther
//            )
//
//            newAnswers.append(entry)
//        }
//
//        newAnswers.sort { $0.date < $1.date }
//        answers = newAnswers
//        LocalStore.shared.saveAnswers(answers)
//    }
//
//    func debugClearAllAnswers() {
//        answers = []
//        LocalStore.shared.saveAnswers([])
//    }
//}
//#endif
