//
//  UserDefaultsRepository.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation

protocol IUserDefaultsRepository {
       var isRegistredUserBefore: Bool { get }
       func setIsAuthenticatedUser(_ authenticated: Bool)
       func isAuthenticatedUser() -> Bool
       
}

struct UserDefaultsRepository: IUserDefaultsRepository {

    
    private let container: UserDefaults
    
    init(container: UserDefaults) {
        self.container = container
    }
       
       var isRegistredUserBefore: Bool {
           return container.bool(forKey: UserDefaultsKey.isRegistredUser)
       }

       func isAuthenticatedUser() -> Bool {
           return container.bool(forKey: UserDefaultsKey.isAuthUser)
       }
       
       func setIsAuthenticatedUser(_ authenticated: Bool) {
           container.set(authenticated, forKey: UserDefaultsKey.isAuthUser)
       }
       
    
}
