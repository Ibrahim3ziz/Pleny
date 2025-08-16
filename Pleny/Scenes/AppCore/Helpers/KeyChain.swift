//
//  KeyChain.swift
//  Pleny
//
//  Created by Ibrahim Abdul Aziz on 16/08/2025.
//

import Foundation
import Security

struct KeyChain {
    
    static func save<T: Codable>(object: T, key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            save(data: data, key: key)
        } catch {
            print("❌ Failed to encode object for key \(key): \(error)")
        }
    }
    
    static func save(data: Data, key: String) {
        
        let key = "\(Bundle.main.bundleIdentifier ?? "")_\(key)"
        
        delete(key: key) // Delete old if exists
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        print(query)
        
        let resultCode: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        if resultCode == 0 {
            print("Keychain: value added successfully")
        } else {
            print("Keychain: value not added - Error: \(resultCode)")
        }
    }
    
    static func read(key: String) -> Data? {
        
        let key = "\(Bundle.main.bundleIdentifier ?? "")_\(key)"
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : true,
            kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("Keychain: unable to load data - \(status)")
            return nil
        }
        return result as? Data
    }
    
    static func read<T: Codable>(objectType: T.Type, key: String) -> T? {
        guard let data = read(key: key) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Failed to decode object for key \(key): \(error)")
            return nil
        }
    }
    
    static func delete(key: String) {
        
        let key = "\(Bundle.main.bundleIdentifier ?? "")_\(key)"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        if status == 0 {
            print( "Keychain: value deleted successfully")
        } else {
            print("Keychain: value not deleted - Error: \(status)")
        }
    }
}
