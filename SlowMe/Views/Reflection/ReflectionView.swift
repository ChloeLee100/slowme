import SwiftUI

struct ReflectionView: View {
    @EnvironmentObject var vm: AppViewModel
    let reflectionSunday: Date
    
    var body: some View {
        let result = ReflectionEngine.generate(answers: vm.answers, reflectionSunday: reflectionSunday)
        
        ZStack {
            SlowMeTheme.screenBackground.ignoresSafeArea()
            
            ContentContainer {
                GeometryReader { geo in
                    VStack(spacing: 12) {
                        
                        Text("Reflection")
                            .font(AppFonts.gamja(.title))
                            .foregroundStyle(SlowMeTheme.textPrimary)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Rectangle()
                            .fill(SlowMeTheme.textPrimary.opacity(0.35))
                            .frame(height: 2.5)
                            .padding(.vertical, 8)
                        
                        Text(result.title)
                            .font(AppFonts.gamja(.title))
                            .foregroundStyle(SlowMeTheme.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)
                        
                        ZStack(alignment: .bottom) {
                            
                            Image("sloth_reflection")
                                .resizable()
                                .scaledToFit()
                                .scaleEffect(1.10) // keep as-is
                                .frame(width: geo.size.width)
                                .frame(maxWidth: .infinity, alignment: .bottom)
                            
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(result.bodyLines, id: \.self) { line in
                                        ReflectionCardView(line: line)
                                    }
                                }
                                .padding(.top, 8)
                                .padding(.bottom, geo.size.height * 0.30)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { vm.pop() } label: {
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
        ReflectionView(reflectionSunday: Date())
            .environmentObject(AppViewModel())
    }
}
