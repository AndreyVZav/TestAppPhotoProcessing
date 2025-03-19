//
//  AuthContainerView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct AuthContainerView: View {
    @State private var isLoginShown = true
    var onAuthSuccess: (() -> Void)?
    
    private let loginViewModel = LoginViewModel(Dependencies.shared)
    private let signUpViewModel = SignUpViewModel(
        authService: Dependencies.shared.authService,
        userDefaultsRepository: Dependencies.shared.userDefaultsRepository
    )
    
    var body: some View {
        VStack {
            if isLoginShown {
                LoginView(
                    viewModel: loginViewModel,
                    onLoginSuccess: {
                        onAuthSuccess?()
                        print("✅ Пользователь вошел в систему")
                    },
                    onCancelTapped: {
                        isLoginShown = false // Переход на регистрацию
                    }
                )
            } else {
                SignUpView(
                    viewModel: signUpViewModel,
                    onSignUpSuccess: {
                        print("✅ Пользователь зарегистрировался")
                        onAuthSuccess?()
                    },
                    onCancelTapped: {
                        isLoginShown = true // Вернуться на логин
                    }
                )
            }
        }
        .animation(.easeInOut, value: isLoginShown)
        .transition(.slide)
        
        GoogleSignInButton {
            print("Переход на главный экран после входа")
        }
        
    }
}
