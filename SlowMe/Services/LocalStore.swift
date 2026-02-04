import Foundation

final class LocalStore {
    static let shared = LocalStore()
    private init() {}

    private let answersFileName = "answers.json"

    private var answersURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(answersFileName)
    }

    func loadAnswers() -> [AnswerEntry] {
        do {
            let data = try Data(contentsOf: answersURL)
            return try JSONDecoder.isoDates.decode([AnswerEntry].self, from: data)
        } catch {
            return []
        }
    }

    func saveAnswers(_ answers: [AnswerEntry]) {
        do {
            let data = try JSONEncoder.isoDates.encode(answers)
            try data.write(to: answersURL, options: [.atomic])
        } catch {
            
        }
    }
}

private extension JSONEncoder {
    static var isoDates: JSONEncoder {
        let enc = JSONEncoder()
        enc.outputFormatting = [.prettyPrinted]
        enc.dateEncodingStrategy = .iso8601
        return enc
    }
}

private extension JSONDecoder {
    static var isoDates: JSONDecoder {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }
}
