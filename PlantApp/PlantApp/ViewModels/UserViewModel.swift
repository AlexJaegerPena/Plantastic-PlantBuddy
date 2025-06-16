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
    @Published var username: String?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firePlant: FirePlant?
    @Published var favoritePlantsList: [FirePlant] = []
    
    var isLoggedIn: Bool { user != nil }
    var isRegistrationComplete: Bool { username != nil }
    
    private let auth = FirebaseManager.shared.auth
    private let db = FirebaseManager.shared.database
    private let userRepository = UserRepository()
    
    private var authListener: NSObjectProtocol?
    
    init() {
        checkLogin()
        addAuthListener()
    }
    
    // Auth Listener sauber entfernen wenn ViewModel nicht mehr gebraucht wird
    deinit {
        if let authListener = authListener {
            auth.removeStateDidChangeListener(authListener)
        }
    }
    
    func checkLogin() {
        try? auth.signOut() // Nutzer bei Start ausloggen
        self.user = nil
        self.userId = nil
    }

    
    func loginEmailPassword(email: String, password: String) async {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            self.user = result.user
            print("Erfolgreich eingeloggt: \(result.user.email ?? "Unbekannt")")
            
        }  catch {
            print("Fehler beim Einloggen:", error.localizedDescription)
        }
    }
    
    
    func registerWithEmailPassword() async {
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let fireUser = FireUser(id: result.user.uid, username: username ?? "", email: email, password: password, favoritePlants: [])
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
        self.authListener = auth.addStateDidChangeListener { [weak self] auth, user in
            if let user = user, !user.isAnonymous { // Prüft, ob User NICHT anonym ist
                self?.user = user
                self?.userId = user.uid
            } else {
                self?.user = nil
                self?.userId = nil
            }
        }
    }
    
//    func addListenerForUser(userId: String) {
//        user(userId: userId).addSnapshotListener { querySnapshot, error in
//            
//        }
//    }
    
    func addPlantToFavorites(plant: FirePlant) async {
        guard let userId = self.userId else { return }

        let userRef = db.collection("users").document(userId).collection("favoritePlants") // Collection für Favoriten

        do {
            try userRef.addDocument(from: plant) // Speichert direkt als FirePlant
            print("Pflanze erfolgreich zu Favoriten hinzugefügt.")
        } catch {
            print("Fehler beim Speichern der Pflanze:", error.localizedDescription)
        }
    }
    
    // Aktualisieren der FavoritenListe
    func fetchFavoritePlants() {
        guard let userId = self.userId else { return }
        
        let userRef = db.collection("users").document(userId).collection("favoritePlants")

        // Listener um Änderungen live zu verfolgen
        userRef.addSnapshotListener { querySnapshot, error in
            if let error {
                print("Fehler beim Laden der Favoriten:", error.localizedDescription)
                return
            }
            // querySnapshot.documents enthält alle Dokumente die unter favoritePlants gespeichert sind
            guard let documents = querySnapshot?.documents else {
                print("Keine Favoriten gefunden")
                return
            }
            // versucht jedes Dokument als FirePlant zu dekodieren
            self.favoritePlantsList = documents.compactMap { try? $0.data(as: FirePlant.self) } // Direkt als Objekt laden
        }
    }

    func removePlantFromFavorites(plantId: String) async {
        guard let userId = self.userId else { return }

        let plantRef = db.collection("users").document(userId).collection("favoritePlants").document(plantId)

        do {
            try await plantRef.delete()
            print("Pflanze erfolgreich aus Favoriten entfernt.")
        } catch {
            print("Fehler beim Entfernen:", error.localizedDescription)
        }
    }

}



