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
    
    init(loginViewModel: LoginViewModel, signUpViewModel: SignUpViewModel, onAuthSuccess: (() -> Void)? = nil) {
        self.loginViewModel = loginViewModel
        self.signUpViewModel = signUpViewModel
        self.onAuthSuccess = onAuthSuccess
    }
    
    func toggleAuthMode() {
        isLoginShown.toggle()
    }
    
    func handleAuthSuccess() {
        onAuthSuccess?()
    }
}
