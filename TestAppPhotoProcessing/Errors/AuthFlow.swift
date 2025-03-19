//
//  AuthFlow.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}
