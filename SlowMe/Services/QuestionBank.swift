import Foundation

final class QuestionBank {
    static let shared = QuestionBank()
    private init() {}

    func loadQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Question].self, from: data)
        } catch {
            return []
        }
    }
}
