//
//  AppRootViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 20.03.2025.
//
import SwiftUI
import Combine

class AppRootViewModel: ObservableObject {
    @Published var isAuthenticated = false
    let authContainerViewModel: AuthContainerViewModel
    
    init() {
        let loginVM = LoginViewModel(Dependencies.shared)
        let signUpVM = SignUpViewModel(Dependencies.shared)
        
        self.authContainerViewModel = AuthContainerViewModel(
            loginViewModel: loginVM,
            signUpViewModel: signUpVM
        )
        
        // передаём замыкание авторизации
        self.authContainerViewModel.onAuthSuccess = { [weak self] in
            self?.setAuthenticated(true)
        }
    }
    
    func setAuthenticated(_ isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
