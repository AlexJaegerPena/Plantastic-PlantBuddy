//
//  SettingsViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 02.06.25.
//

import Foundation


@MainActor
class SettingsViewModel: ObservableObject {
    private let fireManager = FirebaseManager.shared
    
    func logout() {
        print("logout")
        try? fireManager.auth.signOut()
    }
}
