//
//  SignUpViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import Combine
import SwiftUI
import FirebaseAuth

protocol SignUpViewModelDelegate {
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) async
}

final class SignUpViewModel: ObservableObject, SignUpViewModelDelegate {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var authSuccess: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showSuccessAlert = false
    var onSignUpSuccess: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    
    private let authService: IAuthService
    private let userDefaultsRepository: IUserDefaultsRepository
    
    init(_ dependencies: IDependencies) {
        self.authService = dependencies.authService
        self.userDefaultsRepository = dependencies.userDefaultsRepository
        
        
    }
    
    func validateCredentials() -> String? {
        if email.isEmpty || password.isEmpty {
            return "Email and password cannot be empty."
        }
        
        if !email.contains("@") || !email.contains(".") {
            return "Please enter a valid email."
        }
        
        if password.count < 6 {
            return "Password must be at least 6 characters."
        }
        
        return nil // всё ок
    }
    
    func didTapSignUp() {
        Task {
            await signUp(email: email, password: password) { _ in }
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) async {
        
        let validationError = validateCredentials()
        if let validationError = validationError {
            await MainActor.run {
                errorMessage = validationError
            }
            return
        }
        
        let result = await authService.signUpWithEmailPassword(email: email, password: password)
        
        await MainActor.run {
            switch result {
            case .success:
                self.authSuccess = true
                self.showSuccessAlert = true
                self.onSignUpSuccess?()
                completion(.success(true))
            case .failure(let error):
                self.authSuccess = false
                self.errorMessage = error.localizedDescription
                completion(.failure(error))
            }
        }
    }
}
