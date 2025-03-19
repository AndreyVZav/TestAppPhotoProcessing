//
//  AuthError.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import FirebaseAuth
import Foundation

enum AuthError: Error {
    case invalidEmail
    case wrongPassword
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case tooManyRequests
    case userDisabled
    case networkError
    case tokenExpired
    case missingEmail
    case operationNotAllowed
    case userMismatch
    case accountExistsWithDifferentCredential
    case invalidCredential
    case invalidVerificationCode
    case invalidVerificationID
    case providerError
    case unknownError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return "The email address is badly formatted."
        case .wrongPassword:
            return "The password is incorrect."
        case .userNotFound:
            return "No user found with this email."
        case .emailAlreadyInUse:
            return "This email is already in use. Please use another email."
        case .weakPassword:
            return "Your password is too weak. Please use a stronger password."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        case .userDisabled:
            return "This user account has been disabled."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .tokenExpired:
            return "Your session has expired. Please log in again."
        case .missingEmail:
            return "Email is required but missing."
        case .operationNotAllowed:
            return "This operation is not allowed."
        case .userMismatch:
            return "The user credentials do not match."
        case .accountExistsWithDifferentCredential:
            return "An account already exists with a different credential."
        case .invalidCredential:
            return "Invalid credentials provided."
        case .invalidVerificationCode:
            return "The verification code entered is incorrect."
        case .invalidVerificationID:
            return "The verification ID is invalid."
        case .providerError:
            return "Authentication provider returned an error."
        case .unknownError(let message):
            return "Unknown error occurred: \(message)"
        }
    }
}

extension AuthError {
    static func map(_ error: Error) -> AuthError {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.wrongPassword.rawValue:
            return .wrongPassword
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse
        case AuthErrorCode.weakPassword.rawValue:
            return .weakPassword
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequests
        case AuthErrorCode.userDisabled.rawValue:
            return .userDisabled
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        case AuthErrorCode.missingEmail.rawValue:
            return .missingEmail
        case AuthErrorCode.operationNotAllowed.rawValue:
            return .operationNotAllowed
        case AuthErrorCode.userMismatch.rawValue:
            return .userMismatch
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            return .accountExistsWithDifferentCredential
        case AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredential
        case AuthErrorCode.invalidVerificationCode.rawValue:
            return .invalidVerificationCode
        case AuthErrorCode.invalidVerificationID.rawValue:
            return .invalidVerificationID
        default:
            return .unknownError(message: error.localizedDescription)
        }
    }
}
