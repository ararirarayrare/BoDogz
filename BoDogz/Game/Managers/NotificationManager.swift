import Foundation
import UserNotifications

struct NotificationManager {
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
          completion(granted)
        }
    }
    
    func addNotification(title: String, body: String, date: Date) {
        let notificationDate = date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let strinDate = formatter.string(from: notificationDate)
                
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "reminderSound.mp3"))
        content.userInfo = ["date": strinDate]
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: false)
        
        let request = UNNotificationRequest(identifier: title + body,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func getPendingNotifications(completion: @escaping  ([UNNotificationContent]) -> ())  {
        var contents = [UNNotificationContent]()
        notificationCenter.getPendingNotificationRequests { reminders in
            reminders.forEach { request in
                let content = request.content
                contents.append(content)
            }
            completion(contents)
        }
    }
    
    func removeNotification(with identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
