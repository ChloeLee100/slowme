import Foundation

final class ReflectionEngine {

    static func generate(answers: [AnswerEntry], reflectionSunday: Date) -> ReflectionResult {
        let cal = Calendar.current
        let end = reflectionSunday.endOfDay()
        let start = cal.date(byAdding: .day, value: -13, to: reflectionSunday.startOfDay())!

        let window = answers.filter { $0.date >= start && $0.date <= end }

        let totalAnswers = window.count

        // Under 5 questions -> show the simple message
        if totalAnswers < 5 {
            let lines = [
                "You’re starting to build a picture of what feels right for you.",
                "Right now the pattern is still forming, which is completely normal early on.",
                "Over the next week, answer consistently and see which kinds of days make you feel most settled.",
                "When you’re ready, come back here and your reflection will become more specific."
            ]

            return ReflectionResult(
                title: "Based on your answers over the past two weeks…",
                bodyLines: lines,
                generatedForSunday: reflectionSunday
            )
        }

        let poleObserved = window.filter {
            $0.questionKind == .observed &&
            poleDimensions.contains($0.dimensionId ?? "") &&
            ($0.selectedPole == "A" || $0.selectedPole == "B")
        }

        var counts: [String: (a: Int, b: Int)] = [:]
        for e in poleObserved {
            guard let dim = e.dimensionId, let pole = e.selectedPole else { continue }
            var c = counts[dim] ?? (0, 0)
            if pole == "A" { c.a += 1 }
            if pole == "B" { c.b += 1 }
            counts[dim] = c
        }

        let ranked = counts
            .map { (dim: $0.key,
                    a: $0.value.a,
                    b: $0.value.b,
                    total: $0.value.a + $0.value.b,
                    margin: abs($0.value.a - $0.value.b)) }
            .filter { $0.total >= 1 }
            .sorted {
                if $0.margin != $1.margin { return $0.margin > $1.margin }
                return $0.total > $1.total
            }

        var lines: [String] = []
        lines.append("You answered \(totalAnswers) questions, which gives a helpful snapshot of your patterns.")

        let topDims = Array(ranked.prefix(2))

        if topDims.isEmpty {
            lines.append("Your recent answers show you’re checking in consistently, even if the theme-based signals are still emerging.")
            lines.append("As you keep answering, patterns will become clearer.")
            let closing = closingPrompts(for: nil).randomElement()
                ?? "Over the next week, stay curious about how small choices shape how your days feel."
            lines.append(closing)
        } else {
            for item in topDims {
                let observedPole = (item.a >= item.b) ? "A" : "B"
                guard let observedText = poleText(observedPole, dim: item.dim) else { continue }

                let confidence = confidencePhrase(total: item.total, margin: item.margin)

                lines.append("From the signals so far, you \(confidence) toward **\"\(observedText)\"** in your recent choices.")
            }

            if let top = ranked.first {
                let dominance = Double(top.margin) / Double(max(top.total, 1))
                if top.total <= 2 {
                    lines.append("It’s still early, so treat this as a starting point rather than a fixed label.")
                } else if dominance >= 0.6 {
                    lines.append("Overall, this fortnight showed a fairly clear preference in one direction, which can be a useful anchor for planning your week.")
                } else {
                    lines.append("Overall, your choices were more balanced this fortnight, which can mean you’re adapting to context rather than sticking to one style.")
                }

                let closing = closingPrompts(for: top.dim).randomElement()
                    ?? "Over the next week, stay curious about how small choices shape how your days feel."
                lines.append(closing)
            } else {
                lines.append("Overall, your choices were mixed this fortnight, which is normal — patterns usually become clearer over time.")
                lines.append(closingPrompts(for: nil).randomElement()
                             ?? "Over the next week, stay curious about how small choices shape how your days feel.")
            }
        }

        if lines.count > 5 { lines = Array(lines.prefix(5)) }
        while lines.count < 4 {
            lines.append("Keep going — the more you check in, the more personal and detailed this reflection becomes.")
        }

        return ReflectionResult(
            title: "Based on your answers over the past two weeks…",
            bodyLines: lines,
            generatedForSunday: reflectionSunday
        )
    }

    private static let poleDimensions: Set<String> = [
        "novelty", "social", "pace", "planning", "energy"
    ]

    private static func poleText(_ pole: String, dim: String) -> String? {
        switch dim {
        case "novelty":   return (pole == "A") ? "familiar" : "new"
        case "social":    return (pole == "A") ? "alone" : "together"
        case "pace":      return (pole == "A") ? "slow" : "fast"
        case "planning":  return (pole == "A") ? "planned" : "spontaneous"
        case "energy":    return (pole == "A") ? "calm" : "stimulated"
        default:          return nil
        }
    }

    private static func confidencePhrase(total: Int, margin: Int) -> String {
        if total <= 1 { return "may have leaned" }
        if total == 2 && margin == 0 { return "showed an even split" }
        if total == 2 { return "seemed to lean" }
        let ratio = Double(margin) / Double(max(total, 1))
        if ratio >= 0.6 { return "often leaned" }
        if ratio >= 0.3 { return "tended to lean" }
        return "slightly leaned"
    }

    private static func closingPrompts(for dominantDim: String?) -> [String] {
        switch dominantDim {
        case "novelty":
            return [
                "Next week, try balancing what feels familiar with one small new experience, and notice how it affects your mood.",
                "Over the next few days, pay attention to when familiarity feels comforting and when novelty feels energising."
            ]
        case "social":
            return [
                "Next week, notice which moments feel best alone versus together, and what that helps you recharge for.",
                "Over the next few days, try one small social plan and one quiet reset, then compare how you feel afterwards."
            ]
        case "pace":
            return [
                "Next week, notice when slowing down feels supportive, and when a quicker pace helps you feel engaged.",
                "Over the next few days, try adjusting your pace once or twice and see how your energy responds."
            ]
        case "planning":
            return [
                "Next week, notice when planning helps you feel steady, and when spontaneity helps you feel refreshed.",
                "Over the next few days, try one planned day and one more flexible day, then notice what worked best."
            ]
        case "energy":
            return [
                "Next week, notice what leaves you feeling calm versus stimulated, and how that shows up in your choices.",
                "Over the next few days, try protecting one calmer moment each day and see what changes."
            ]
        default:
            return [
                "Next week, try repeating one choice that felt good, and gently changing one that didn’t, then notice what shifts.",
                "Over the next few days, stay curious about how small choices shape how your days feel."
            ]
        }
    }
}
