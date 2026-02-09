//
//  AnalyticsData.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 分析维度
enum AnalyticsPeriod: String, Codable, CaseIterable {
    case day = "日"
    case week = "周"
    case month = "月"
}

/// 销售趋势数据点
struct SalesTrendPoint: Codable, Sendable {
    var time: String  // 时间标签，如 "09:00" 或 "12-20"
    var value: Double // 销售额
    var label: String // 显示标签
}

/// 品类销售数据
struct CategorySales: Codable, Sendable {
    var category: String  // 品类名称
    var amount: Double    // 销售额
    var percentage: Double // 占比百分比
    var icon: String      // 图标emoji
}

/// 热销商品数据
struct TopProduct: Codable, Sendable {
    var rank: Int        // 排名
    var productId: String
    var productName: String
    var salesCount: Int  // 销售数量
    var salesAmount: Double // 销售金额
}

/// 分析数据模型
struct AnalyticsData: Codable, Sendable {
    /// 分析维度
    var period: String
    /// 销售趋势数据（按时间点）
    var salesTrend: [SalesTrendPoint]
    /// 分品类销售数据
    var categorySales: [CategorySales]
    /// 热销商品TOP5
    var topProducts: [TopProduct]
    /// 总销售额
    var totalSales: Double
    /// 总订单数
    var totalOrders: Int
    /// 平均客单价
    var avgOrderValue: Double
    /// 同比增长率
    var yearOverYearGrowth: Double
    /// 环比增长率
    var monthOverMonthGrowth: Double
}
