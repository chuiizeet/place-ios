//
//  OnboardingView.swift
//  reddit-place
//
//  Created by chuy g on 11/05/22.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(K.UserDefaultsKeys.isOnboarding) var isOnboarding: Bool?
    @State private var currentTab = 0
    
    init() {
        
    }
    
    
    var body: some View {
        VStack {
            TabView(selection: $currentTab,
                    content:  {
                ForEach(OnboardingData.list) { viewData in
                    OnboardingCard(data: viewData)
                    
                }
            })
                .preferredColorScheme(.light)
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .animation(.easeOut, value: currentTab)
                .transition(.slide)
            
            Spacer()
            Button(action: {
                let impactLight = UIImpactFeedbackGenerator(style: .light)
                impactLight.impactOccurred()
                handleButtonPressed()
            }, label: {
                Text(currentTab != 2 ? "Next" : "Let's Go")
                    .font(.some(.system(size: 28, weight: .bold, design: .rounded)))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .padding(.horizontal, (DeviceUtil.screenW / 4))
                    .padding(.vertical, 16)
                
            })
                .tint(Color(hex: ColorsAllowed.red.hex))
                .buttonStyle(.borderedProminent)
                .shadow(color: Color(hex: ColorsAllowed.blue.hex).opacity(0.5), radius: 5, x: 0, y: 2.5)
                .padding(.bottom, 32)
            Spacer()
        }
        
    }
    
    private func handleButtonPressed() {
        if currentTab == 0 {
            self.currentTab = 1
        } else if currentTab == 1 {
            self.currentTab = 2
        } else {
            isOnboarding = false
        }
    }
}
