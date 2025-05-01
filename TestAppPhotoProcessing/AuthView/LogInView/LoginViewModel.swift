//
//  LoginViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    func login(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
}


final class LoginViewModel: ObservableObject, LoginViewModelDelegate {
    @Published var email: String = ""
    
    @Published var password: String = ""
    @Published var authSuccess: Bool = false
    @Published var errorMessage: String? = nil
    @Published var shouldRememberMe: Bool = false
    let googleSignInViewModel: GoogleSignInViewModel
    
    var onLoginSuccess: (() -> Void)?
    var onCancelTapped: (() -> Void)?
    
    private let authService: IAuthService
    private let userDefaultsRepository: IUserDefaultsRepository
    
    private let keychain = KeychainService.shared
    private let rememberMeKey = "rememberedEmail"
    
    init(_ dependencies: IDependencies) {
        self.authService = dependencies.authService
        self.userDefaultsRepository = dependencies.userDefaultsRepository
        self.googleSignInViewModel = GoogleSignInViewModel()
        
        self.googleSignInViewModel.onSuccess = { [weak self] in
                    self?.authSuccess = true
                    self?.onLoginSuccess?()
                }
        
        loadRememberedCredentials() // загружаем email и пароль при старте
    }
    
    func rememberMe() {
        if shouldRememberMe {
            keychain.save(password: password, for: email)
            userDefaultsRepository.setValue(email, forKey: UserDefaultsKey.rememberedEmail)
        } else {
            keychain.deletePassword(for: email)
            userDefaultsRepository.removeValue(forKey: rememberMeKey)
        }
    }
    
    func loadRememberedCredentials() {
        if let savedEmail = userDefaultsRepository.getValue(forKey: UserDefaultsKey.rememberedEmail) as? String,
           let savedPassword = keychain.getPassword(for: savedEmail) {
            self.email = savedEmail
            self.password = savedPassword
            self.shouldRememberMe = true
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        
        errorMessage = nil
        
        Task {
            let result = await authService.logInWithEmail(email: email, password: password)
            
            await MainActor.run {
                switch result {
                case .success:
                    if shouldRememberMe {
                        rememberMe() // ✅ Сохраняем email + пароль после успешного входа
                    }
                    self.authSuccess = true
                    self.onLoginSuccess?()
                    completion(.success(true))
                case .failure(let error):
                    self.authSuccess = false
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}

