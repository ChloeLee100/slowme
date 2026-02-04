import Foundation

enum DateFormatters {
    static let homeDate: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_AU")
        df.dateFormat = "EEE. d MMM" // Wed. 28 Jan
        return df
    }()

    static let shortDayMonth: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_AU")
        df.dateFormat = "d MMM"
        return df
    }()
}

extension Date {
    func homeDateString() -> String { DateFormatters.homeDate.string(from: self) }
    func shortDayMonthString() -> String { DateFormatters.shortDayMonth.string(from: self) }

    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        let start = Calendar.current.startOfDay(for: self)
        let next = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        return next.addingTimeInterval(-1)
    }
}

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
