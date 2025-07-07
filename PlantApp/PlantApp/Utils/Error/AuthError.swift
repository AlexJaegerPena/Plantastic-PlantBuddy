//
//  AuthError.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 04.07.25.
//

import Foundation

enum AuthError: String, LocalizedError {
    case emptyEmail = "Please enter an email address."
    case emptyPassword = "Please enter a password."
    case invalidCredentials = "Invalid email or password."
    case userNotFound = "User not found. Please register first."
    case emailAlreadyInUse = "This email is already registered."
    case weakPassword = "Your password is too weak. Please enter at least 6 characters"
    case networkError = "A network error occurred."
    case tooManyRequests = "Too many failed attempts. Please try again later."
    case unknown = "An unknown error occurred."

    var errorDescription: String? {
        return self.rawValue
    }
}
