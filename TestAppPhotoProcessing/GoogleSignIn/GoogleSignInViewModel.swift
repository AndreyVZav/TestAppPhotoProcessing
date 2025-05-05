//
//  GoogleSignInViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//
import Foundation
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore
import UIKit

final class GoogleSignInViewModel: ObservableObject {
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    var onSuccess: () -> Void = {}
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            handleError("Не удалось получить Client ID")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                self.handleError(error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.handleError("Не удалось получить токен")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _ , error in
                if let error = error {
                    self.handleError(error.localizedDescription)
                } else {
                    self.onSuccess()
                }
            }
        }
    }
    
    private func handleError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
            self.showErrorAlert = true
        }
    }
    
}

