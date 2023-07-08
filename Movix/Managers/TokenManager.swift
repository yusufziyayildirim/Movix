//
//  TokenManager.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation
import Security

final class TokenManager{
    
    static let shared = TokenManager()
    
    private init (){}
    
    func saveBearerTokenToKeychain(token: String){
        deleteBearerTokenFromKeychain()
        
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ysfyldrm.Movix",
            kSecAttrAccount as String: "BearerToken",
            kSecValueData as String: token.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            let bearerToken = "Bearer \(token)"
        } else {
            print("Failed to save bearer token to Keychain")
        }
    }
    
    func getBearerTokenFromKeychain() -> String {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ysfyldrm.Movix",
            kSecAttrAccount as String: "BearerToken",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        
        if status == errSecSuccess, let tokenData = result as? Data, let token = String(data: tokenData, encoding: .utf8) {
            return token
        } else {
            print(errSecSuccess)
            return ""
        }
    }
    
    func deleteBearerTokenFromKeychain() {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.ysfyldrm.Movix",
            kSecAttrAccount as String: "BearerToken"
        ]
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        
        if status != errSecSuccess {
            print(status)
        }
    }
    
}
