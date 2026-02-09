//
//  KeychainManager.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import Security

/// Keychain管理器，用于安全存储敏感信息
class KeychainManager {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    /// 保存数据到Keychain
    /// - Parameters:
    ///   - data: 要保存的数据
    ///   - key: 存储的键
    /// - Returns: 是否保存成功
    @discardableResult
    func save(_ data: Data, forKey key: String) -> Bool {
        // 先删除旧数据
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// 保存字符串到Keychain
    /// - Parameters:
    ///   - string: 要保存的字符串
    ///   - key: 存储的键
    /// - Returns: 是否保存成功
    @discardableResult
    func save(_ string: String, forKey key: String) -> Bool {
        guard let data = string.data(using: .utf8) else { return false }
        return save(data, forKey: key)
    }
    
    /// 从Keychain读取数据
    /// - Parameter key: 存储的键
    /// - Returns: 读取的数据，如果不存在则返回nil
    func load(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    /// 从Keychain读取字符串
    /// - Parameter key: 存储的键
    /// - Returns: 读取的字符串，如果不存在则返回nil
    func loadString(forKey key: String) -> String? {
        guard let data = load(forKey: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 从Keychain删除数据
    /// - Parameter key: 存储的键
    /// - Returns: 是否删除成功
    @discardableResult
    func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    /// 清空所有Keychain数据
    @discardableResult
    func clearAll() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

// MARK: - 便捷方法

extension KeychainManager {
    
    /// 保存认证Token
    func saveAuthToken(_ token: String) -> Bool {
        save(token, forKey: AppConstants.KeychainKeys.authToken)
    }
    
    /// 获取认证Token
    func getAuthToken() -> String? {
        loadString(forKey: AppConstants.KeychainKeys.authToken)
    }
    
    /// 删除认证Token
    func deleteAuthToken() -> Bool {
        delete(forKey: AppConstants.KeychainKeys.authToken)
    }
    
    /// 保存刷新Token
    func saveRefreshToken(_ token: String) -> Bool {
        save(token, forKey: AppConstants.KeychainKeys.refreshToken)
    }
    
    /// 获取刷新Token
    func getRefreshToken() -> String? {
        loadString(forKey: AppConstants.KeychainKeys.refreshToken)
    }
}






