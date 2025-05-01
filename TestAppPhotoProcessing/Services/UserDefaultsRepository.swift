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
    
    func setValue(_ value: Any?, forKey key: String)
    func getValue(forKey key: String) -> Any?
    func removeValue(forKey key: String)
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
    
    func setValue(_ value: Any?, forKey key: String) {
        container.setValue(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> Any? {
        container.value(forKey: key)
    }
    
    func removeValue(forKey key: String) {
        container.removeObject(forKey: key)
    }
    
}
