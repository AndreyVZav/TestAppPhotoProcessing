//
//  KeychainService.swift
//  TestAppPhotoProcessing
//
//  Created by Андрей Завадский on 01.05.2025.
//

import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private init() {}
    
    func save(password: String, for email: String) {
        let data = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : email,
            kSecValueData as String   : data
        ]
        
        SecItemDelete(query as CFDictionary) // удалить если уже есть
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func getPassword(for email: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : email,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr,
           let data = dataTypeRef as? Data,
           let password = String(data: data, encoding: .utf8) {
            return password
        }
        return nil
    }
    
    func deletePassword(for email: String) {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : email
        ]
        SecItemDelete(query as CFDictionary)
    }
}
