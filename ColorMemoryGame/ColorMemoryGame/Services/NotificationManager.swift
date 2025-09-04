import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func scheduleDailyNotification() {
        let notification = UNMutableNotificationContent()
        notification.title = "Color Memory Game"
        notification.body = "Пора сыграть и потренировать память!"
        notification.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyGameReminder", content: notification, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
