import SwiftUI

struct JourneyView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var weekStart: Date = CalendarHelpers.startOfWeekMonday(for: Date())

    private var currentWeekStart: Date { CalendarHelpers.startOfWeekMonday(for: Date()) }
    private var weekRange: WeekRange { CalendarHelpers.weekRange(forMondayStart: weekStart) }
    private var earliestWeekStart: Date? {
        guard let first = vm.answers.first?.date else { return nil }
        return CalendarHelpers.startOfWeekMonday(for: first)
    }

    private var canGoPrev: Bool {
        guard let earliest = earliestWeekStart else { return false }
        return weekStart > earliest
    }


    var body: some View {
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()

            ContentContainer {
                VStack(spacing: 12) {
                    Text("My Journey")
                        .font(AppFonts.gamja(.title))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                        .padding(.top, 10)
                    
                    Rectangle()
                        .fill(SlowMeTheme.textPrimary.opacity(0.35))
                        .frame(height: 2.5)
                        .padding(.vertical, 8)
                    
                    WeekHeaderView(
                        weekStart: weekStart,
                        answeredDays: vm.answeredDays(in: weekStart),
                        canGoPrev: canGoPrev,
                        canGoNext: weekStart < currentWeekStart,
                        onPrev: {
                            guard let earliest = earliestWeekStart else { return }
                            let prev = Calendar.current.date(byAdding: .day, value: -7, to: weekStart)!
                            if prev >= earliest { weekStart = prev }              
                        },
                        onNext: {
                            let next = Calendar.current.date(byAdding: .day, value: 7, to: weekStart)!
                            if next <= currentWeekStart { weekStart = next }
                        }
                    )

                    
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            
                            ScrollView {
                                VStack(spacing: 12) {
                                    let entries = vm.entries(in: weekRange)
                                    
                                    if entries.isEmpty {
                                        Text("No answers this week.")
                                            .font(AppFonts.gamja(.body))
                                            .foregroundStyle(SlowMeTheme.white.opacity(0.9))
                                            .padding(.top, 18)
                                            .frame(maxWidth: .infinity)
                                    } else {
                                        ForEach(entries.sorted(by: { $0.date < $1.date })) { e in
                                            WeekEntryCardView(entry: e)
                                                .frame(width: geo.size.width * 0.93)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .top)
                                .padding(.top, 8)
                                .padding(.bottom, 8)
                            }
                            
                            if vm.isReflectionAvailable(forWeekStart: weekStart) {
                                Button {
                                    vm.push(.reflection(vm.reflectionSunday(forWeekStart: weekStart)))
                                } label: {
                                    Text("Reflection")
                                        .font(AppFonts.gamja(.title3))
                                        .foregroundStyle(SlowMeTheme.textPrimary)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .frame(width: geo.size.width * 0.93)
                                .padding(.bottom, 12)
                                .padding(.top, 8)
                            } else {
                                Spacer().frame(height: 10)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { vm.popToRoot() } label: {
                    Text("‹")
                        .font(AppFonts.gamja(.largeTitle))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                }
            }
        }
        .onAppear { weekStart = currentWeekStart }
    }
}

#Preview {
    NavigationStack {
        JourneyView()
            .environmentObject(AppViewModel())
    }
}
