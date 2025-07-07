//
//  PlantApp.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PlantApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var userViewModel = UserViewModel()
    
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false

  var body: some Scene {
    WindowGroup {
        LoginView()
            .environmentObject(userViewModel)
            .environment(\.darkModeEnabled, $isDarkModeOn)
            .preferredColorScheme(isDarkModeOn ? .dark : .light)

    }
  }
}


