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
            viewModel.startGoogleSignInFlow()
        }) {
            HStack {
                Image(systemName: "globe")
                Text(Constants.signInWithGoogle)
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

