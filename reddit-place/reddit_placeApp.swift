//
//  reddit_placeApp.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI

@main
struct reddit_placeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: TouchHandler
final class TouchHandler: NSObject, UIGestureRecognizerDelegate {
    static let shared = TouchHandler()
    var currentPoint: CGPoint?
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        currentPoint = touch.location(in: touch.window)
        return false
    }
}
