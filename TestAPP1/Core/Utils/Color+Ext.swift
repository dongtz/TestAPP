//
//  Color+Ext.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

extension Color {
    
    // MARK: - 主题色
    
    /// 主色 - 科技蓝
    static let appPrimary = Color(hex: ThemeColors.primary)
    
    /// 辅助色 - 橙色
    static let appAccent = Color(hex: ThemeColors.accent)
    
    /// 成功色 - 绿色
    static let appSuccess = Color(hex: ThemeColors.success)
    
    /// 警告色 - 红色
    static let appWarning = Color(hex: ThemeColors.warning)
    
    // MARK: - 中性色
    
    /// 文本主色
    static let textPrimary = Color.primary
    
    /// 文本次要色
    static let textSecondary = Color.secondary
    
    /// 文本禁用色
    static let textDisabled = Color.gray.opacity(0.5)
    
    /// 背景色
    static let appBackground = Color(uiColor: .systemGroupedBackground)
    
    /// 卡片背景色
    static let cardBackground = Color(uiColor: .secondarySystemGroupedBackground)
    
    /// 分割线颜色
    static let divider = Color(uiColor: .separator)
    
    // MARK: - 语义化颜色
    
    /// 上涨颜色（红色）
    static let priceUp = Color.red
    
    /// 下跌颜色（绿色）
    static let priceDown = Color.green
    
    /// 中性颜色（灰色）
    static let neutral = Color.gray
    
    // MARK: - 辅助方法
    
    /// 从十六进制字符串创建颜色
    /// - Parameter hex: 十六进制颜色字符串，如 "#007AFF" 或 "007AFF"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - 预定义的主题色值（用于Assets Catalog）

/// 主题色配置（用于在Assets中创建颜色）
enum ThemeColors {
    static let primary = "#007AFF"       // 主色 - 科技蓝
    static let accent = "#FF6B00"        // 辅助色 - 橙色
    static let success = "#34C759"       // 成功色 - 绿色
    static let warning = "#FF3B30"       // 警告色 - 红色
    
    static let textPrimary = "#000000"   // 文本主色（浅色模式）
    static let textSecondary = "#666666" // 文本次要色
    static let textDisabled = "#CCCCCC"  // 文本禁用色
    
    static let background = "#F5F5F5"    // 背景色
    static let cardBackground = "#FFFFFF" // 卡片背景色
    static let divider = "#E5E5E5"       // 分割线颜色
}

