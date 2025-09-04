import SwiftUI

@main
struct ColorMemoryGameApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .onAppear {
                    NotificationManager.shared.requestPermission()
                    NotificationManager.shared.scheduleDailyNotification()
                }
        }
    }
}
