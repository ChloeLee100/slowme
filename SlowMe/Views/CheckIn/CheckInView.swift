import SwiftUI

struct CheckInView: View {
    @EnvironmentObject var vm: AppViewModel

    @State private var showOther = false

    var body: some View {
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()

            ContentContainer {
                VStack(spacing: 16) {
                    Text("Today’s Check-In")
                        .font(AppFonts.gamja(.title))
                        .foregroundStyle(SlowMeTheme.textPrimary)
                        .padding(.top, 18)
                    
                    Rectangle()
                        .fill(SlowMeTheme.textPrimary.opacity(0.35))
                        .frame(height: 2.5)
                        .padding(.vertical, -10)

                    if let q = vm.nextQuestion {
                        Text(q.prompt)
                            .font(.custom("GamjaFlower-Regular", size: 37))
                            .foregroundStyle(SlowMeTheme.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 10)

                        GeometryReader { geo in
                            VStack(spacing: 14) {
                                
                                ForEach(q.options.prefix(5)) { opt in
                                    Button {
                                        vm.submitAnswer(option: opt, otherText: nil)
                                        vm.push(.confirmation)
                                    } label: {
                                        Text(opt.text)
                                            .font(AppFonts.gamja(.title3))
                                            .frame(maxWidth: .infinity)
                                    }
                                    .frame(width: geo.size.width * 0.70)
                                    .buttonStyle(PrimaryButtonStyle())
                                    .padding(.vertical, 3)
                                }
                                
                                if q.allowsOther {
                                    Button {
                                        showOther = true
                                    } label: {
                                        Text("Others?")
                                            .font(AppFonts.gamja(.title3))
                                    }
                                    .frame(width: geo.size.width * 0.70)
                                    .buttonStyle(SecondaryButtonStyle())
                                    .padding(.vertical, 3)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        Text("You’ve finished all questions for now.")
                            .foregroundStyle(SlowMeTheme.white)
                            .padding(.top, 30)
                    }

                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showOther) {
            if let q = vm.nextQuestion {
                OtherAnswerSheet(prompt: q.prompt) { typed in
                    vm.submitAnswer(option: nil, otherText: typed)
                    showOther = false

                    DispatchQueue.main.async {
                        vm.push(.confirmation)
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
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
