//
//  FirebaseErrorMapper.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 06.07.25.
//

import Foundation
import FirebaseAuth

struct FirebaseErrorMapper {
    static func map(_ error: Error) -> AuthError {
        let nsError = error as NSError
        guard nsError.domain == AuthErrorDomain,
              let code = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown
        }

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


// Typ Error um asAuthError erweitern
extension Error {
    var asAuthError: AuthError {
        FirebaseErrorMapper.map(self)
    }
}
