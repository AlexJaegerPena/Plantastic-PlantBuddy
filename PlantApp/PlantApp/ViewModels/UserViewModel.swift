//
//  UserViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var userId: String?
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    
//    @Published var onboardingCompleted: Bool {
//        didSet {
//            UserDefaults.standard.set(onboardingCompleted, forKey: "onboardingCompleted")
//        }
//    }
//    @Published var firePlant: FirePlant?
//    @Published var favoritePlantsList: [FirePlant] = []
    //    @Published var isAuthStatusChecked = false
    
    var isRegistrationComplete: Bool = false
    var isLoggedIn: Bool { user != nil }
    
    private let auth = FirebaseManager.shared.auth
    
    private let userRepository = UserRepository()
    
    private var authListener: NSObjectProtocol?
    
    init() {
//        self.onboardingCompleted = UserDefaults.standard.set(forKey: "onboardingCompleted")
        addAuthListener()
    }
    
    
//    func checkLogin() {
////        try? auth.signOut() // Nutzer bei Start ausloggen
//        self.user = nil
//        self.userId = nil
//    }

    
    func loginEmailPassword(email: String, password: String) async {

        do {
                try await auth.signIn(withEmail: email, password: password)
                print("Erfolgreich eingeloggt:")
            
        } catch {
            print("Fehler beim Einloggen:", error.localizedDescription)
        }
    }
    
    
    func registerWithEmailPassword(email: String, password: String) async {
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let fireUser = FireUser(id: result.user.uid, username: username, email: email, password: password, favoritePlants: [])
                try userRepository.createUser(fireUser)
            } catch {
                print(error)
            }
        }
    }
    
    
    func updateUsername(username: String) {
        guard let userId = self.userId else { return }
        let data = ["username": username]
        
        FirebaseManager.shared.database.collection("users").document(userId).updateData(data) { error in
            if let error {
                print("User has not been updated.", error)
                return
            }
            print("User has been updated.")
        }
    }
    
    func addAuthListener() {
        // Schritt 1: Den Listener registrieren und eine Referenz speichern
        self.authListener = auth.addStateDidChangeListener { [weak self] auth, user in
            
            // Schritt 3: Wenn ein gültiger, nicht-anonymer Benutzer angemeldet ist...
            self?.user = user // ..setze die veröffentlichte Eigenschaft 'user' auf den Firebase-Benutzer
            self?.userId = user?.uid // // ...setze die veröffentlichte Eigenschaft 'userId' auf die UID des Benutzers
            
            // Schritt 4: Asynchronen Task starten, um zusätzliche Benutzerdaten abzurufen
            Task {
                if let userId = user?.uid {
                    await self?.fetchUsername(userId: userId)
                }
//                self?.isAuthStatusChecked = true
            }
        }
    }
    
    func fetchUsername(userId: String) async {
           do {
               let fireUser = try await userRepository.getUserByID(userId)
               self.username = fireUser.username
           } catch {
               print("Fehler beim Abrufen des Benutzernamens: \(error.localizedDescription)")
           }
       }
    
    func signOut() {
            do {
                try auth.signOut()
                // Der Auth-Listener wird ausgelöst und setzt die Properties auf nil
                print("Benutzer erfolgreich abgemeldet.")
            } catch {
                print("Fehler beim Abmelden: \(error.localizedDescription)")
            }
        }

}





