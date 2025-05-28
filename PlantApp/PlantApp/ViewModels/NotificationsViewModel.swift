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
    
    
    
}
