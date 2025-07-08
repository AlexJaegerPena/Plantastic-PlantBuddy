//
//  UserViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var userId: String?
    @Published var username: String = ""
    @Published var email: String = "" {
        didSet {
            authError = nil
        }
    }
    @Published var password: String = "" {
        didSet {
            authError = nil
        }
    }
    @Published var authError: AuthError?
    @Published var toast: Toast? = nil

    var isLoggedIn: Bool { user != nil }
    var isUsernameSet: Bool { return !username.isEmpty }  // prüfen, ob String nicht leer

    private let auth = FirebaseManager.shared.auth
    private let userRepository = UserRepository()
    private var authListener: NSObjectProtocol?

    init() {
        checkLogin()
        addAuthListener()
    }

    
    func checkLogin() {
        if let user = auth.currentUser {
            self.user = user
        }
    }

    
    func loginEmailPassword() async throws {
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }

        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch {
            let mappedError = error.asAuthError
            if mappedError == AuthError.invalidCredentials {
                let emailExists = try await userRepository.emailExists(email)
                throw emailExists ? AuthError.invalidCredentials : AuthError.userNotFound
            } else {
                throw mappedError
            }
        }
    }

    
    func registerWithEmailPassword() async throws {
        guard !email.isEmpty else { throw AuthError.emptyEmail }
        guard !password.isEmpty else { throw AuthError.emptyPassword }

        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let fireUser = FireUser(id: result.user.uid, username: "", email: email, favoritePlants: [])
            try userRepository.saveUserData(fireUser)
        } catch {
            throw error.asAuthError
        }
    }

    
    func updateUsername(username: String) {
        guard let userId = self.userId else { return }
        let data = ["username": username]

        FirebaseManager.shared.database.collection("users").document(userId)
        .updateData(data) { error in
            DispatchQueue.main.async {  // auf dem Main Thread aktualisieren
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
        self.authListener = auth.addStateDidChangeListener {
            [weak self] auth, user in

            // Schritt 3: Wenn ein gültiger, nicht-anonymer Benutzer angemeldet ist...
            self?.user = user  // ..setze die veröffentlichte Eigenschaft 'user' auf den Firebase-Benutzer
            self?.userId = user?.uid  // // ...setze die veröffentlichte Eigenschaft 'userId' auf die UID des Benutzers
            self?.email = user?.email ?? ""

            // Schritt 4: Asynchronen Task starten, um zusätzliche Benutzerdaten abzurufen
            Task {
                if let userId = user?.uid {
                    await self?.fetchUsername(userId: userId)
                } else {
                    // Eigenschaften nach abmeldung zurücksetzen
                    self?.username = ""
                    self?.email = ""
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
        print("DeleteUser wurde aufgerufen")

        guard let userId else { return }
        // 1. Firestore-Dokument löschen
        FirebaseManager.shared.database.collection("users").document(userId).delete { error in
            if let error {
                print("User-Dokument konnte nicht gelöscht werden:", error)
                return
            }
            print("Firestore-Dokument gelöscht.")
        }

        // 2. Firebase Auth-Account löschen
        auth.currentUser?.delete(completion: { error in
            if let error {
                print("Auth-Account konnte nicht gelöscht werden:", error)
            } else {
                print("Firebase Auth-Account gelöscht.")
                // Automatisch ausloggen
                self.signOut()
            }
        })
    }
}
