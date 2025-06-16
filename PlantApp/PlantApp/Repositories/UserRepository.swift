//
//  UserRepository.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import FirebaseFirestore


class UserRepository {
    
    private let collectionRef = FirebaseManager.shared.database.collection("users")
    
    
    func createUser(_ user: FireUser) throws {
        guard let id = user.id else { throw FirestoreUserError.idNotFound }
        try collectionRef.document(id).setData(from: user)
    }
    
    
    func getUserByID(_ id: String) async throws -> FireUser {
        return try await collectionRef.document(id).getDocument(as: FireUser.self)
    }
    
    func getUserByEmail(_ email: String) async throws -> FireUser {
        guard let user = try await collectionRef
            .whereField("email", isEqualTo: email)
            .getDocuments()
            .documents
            .first?
            .data(as: FireUser.self) else { throw FirestoreUserError.usernameNotFound }
        return user
    }
    
//    func loginUser()
//    func logoutUser()
    
}

enum FirestoreUserError: String, Error {
    case usernameNotFound = "The username could not be found."
    case idNotFound = "The ID does not exist."
}
