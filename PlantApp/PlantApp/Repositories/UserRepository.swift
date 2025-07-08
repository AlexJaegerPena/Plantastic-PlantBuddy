//
//  UserRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import FirebaseFirestore
import FirebaseAuth



class UserRepository {
        
    private let collectionRef = FirebaseManager.shared.database.collection("users")
    
    func saveUserData(_ user: FireUser) throws {
        guard let id = user.id else { throw AuthError.userNotFound }
        try collectionRef.document(id).setData(from: user)
    }
    
    func getUserByID(_ id: String) async throws -> FireUser {
       return try await collectionRef.document(id).getDocument(as: FireUser.self)
    }
    
    func emailExists(_ email: String) async throws -> Bool {
        let snapshot = try await collectionRef
            .whereField("email", isEqualTo: email.lowercased())
            .getDocuments()
        return !snapshot.documents.isEmpty
    }
}

//    func getUserByEmail(_ email: String) async throws -> FireUser {
//        guard let user = try await collectionRef
//            .whereField("email", isEqualTo: email)
//            .getDocuments()
//            .documents
//            .first?
//            .data(as: FireUser.self) else { throw AuthError.userNotFound }
//        return user
//    }



