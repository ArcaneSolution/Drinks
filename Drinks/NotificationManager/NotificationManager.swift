//
//  NotificationManager.swift
//  Drinks
//
//  Created by M Usman on 24/04/2024.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func handleNotification()  {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.scheduleNotification()
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    private func scheduleNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            guard !requests.contains(where: { $0.identifier == "afterNoon" }) else {
                return
            }
            // Create content for the notification
            let favorite = DBManager.shared.getAllFavorites().randomElement()
            
            let content = UNMutableNotificationContent()
            content.title = "Its 2'O Clock"
            content.body = "Need some drinks open app now"
            if let fav = favorite {
                content.body = fav.name
            }
            content.sound = UNNotificationSound.default
            
            // Attach an image to the notification
            if let fav = favorite, let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(fav.image).png"),let copingURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("localNotification.png") {
                do {
                    // making copy of file as UNNotificationAttachment move file
                    try FileManager.default.copyItem(at: imageURL, to: copingURL)
                    if FileManager.default.fileExists(atPath: copingURL.path) {
                        let attachment = try UNNotificationAttachment(identifier: "image", url: copingURL, options: nil)
                        content.attachments = [attachment]
                    }
                } catch {
                    print("Failed to attach image to notification: \(error)")
                }
            }
            var dateComponents = DateComponents()
            dateComponents.hour = 14
            dateComponents.minute = 00
            
            // Create a trigger for the notification at 1:00 AM
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create a notification request
            let request = UNNotificationRequest(identifier: "afterNoon", content: content, trigger: trigger)
            
            // Add the notification request to the notification center
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Failed to schedule notification: \(error)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }
    }
}
