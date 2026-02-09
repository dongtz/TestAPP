//
//  DashboardData.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 数据看板模型
struct DashboardData: Codable, Sendable {
    /// 今日销售额
    var todaySales: Double
    /// 昨日销售额
    var yesterdaySales: Double
    /// 今日客流量
    var todayTraffic: Int
    /// 昨日客流量
    var yesterdayTraffic: Int
    /// 今日成交单数
    var todayOrders: Int
    /// 昨日成交单数
    var yesterdayOrders: Int
    /// 今日客单价
    var todayAvgOrderValue: Double
    /// 昨日客单价
    var yesterdayAvgOrderValue: Double
    /// 转化率（百分比）
    var conversionRate: Double
    /// 昨日转化率
    var yesterdayConversionRate: Double
    /// 本店排名
    var storeRanking: Int
    /// 总门店数
    var totalStores: Int
    /// 本月销售额
    var monthSales: Double
    /// 本月目标
    var monthTarget: Double
    /// 待处理订单数
    var pendingOrders: Int
    /// 库存预警数量
    var lowStockCount: Int
    /// 待跟进客户数
    var pendingCustomers: Int
    
    /// 销售额同比变化（百分比）
    var salesChangeRate: Double {
        guard yesterdaySales > 0 else { return 0 }
        return ((todaySales - yesterdaySales) / yesterdaySales) * 100
    }
    
    /// 客流量同比变化（百分比）
    var trafficChangeRate: Double {
        guard yesterdayTraffic > 0 else { return 0 }
        return Double((todayTraffic - yesterdayTraffic)) / Double(yesterdayTraffic) * 100
    }
    
    /// 成交单数同比变化（百分比）
    var ordersChangeRate: Double {
        guard yesterdayOrders > 0 else { return 0 }
        return Double((todayOrders - yesterdayOrders)) / Double(yesterdayOrders) * 100
    }
    
    /// 月度目标完成率（百分比）
    var monthTargetRate: Double {
        guard monthTarget > 0 else { return 0 }
        return (monthSales / monthTarget) * 100
    }
}
