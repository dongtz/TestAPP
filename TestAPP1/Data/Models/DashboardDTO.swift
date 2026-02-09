//
//  DashboardDTO.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 今日核心指标DTO
struct DashboardTodayDTO: Codable, Sendable {
    var salesAmount: Double              // 今日销售额
    var yesterdaySalesAmount: Double    // 昨日销售额
    var customerCount: Int              // 今日客流量
    var orderCount: Int                 // 今日订单数
    var avgOrderAmount: Double          // 平均客单价
    var conversionRate: Double          // 转化率（百分比）
    var dayOverDayGrowth: Double        // 日环比增长率（百分比）
    var monthlyCompleted: Double        // 本月已完成销售额
    var monthlyTarget: Double           // 本月目标销售额
}

/// 门店排名DTO
struct DashboardRankingDTO: Codable, Sendable {
    var currentRank: Int                // 当前排名
    var totalStores: Int                // 总门店数
    var period: String?                 // 统计周期
}

/// 待办事项DTO
struct DashboardTodosDTO: Codable, Sendable {
    var pendingOrderCount: Int          // 待处理订单数
    var inventoryWarningCount: Int       // 库存预警数量
    var followUpCustomerCount: Int     // 待跟进客户数
}

/// 消息DTO
struct MessageDTO: Codable, Sendable {
    var id: String
    var title: String
    var content: String
    var messageType: String
    var isRead: Bool
    var createdAt: Date
}

/// 消息列表DTO
struct MessageListDTO: Codable, Sendable {
    var list: [MessageDTO]
    var total: Int
    var page: Int
    var pageSize: Int
}
