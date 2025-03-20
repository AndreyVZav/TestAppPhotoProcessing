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
    var onSuccess: (() -> Void) = {}
    
    func signInWithGoogle(presenting viewController: UIViewController, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить Client ID"])))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить токен"])))
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let authResult = authResult {
                    completion(.success(authResult))
                }
            }
        }
    }
}

