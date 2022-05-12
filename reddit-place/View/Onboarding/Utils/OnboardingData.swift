//
//  OnboardingData.swift
//  reddit-place
//
//  Created by chuy g on 11/05/22.
//

import Foundation

struct OnboardingData: Hashable, Identifiable {
    let id: Int
    let backgroundImage: String
    let objectImage: String
    let primaryText: String
    let secondaryText: String

    static let list: [OnboardingData] = [
        OnboardingData(id: 0, backgroundImage: "bg", objectImage: "welcome", primaryText: "¡Hello 👋!", secondaryText: "Welcome to Place, a r/place canvas clone made with Appwrite and SwiftUI. 😄"),
        
        OnboardingData(id: 1, backgroundImage: "bg", objectImage: "time", primaryText: "Instructions 😃", secondaryText: "You can place a pixel every 30 seconds, that's all. 😎"),
        
        OnboardingData(id: 2, backgroundImage: "bg", objectImage: "enjoy", primaryText: "Get fun 🤪", secondaryText: "¡Thanks for read and enjoy it!")
    ]
}
