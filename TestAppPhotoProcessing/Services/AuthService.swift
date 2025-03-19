//
//  AuthService.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation
import FirebaseAuth

protocol IAuthService {
    var authenticationStateChanged: ((AuthenticationState) -> Void)? { get set }
    func registerAuthStateHandler()
    func wait() async
    func logInWithEmail(email: String, password: String) async -> Result<Bool, AuthError>
    func signUpWithEmailPassword(email: String, password: String) async -> Result<Bool, AuthError>
    func getCurrentUserId(completion: @escaping (Int?) -> Void)
    func signOut()
    func deleteAccount() async -> Bool
}

struct AuthService: IAuthService {
    var authenticationStateChanged: ((AuthenticationState) -> Void)?
    private var userDefaultsRepository: IUserDefaultsRepository
    private static var authStateHandler: AuthStateDidChangeListenerHandle?

    init(userDefaultsRepository: IUserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func registerAuthStateHandler() {
        if AuthService.authStateHandler == nil {
            AuthService.authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
                let newState: AuthenticationState = user == nil ? .unauthenticated : .authenticated
                authenticationStateChanged?(newState)
            }
        }
    }

    func wait() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getCurrentUserId(completion: @escaping (Int?) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(nil)
            return
        }
        let id = generateIntID(from: email)
        completion(id)
    }

    func logInWithEmail(email: String, password: String) async -> Result<Bool, AuthError> {
        authenticationStateChanged?(.authenticating)
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            authenticationStateChanged?(.authenticated)
            
            // Сохраняем данные пользователя
            userDefaultsRepository.setIsAuthenticatedUser(true)
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(password, forKey: "userPassword")
            
            return .success(true)
        } catch {
            authenticationStateChanged?(.unauthenticated)
            return .failure(AuthError.map(error))
        }
    }

    func signUpWithEmailPassword(email: String, password: String) async -> Result<Bool, AuthError> {
        authenticationStateChanged?(.authenticating)
        
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            authenticationStateChanged?(.authenticated)
            
            // Сохраняем данные пользователя
            userDefaultsRepository.setIsAuthenticatedUser(true)
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(password, forKey: "userPassword")
            
            return .success(true)
        } catch {
            authenticationStateChanged?(.unauthenticated)
            return .failure(AuthError.map(error))
        }
    }
    

    func signOut() {
        do {
            
            try Auth.auth().signOut()
            authenticationStateChanged?(.unauthenticated)
            userDefaultsRepository.setIsAuthenticatedUser(false)
            print(userDefaultsRepository.isAuthenticatedUser())
            print("I got signed out")
        } catch {
            print("Sign out error: \(error)")
        }
    }

    func deleteAccount() async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        
        do {
            try await user.delete()
            authenticationStateChanged?(.unauthenticated)
            userDefaultsRepository.setIsAuthenticatedUser(false)
            return true
        } catch {
            return false
        }
    }
    
    private func generateIntID(from string: String) -> Int {
            return abs(string.hashValue)
        }

}
