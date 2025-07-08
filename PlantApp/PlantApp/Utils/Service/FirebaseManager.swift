//
//  FirebaseManager.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}
    
    let auth = Auth.auth()
    let database = Firestore.firestore()
    
    var userID: String? {
        auth.currentUser?.uid
    }
}
