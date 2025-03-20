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
    
    var onSignUpSuccess: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    
    private let authService: IAuthService
    private let userDefaultsRepository: IUserDefaultsRepository
    
    init(_ dependencies: IDependencies) {
        self.authService = dependencies.authService
        self.userDefaultsRepository = dependencies.userDefaultsRepository
    }
    
    
    
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) async {
        
        guard !email.isEmpty, !password.isEmpty else {
            await MainActor.run {
                errorMessage = "Email and password cannot be empty."
            }
            return
        }
        
        errorMessage = nil
        
        let result = await authService.signUpWithEmailPassword(email: email, password: password)
        
        await MainActor.run {
            switch result {
            case .success:
                self.authSuccess = true
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
