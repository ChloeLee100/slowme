import Foundation

enum QuestionKind: String, Codable {
    case observed   // what you choose / do
    case claim      // what you say about yourself
}

struct QuestionOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let pole: String? // "A" or "B" for reflection; nil means neutral
}

struct Question: Identifiable, Codable, Hashable {
    let id: String
    let prompt: String
    let options: [QuestionOption]
    let allowsOther: Bool
    let kind: QuestionKind
    let dimensionId: String? // e.g., "novelty", "social", etc.
}
