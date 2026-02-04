import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()

            ContentContainer {
                GeometryReader { geo in
                    ZStack(alignment: .bottom) {

                        VStack(spacing: 14) {

                            Text("That’s enough for today")
                                .font(AppFonts.gamja(.title))
                                .foregroundStyle(SlowMeTheme.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity)

                            Rectangle()
                                .fill(SlowMeTheme.textPrimary.opacity(0.35))
                                .frame(height: 2.5)
                                .frame(width: geo.size.width * 0.72)
                                .padding(.vertical, 8)

                            Text("See you tomorrow!")
                                .font(AppFonts.gamja(.title2))
                                .foregroundStyle(SlowMeTheme.white)

                            Button {
                                vm.goToJourneyFromAnywhere()
                            } label: {
                                Text("My Journey")
                                    .frame(maxWidth: .infinity)
                                    .font(AppFonts.gamja(.title3))
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .frame(width: geo.size.width * 0.7)
                            .padding(.top, 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .offset(y: -70)
                        
                        Spacer(minLength: 0)

                        Image("sloth_confirm")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.08)
                            .frame(maxWidth: geo.size.width)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
