//
//  DateFormatter+Ext.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

extension DateFormatter {
    
    /// 标准日期格式：2024-12-26
    static let standardDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    /// 标准日期时间格式：2024-12-26 14:30:00
    static let standardDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    /// 显示格式：12月26日
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    /// 显示格式：12月26日 14:30
    static let displayDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日 HH:mm"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    /// 时间格式：14:30
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    /// 年月格式：2024年12月
    static let yearMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
}

extension Date {
    
    /// 转换为标准日期字符串
    var toStandardDateString: String {
        DateFormatter.standardDate.string(from: self)
    }
    
    /// 转换为标准日期时间字符串
    var toStandardDateTimeString: String {
        DateFormatter.standardDateTime.string(from: self)
    }
    
    /// 转换为显示日期字符串
    var toDisplayDateString: String {
        DateFormatter.displayDate.string(from: self)
    }
    
    /// 转换为显示日期时间字符串
    var toDisplayDateTimeString: String {
        DateFormatter.displayDateTime.string(from: self)
    }
    
    /// 转换为时间字符串
    var toTimeString: String {
        DateFormatter.time.string(from: self)
    }
    
    /// 转换为年月字符串
    var toYearMonthString: String {
        DateFormatter.yearMonth.string(from: self)
    }
    
    /// 获取当天的开始时间
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    /// 获取当天的结束时间
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    /// 获取本周的开始时间
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 获取本月的开始时间
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    /// 判断是否是今天
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    /// 判断是否是昨天
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }
}






