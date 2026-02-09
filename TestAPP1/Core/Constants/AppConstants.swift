//
//  AppConstants.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 应用全局常量配置
enum AppConstants: Sendable {
    
    // MARK: - 应用信息
    enum App {
        static let name = "3C零售通"
        static let version = "1.0.0"
        static let bundleIdentifier = "com.testapp1.retail"
    }
    
    // MARK: - 数据配置
    enum Data {
        /// 是否使用Mock数据（true=Mock, false=真实API）
        static let useMockData = false
        
        /// Dashboard是否使用真实API（true=API, false=Mock）
        /// 当useMockData为false时，此配置无效，所有模块都使用API
        static let dashboardUseAPI = true
        
        /// Analytics是否使用真实API（true=API, false=Mock）
        /// 当useMockData为false时，此配置无效，所有模块都使用API
        static let analyticsUseAPI = true
        
        /// 网络请求超时时间（秒）
        static let networkTimeout: TimeInterval = 30
        
        /// 缓存过期时间（秒）
        static let cacheExpireTime: TimeInterval = 3600
    }
    
    // MARK: - UI配置
    enum UI {
        /// 列表每页加载数量
        static let pageSize = 20
        
        /// 卡片圆角
        static let cardCornerRadius: CGFloat = 12
        
        /// 标准间距
        static let standardSpacing: CGFloat = 16
        
        /// 小间距
        static let smallSpacing: CGFloat = 8
        
        /// 大间距
        static let largeSpacing: CGFloat = 24
    }
    
    // MARK: - 业务配置
    enum Business {
        /// 库存预警阈值
        static let inventoryWarningThreshold = 10
        
        /// 低库存预警阈值
        static let lowInventoryThreshold = 5
        
        /// 客单价格式化
        static let priceDecimalPlaces = 2
    }
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let currentStoreId = "current_store_id"
        static let currentUserId = "current_user_id"
        static let userToken = "user_token"
        static let isDarkMode = "is_dark_mode"
        static let hasLaunchedBefore = "has_launched_before"
    }
    
    // MARK: - Keychain Keys
    enum KeychainKeys {
        static let authToken = "auth_token"
        static let refreshToken = "refresh_token"
        static let userPassword = "user_password"
    }
}

