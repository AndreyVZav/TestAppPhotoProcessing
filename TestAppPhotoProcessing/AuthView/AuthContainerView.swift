//
//  AuthContainerView.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import SwiftUI

struct AuthContainerView: View {
    @StateObject var viewModel: AuthContainerViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoginShown {
                LoginView(viewModel: viewModel.loginViewModel)
            } else {
                SignUpView(viewModel: viewModel.signUpViewModel)
            }
            
            GoogleSignInButton(viewModel: viewModel.googleSignInViewModel)
            
        }
        .animation(.easeInOut, value: viewModel.isLoginShown)
        .transition(.slide)
        
        
    }
}

