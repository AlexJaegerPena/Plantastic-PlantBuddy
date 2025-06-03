//
//  LoginViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class LoginViewModel: ObservableObject {
    @Published var user: User?
    @Published var username: String?
    @Published var email: String = ""
    @Published var password: String = ""
    
    var isLoggedIn: Bool { user != nil }
    var isRegistrationComplete: Bool { username != nil }
    
    private let auth = FirebaseManager.shared.auth
    private let userRepository = UserRepository()
    private var authListener: NSObjectProtocol?
    private var firestoreListener: ListenerRegistration?
    
    init() {
        checkLogin()
        addAuthListener()
    }
    
    func checkLogin() {
        if let user = auth.currentUser {
            self.user = user
        }
    }
    
    func signInEmailPassword() {
        auth.signIn(withEmail: email, password: password)
    }
    
    func registerWithEmailPassword() {
        Task {
            do {
                let result = try await auth.createUser(withEmail: email, password: password)
                let fireUser = FireUser(id: result.user.uid, username: username ?? "", email: email, password: password)
                try userRepository.createUser(fireUser)
            } catch {
                print(error)
            }
        }
    }
    
    
    func updateUser(with id: String?, username: String) {
        guard let id else { return }
        let data = ["username": username]
        
        FirebaseManager.shared.database.collection("user").document(id).updateData(data) { error in
            if let error {
                print("User has not been updated.", error)
                return
            }
            print("User has been updated.")
        }
    }
    
    func addAuthListener() {
        self.authListener = auth.addStateDidChangeListener { [weak self] auth, user in
            self?.user = user
        }
    }
    
//    func addListenerForUser(userId: String) {
//        user(userId: userId).addSnapshotListener { querySnapshot, error in
//            
//        }
//    }
}



