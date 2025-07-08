//
//  FirebaseErrorMapper.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 06.07.25.
//

import Foundation
import FirebaseAuth


// Firebase Fehler in eigenen AuthError (enum) umwandeln
struct FirebaseErrorMapper {
    // generischen error entgegennehmen und AuthError zurück geben
    static func map(_ error: Error) -> AuthError {
        let nsError = error as NSError // Typecasting
        // Sicherstellen, dass Fehler ein Firebase-Auth-Fehler ist
        guard nsError.domain == AuthErrorDomain,
              let code = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown
        }
        // Basiernd auf Firebase-Fehlercode in passenden AuthError umwandeln
        switch code {
        case .userNotFound:
            return .userNotFound
        case .wrongPassword, .invalidEmail, .invalidCredential:
            return .invalidCredentials
        case .networkError:
            return .networkError
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .tooManyRequests:
            return .tooManyRequests
        default:
            return .unknown
        }
    }
}


// Error-Typ neue Eigenschaft asAuthError zuweisen
extension Error {
    var asAuthError: AuthError {
        FirebaseErrorMapper.map(self)
    }
}
