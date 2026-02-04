import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()
            
            ContentContainer {
                GeometryReader { geo in
                    ZStack(alignment: .bottom) {

                        VStack(spacing: 18) {

                            Text(Date().homeDateString())
                                .font(AppFonts.gamja(.title2))
                                .foregroundStyle(SlowMeTheme.textPrimary)

                            Rectangle()
                                .fill(SlowMeTheme.textPrimary.opacity(0.35))
                                .frame(height: 2.5)
                                .frame(width: geo.size.width * 0.72)

                            VStack(spacing: 14) {
                                Button {
                                    vm.push(.checkIn)
                                } label: {
                                    Text("Today’s Check-In")
                                        .font(AppFonts.gamja(.body))
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(!vm.canAnswerToday)
                                .opacity(vm.canAnswerToday ? 1 : 0.55)
                                .frame(width: geo.size.width * 0.8)

                                Button {
                                    vm.push(.journey)
                                } label: {
                                    Text("My Journey")
                                        .font(AppFonts.gamja(.body))
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(SecondaryButtonStyle())
                                .frame(width: geo.size.width * 0.8)
                            }

                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .offset(y: -60)

                        Spacer(minLength: 0)
                        
                        Image("sloth_home")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.08)
                            .frame(maxWidth: geo.size.width)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
//            #if DEBUG
//            VStack(spacing: 10) {
//                Button("Debug: Seed 42 days of answers") {
//                    vm.debugSeedAnswersForLastDays(42)
//                }
//                .buttonStyle(SecondaryButtonStyle())
//
//                Button("Debug: Clear all answers") {
//                    vm.debugClearAllAnswers()
//                }
//                .buttonStyle(SecondaryButtonStyle())
//            }
//            #endif

        }
        .navigationBarHidden(true)

    }
}

#Preview {
    NavigationStack {
        HomeView().environmentObject(AppViewModel())
    }
}
