import Foundation

struct AnswerEntry: Identifiable, Codable, Hashable {
    let id: String
    let date: Date

    let questionId: String
    let questionPrompt: String
    let questionKind: QuestionKind
    let dimensionId: String?

    let selectedOptionId: String?
    let selectedPole: String?
    let answerText: String
    let isOther: Bool
}
