//
//  GoogleSignInButton.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import SwiftUI

struct GoogleSignInButton: View {
    let viewModel = GoogleSignInViewModel()
    var onSuccess: () -> Void = {}

    var body: some View {
        Button(action: {
            viewModel.signInWithGoogle { result in
                switch result {
                case .success:
                    print("✅ Google авторизация успешна!")
                    onSuccess()
                case .failure(let error):
                    print("❌ Ошибка входа: \(error.localizedDescription)")
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
    }
}

