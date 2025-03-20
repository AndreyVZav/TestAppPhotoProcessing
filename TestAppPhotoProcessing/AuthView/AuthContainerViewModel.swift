//
//  AuthContainerViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI
import Combine

class AuthContainerViewModel: ObservableObject {
    @Published var isLoginShown = true
    var onAuthSuccess: (() -> Void)?
    
    let loginViewModel: LoginViewModel
    let signUpViewModel: SignUpViewModel
    let googleSignInViewModel: GoogleSignInViewModel
    
    init(loginViewModel: LoginViewModel, signUpViewModel: SignUpViewModel, onAuthSuccess: (() -> Void)? = nil) {
        self.loginViewModel = loginViewModel
        self.signUpViewModel = signUpViewModel
        self.onAuthSuccess = onAuthSuccess
        
        self.googleSignInViewModel = GoogleSignInViewModel()
        
        self.googleSignInViewModel.onSuccess = { [weak self] in
            self?.handleAuthSuccess()
            print("✅ Успешная авторизация через Google!")
        }
        
        self.loginViewModel.onLoginSuccess = { [weak self] in
            self?.handleAuthSuccess()
            print("✅ Успешная авторизация через email!")
        }
        
        self.loginViewModel.onCancelTapped = { [weak self] in
            self?.toggleAuthMode()
        }
        
        self.signUpViewModel.onCancelTapped = { [weak self] in
            self?.toggleAuthMode()
        }
        
        // Настройка замыкания для GoogleSignInViewModel
        self.googleSignInViewModel.onSuccess = { [weak self] in
            self?.handleAuthSuccess()
            print("✅ Успешная авторизация через Google!")
        }
        
    }
    
    func toggleAuthMode() {
        isLoginShown.toggle()
    }
    
    func handleAuthSuccess() {
        onAuthSuccess?()
    }
}
