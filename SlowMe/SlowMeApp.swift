import SwiftUI

@main
struct SlowMeApp: App {
    @StateObject private var appVM = AppViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appVM.path) {
                HomeView()
                    .environmentObject(appVM)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .checkIn:
                            CheckInView()

                        case .confirmation:
                            ConfirmationView()

                        case .journey:
                            JourneyView()

                        case .reflection(let date):
                            ReflectionView(reflectionSunday: date)
                        }
                    }
            }
            .environmentObject(appVM)
            .font(.custom("Gamja Flower", size: 18))
        }
    }
}

