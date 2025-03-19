//
//  SignUpViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation
import FirebaseAuth

protocol SignUpViewModelDelegate {
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) async
}

final class SignUpViewModel: SignUpViewModelDelegate {
    
    private let authService: IAuthService
    private let userDefaultsRepository: IUserDefaultsRepository
    
    init(authService: IAuthService, userDefaultsRepository: IUserDefaultsRepository) {
            self.authService = authService
            self.userDefaultsRepository = userDefaultsRepository
        }
    
  
  
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            
            let result = await authService.signUpWithEmailPassword(email: email, password: password)
            
        
                switch result {
                case .success:
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            
        }
    }
}
