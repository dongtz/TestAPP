//
//  UserManager.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import Combine

/// 用户信息管理器
/// 管理当前登录用户信息和门店信息
@MainActor
class UserManager: ObservableObject {
    
    static let shared = UserManager()
    
    @Published var currentUser: User?
    @Published var currentStoreId: String?
    
    private init() {
        loadCurrentUser()
    }
    
    /// 加载当前用户信息
    private func loadCurrentUser() {
        // 从UserDefaults获取当前门店ID
        if let storeId = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.currentStoreId) {
            currentStoreId = storeId
        } else {
            // 默认使用门店ID "1"
            currentStoreId = "1"
        }
    }
    
    /// 获取当前门店ID（非MainActor版本，供actor调用）
    nonisolated func getCurrentStoreId() -> String {
        // 从UserDefaults直接读取，避免MainActor隔离
        if let storeId = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.currentStoreId) {
            return storeId
        }
        return "1"
    }
    
    /// 设置当前用户
    func setCurrentUser(_ user: User, token: String? = nil) {
        currentUser = user
        currentStoreId = user.storeId
        
        // 保存到UserDefaults
        UserDefaults.standard.set(user.storeId, forKey: AppConstants.UserDefaultsKeys.currentStoreId)
        UserDefaults.standard.set(user.id, forKey: AppConstants.UserDefaultsKeys.currentUserId)
        
        // 保存Token到Keychain（如果提供）
        if let token = token, !token.isEmpty {
            _ = KeychainManager.shared.saveAuthToken(token)
        }
    }
    
    /// 设置认证Token
    func setAuthToken(_ token: String) {
        _ = KeychainManager.shared.saveAuthToken(token)
    }
    
    /// 清除用户信息
    func clearUser() {
        currentUser = nil
        currentStoreId = nil
        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.currentStoreId)
        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaultsKeys.currentUserId)
        _ = KeychainManager.shared.deleteAuthToken()
    }
}

