import Foundation

struct WeekRange: Hashable {
    let start: Date
    let end: Date   
}

enum CalendarHelpers {

    static func startOfWeekMonday(for date: Date) -> Date {
        var cal = Calendar.current
        cal.firstWeekday = 2 // Monday
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return cal.date(from: comps)!
    }

    static func weekRange(forMondayStart weekStart: Date) -> WeekRange {
        let end = Calendar.current.date(byAdding: .day, value: 7, to: weekStart)!
        return WeekRange(start: weekStart, end: end)
    }

    static func sundayOfWeek(startingMonday weekStart: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: 6, to: weekStart)!
    }

    static func weeksBetween(from: Date, to: Date) -> Int {
        let comps = Calendar.current.dateComponents([.weekOfYear], from: from, to: to)
        return comps.weekOfYear ?? 0
    }
}
