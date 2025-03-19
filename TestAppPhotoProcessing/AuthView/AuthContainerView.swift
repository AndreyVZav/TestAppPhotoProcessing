//
//  AuthContainerView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct AuthContainerView: View {
    @StateObject private var viewModel: AuthContainerViewModel
    
    init(onAuthSuccess: (() -> Void)? = nil) {
        let loginViewModel = LoginViewModel(Dependencies.shared)
        let signUpViewModel = SignUpViewModel(Dependencies.shared)
        _viewModel = StateObject(wrappedValue: AuthContainerViewModel(
            loginViewModel: loginViewModel,
            signUpViewModel: signUpViewModel,
            onAuthSuccess: onAuthSuccess
        ))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoginShown {
                LoginView(
                    viewModel: viewModel.loginViewModel,
                    onLoginSuccess: {
                        viewModel.handleAuthSuccess()
                        print("✅ Пользователь вошел в систему")
                    },
                    onCancelTapped: {
                        viewModel.toggleAuthMode()
                    }
                )
            } else {
                SignUpView(
                    viewModel: viewModel.signUpViewModel,
                    onSignUpSuccess: {
                        print("✅ Пользователь зарегистрировался")
                        viewModel.handleAuthSuccess()
                    },
                    onCancelTapped: {
                        viewModel.toggleAuthMode()
                    }
                )
            }
            
            GoogleSignInButton(viewModel: viewModel.googleSignInViewModel)
            
        }
        .animation(.easeInOut, value: viewModel.isLoginShown)
        .transition(.slide)
        
        
    }
}

