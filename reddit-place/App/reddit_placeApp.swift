//
//  reddit_placeApp.swift
//  reddit-place
//
//  Created by chuy g on 18/04/22.
//

import SwiftUI
import SwiftyBeaver

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Logger
        let log = SwiftyBeaver.self
        
        let console = ConsoleDestination()  // log to Xcode Console
        log.addDestination(console)
        // Now let’s log!
        //        log.verbose("not so important")  // prio 1, VERBOSE in silver
        //        log.debug("something to debug")  // prio 2, DEBUG in green
        //        log.info("a nice information")   // prio 3, INFO in blue
        //        log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
        //        log.error("ouch, an error did occur!")  // prio 5, ERROR in red
        
        return true
    }
}

@main
struct reddit_placeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
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
