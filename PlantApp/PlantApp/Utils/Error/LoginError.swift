////
////  LoginError.swift
////  PlantApp
////
////  Created by Alexandra Jäger on 04.07.25.
////
//
//import Foundation
//import FirebaseAuth
//
////enum LoginError: String,  LocalizedError {
////    case emptyEmail = "Please enter an email address."
////    case emptyPassword = "Please enter a password."
////    case userNotFound = "User not found. Please register first."
////    case invalidCredentials = "Invalid email or password."
////    case networkError = "A network error occurred"
////    case unknown = "An unknown error occurred"
////    
////    
////}
//
//enum LoginError: LocalizedError {
//    case emptyEmail
//    case emptyPassword
//    case userNotFound
////    case networkError
//    case firebase(AuthErrorCode?)
//    
//    var errorDescription: String? {
//        switch self {
//        case .emptyEmail: return "Please enter an email address."
//        case .emptyPassword: return "Please enter a password."
//        case .userNotFound: return "User not found."
////        case .invalidCredentials: return "Invalid email or password."
////        case .networkError: return "A network error occurred"
//        case .firebase(let code):
//            switch code {
//            case .userNotFound:
//                return "User not found. Please register first."
////            case .wrongPassword, .invalidEmail:
////                return "Invalid email or password."
//            case .invalidCredential:
//                return "Invalid email or password."
//            case .networkError:
//                return "A network error occurred"
//            case .tooManyRequests:
//                    return "Too many failed attempts. Please try again later."
//            case .none:
//                return "An unknown Firebase error occurred"
//            default:
//                return "An unknown error occurred"
//            }
//        }
//    }
//}
