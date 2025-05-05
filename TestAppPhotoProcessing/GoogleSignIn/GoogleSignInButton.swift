//
//  GoogleSignInButton.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

struct GoogleSignInButton: View {
    @StateObject var viewModel: GoogleSignInViewModel
    
    var body: some View {
        Button(action: {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                viewModel.errorMessage = "Не удалось получить UIViewController"
                viewModel.showErrorAlert = true
                return
            }
            
            viewModel.signInWithGoogle(presenting: rootViewController)
            
        }) {
            HStack {
                Image(systemName: "globe")
                Text("Sign in with Google")
                    .bold()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(12)
        }
        .alert("Ошибка", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        
    }
}

