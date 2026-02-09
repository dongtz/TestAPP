//
//  String+Ext.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

extension String {
    
    /// 判断字符串是否为空或只包含空白字符
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// 判断字符串是否不为空
    var isNotBlank: Bool {
        !isBlank
    }
    
    /// 验证是否是有效的手机号码（中国大陆）
    var isValidPhoneNumber: Bool {
        let pattern = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 验证是否是有效的邮箱地址
    var isValidEmail: Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 转换为Double类型
    var toDouble: Double? {
        Double(self)
    }
    
    /// 转换为Int类型
    var toInt: Int? {
        Int(self)
    }
    
    /// 格式化金额显示（添加千分位分隔符）
    func formatAsCurrency() -> String {
        guard let value = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? self
    }
}

extension Double {
    
    /// 格式化为金额字符串（保留2位小数）
    var toCurrencyString: String {
        String(format: "%.2f", self)
    }
    
    /// 格式化为百分比字符串（保留1位小数）
    var toPercentageString: String {
        String(format: "%.1f%%", self)
    }
    
    /// 格式化为千分位金额字符串
    var toFormattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? toCurrencyString
    }
}

extension Int {
    
    /// 格式化为千分位字符串
    var toFormattedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}






