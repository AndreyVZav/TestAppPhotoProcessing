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
    @Published var isLoading = true
    
    let authContainerViewModel: AuthContainerViewModel
    let imageEditorViewModel = ImageEditorViewModel()
    
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
        
        // Симуляция проверки авторизации (например, из Keychain)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // здесь могла бы быть реальная проверка
            self.isLoading = false
        }
        
    }
    
    func setAuthenticated(_ isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
