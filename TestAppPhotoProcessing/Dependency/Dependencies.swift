//
//  Dependencies.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 19.03.2025.
//

import Foundation

protocol IDependencies {
    var authService: IAuthService { get }
    var userDefaultsRepository: IUserDefaultsRepository { get }
}

final class Dependencies: IDependencies {
    static let shared = Dependencies()

    lazy var authService: IAuthService = {
            return AuthService(userDefaultsRepository: self.userDefaultsRepository)
        }()
    
    let userDefaultsRepository: IUserDefaultsRepository

    private init() {
        
        self.userDefaultsRepository = UserDefaultsRepository(container: .standard)
    }
}
