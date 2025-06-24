//
//  NotificationsViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import Foundation
import UserNotifications

@MainActor
class NotificationsViewModel: ObservableObject {
    
    @Published var allowNotifications: Bool = false
    @Published var hour: Int?
    @Published var minute: Int?
    
    private let center = UNUserNotificationCenter.current()
    
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
            if let error {
                print(error)
                return
            }
            guard granted else {
                print("Notifications denied.")
                return
            }
            print("Notifications accepted.")
        }
    }
    
    
    func wateringNotification(hour: Int,  minute: Int) {
        // 1. Content
        let content = UNMutableNotificationContent()
        content.title = "Watering Notification"
        content.body = "Your plants need to be watered"
        content.sound = UNNotificationSound.default
        
        //2. Trigger
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        // 3. Schicken
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let error {
                print("Fehler beim Schicken der Notificatin: \(error)")
            }
            print("Notification has been set to \(String(describing: date.hour)):\(String(describing: date.minute))")
        }
    }
    
}
