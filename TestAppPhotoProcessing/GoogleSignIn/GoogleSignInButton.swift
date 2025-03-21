//
//  GoogleSignInButton.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

struct GoogleSignInButton: View {
    @StateObject var viewModel: GoogleSignInViewModel
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    var onAuthSuccess: () -> Void
    
    var body: some View {
        Button(action: {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                errorMessage = "Не удалось получить UIViewController"
                showErrorAlert = true
                return
            }
            
            viewModel.signInWithGoogle(presenting: rootViewController) { result in
                switch result {
                case .success:
                    print("✅ Google авторизация успешна!")
                    onAuthSuccess()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
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
        .alert("Ошибка", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        
    }
}

