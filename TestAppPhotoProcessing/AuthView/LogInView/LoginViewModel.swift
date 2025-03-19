//
//  LoginViewModel.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelDelegate: AnyObject {
    func login(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
}


final class LoginViewModel: LoginViewModelDelegate {
    private let authService: IAuthService
    private let userDefaultsRepository: IUserDefaultsRepository
//    private let usersModel = UsersModel.shared
    
    init(_ dependencies: IDependencies) {
        self.authService = dependencies.authService
        self.userDefaultsRepository = dependencies.userDefaultsRepository
    }
    
    func login(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        
//        if let user = usersModel.findUser(byUsername: email), user.password == password {
//            print("✅ Локальная авторизация успешна!")
//            completion(.success(true))
//            return
//        }
        
        Task {
            let result = await authService.logInWithEmail(email: email, password: password)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

