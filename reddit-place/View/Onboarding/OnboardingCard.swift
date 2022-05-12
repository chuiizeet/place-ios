//
//  OnboardingCard.swift
//  reddit-place
//
//  Created by chuy g on 11/05/22.
//

import SwiftUI

struct OnboardingCard: View {
    var data: OnboardingData
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Image(data.objectImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: reader.size.width, height: reader.size.height / 2, alignment: .center)
                        
                        .scaleEffect(isAnimating ? 1 : 0.75)
                        .padding(.vertical, 16)
                    Text(
                        data.primaryText)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .multilineTextAlignment(.center)

                    Text(data.secondaryText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.black)
                        .padding()
                }
                .padding(.bottom, 32)
                .background(Color.white).ignoresSafeArea()
                .onAppear(perform: {
                    isAnimating = false
                    withAnimation(.easeOut(duration: 0.4)) {
                        self.isAnimating = true
                    }
                })
                Spacer()
            }
        }
    }
}
