//
//  HomeView.swift
//  reddit-place
//
//  Created by chuy g on 27/04/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { proxy in
            let bottomEdge = proxy.safeAreaInsets.bottom
            let topEdge = proxy.safeAreaInsets.top
            
            ContentView(bottomEdge: bottomEdge, topEdge: topEdge)
//            MainHome(bottomEdge: (bottomEdge == 0 ? 15 : bottomEdge), sourceRaw: sourceHomeUserDefaul, shouldShowSubscriptionView: isNewVersion)
//                .ignoresSafeArea(.all, edges: .bottom)
            
        }
    }
}
