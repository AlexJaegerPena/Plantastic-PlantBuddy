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
    
    var isLoggedIn: Bool { user != nil }
    var isUsernameSet: Bool { return !username.isEmpty} // prüfen, ob String nicht leer
    
    private let auth = FirebaseManager.shared.auth
    private let userRepository = UserRepository()
    private var authListener: NSObjectProtocol?
    
    init() {
        addAuthListener()
    }
    
    // Init für Mock-Daten für Previews
    init(mockUserId: String, mockUsername: String, mockEmail: String) {
        self.userId = mockUserId
        self.username = mockUsername
        self.email = mockEmail
    }

    
    func loginEmailPassword() async {
        do {
                try await auth.signIn(withEmail: email, password: password)
                print("Erfolgreich eingeloggt:")
            
        } catch {
            print("Fehler beim Einloggen:", error.localizedDescription)
        }
    }
    
    
    func registerWithEmailPassword() async {
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let fireUser = FireUser(id: result.user.uid, username: "", email: email, favoritePlants: [])
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
            DispatchQueue.main.async { // auf dem Main Thread aktualisieren
                if let error {
                    print("User has not been updated.", error)
                    return
                }
                print("User has been updated.")
            }
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
    
    func deleteUser(_ userId: String?) {
        guard let userId else { return }
        FirebaseManager.shared.database.collection("users").document(userId).delete() { error in
            if let error {
                        print("User kann nicht gelöscht werden", error)
                        return
            }
            print("User mit ID \(userId) gelöscht.")
        }
    }

}





