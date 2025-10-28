import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager() // singleton
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications: \(error.localizedDescription)")
            }
        }
    }
    
    func sendGeneralNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hey! 🌱"
        content.body = "Let’s water your plant!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled!")
            }
        }
    }

}
