//
//  AnalyticsDTO.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 小时销售数据DTO（服务端实际返回格式）
struct HourlySalesDTO: Codable, Sendable {
    var hour: Int           // 小时
    var salesAmount: Double  // 销售额
    var orderCount: Int     // 订单数
}

/// 销售趋势数据点DTO（用于转换）
struct SalesTrendPointDTO: Codable, Sendable {
    var hour: Int?          // 小时（日维度）
    var date: String?      // 日期（周/月维度）
    var sales: Double       // 销售额
    var orders: Int?        // 订单数
}

/// 品类销售DTO
struct CategorySalesDTO: Codable, Sendable {
    var categoryId: Int?         // 品类ID（可选）
    var category: String?         // 品类名称（可选，兼容旧格式）
    var categoryName: String?     // 品类名称（服务端实际返回）
    var sales: Double?            // 销售额（可选，兼容旧格式）
    var salesAmount: Double?      // 销售额（服务端实际返回）
    var percentage: Double?       // 占比百分比（可选）
    var orderCount: Int?          // 订单数（可选）
    
    // 获取品类名称（优先使用categoryName，其次category）
    var name: String {
        categoryName ?? category ?? "其他"
    }
    
    // 获取销售额（优先使用salesAmount，其次sales）
    var amount: Double {
        salesAmount ?? sales ?? 0
    }
    
    // 自定义解码，支持多种字段名
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 所有字段都是可选的
        categoryId = try? container.decodeIfPresent(Int.self, forKey: .categoryId)
        category = try? container.decodeIfPresent(String.self, forKey: .category)
        categoryName = try? container.decodeIfPresent(String.self, forKey: .categoryName)
        sales = try? container.decodeIfPresent(Double.self, forKey: .sales)
        salesAmount = try? container.decodeIfPresent(Double.self, forKey: .salesAmount)
        percentage = try? container.decodeIfPresent(Double.self, forKey: .percentage)
        orderCount = try? container.decodeIfPresent(Int.self, forKey: .orderCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case category
        case categoryName
        case sales
        case salesAmount
        case percentage
        case orderCount
    }
}

/// 热销商品DTO
struct TopProductDTO: Codable, Sendable {
    var productId: String        // 商品ID（可能是String或Int，统一转为String）
    var productName: String      // 商品名称
    var sales: Double?           // 销售金额（兼容旧格式）
    var salesAmount: Double?     // 销售金额（服务端实际返回）
    var quantity: Int            // 销售数量
    var orderCount: Int?         // 订单数（可选）
    
    // 获取销售金额（优先使用salesAmount，其次sales）
    var amount: Double {
        salesAmount ?? sales ?? 0
    }
    
    // 自定义解码，支持多种字段名和类型
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // productId可能是Int或String
        if let productIdInt = try? container.decode(Int.self, forKey: .productId) {
            productId = String(productIdInt)
        } else {
            productId = try container.decode(String.self, forKey: .productId)
        }
        
        productName = try container.decode(String.self, forKey: .productName)
        sales = try? container.decodeIfPresent(Double.self, forKey: .sales)
        salesAmount = try? container.decodeIfPresent(Double.self, forKey: .salesAmount)
        quantity = try container.decode(Int.self, forKey: .quantity)
        orderCount = try? container.decodeIfPresent(Int.self, forKey: .orderCount)
    }
    
    enum CodingKeys: String, CodingKey {
        case productId
        case productName
        case sales
        case salesAmount
        case quantity
        case orderCount
    }
}

/// 客流量数据DTO
struct TrafficByHourDTO: Codable, Sendable {
    var hour: Int           // 小时
    var traffic: Int        // 客流量
}

/// 分析数据响应DTO（匹配服务端实际返回格式）
struct AnalyticsDataDTO: Codable, Sendable {
    // 服务端实际返回的字段
    var date: String?                    // 日期（日维度）
    var year: Int?                       // 年份（月维度）
    var month: Int?                      // 月份（月维度）
    var hourlySales: [HourlySalesDTO]?   // 小时销售数据（日维度）
    
    // 其他可选字段
    var dailySales: [DailySalesDTO]?      // 日销售数据（周/月维度）
    var categorySales: [CategorySalesDTO]? // 分品类销售（可选）
    var topProducts: [TopProductDTO]?     // 热销商品（可选）
    var trafficByHour: [TrafficByHourDTO]? // 客流量（可选）
    
    // 兼容文档中的字段名（如果服务端后续更新）
    var period: String?
    var startDate: String?
    var endDate: String?
    var salesTrend: [SalesTrendPointDTO]?
    
    enum CodingKeys: String, CodingKey {
        case date
        case year
        case month
        case hourlySales
        case dailySales
        case categorySales
        case topProducts
        case trafficByHour
        case period
        case startDate
        case endDate
        case salesTrend
    }
    
    // 自定义解码，同时支持camelCase和snake_case
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 正常解码的字段
        date = try? container.decodeIfPresent(String.self, forKey: .date)
        year = try? container.decodeIfPresent(Int.self, forKey: .year)
        month = try? container.decodeIfPresent(Int.self, forKey: .month)
        hourlySales = try? container.decodeIfPresent([HourlySalesDTO].self, forKey: .hourlySales)
        dailySales = try? container.decodeIfPresent([DailySalesDTO].self, forKey: .dailySales)
        trafficByHour = try? container.decodeIfPresent([TrafficByHourDTO].self, forKey: .trafficByHour)
        period = try? container.decodeIfPresent(String.self, forKey: .period)
        startDate = try? container.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try? container.decodeIfPresent(String.self, forKey: .endDate)
        salesTrend = try? container.decodeIfPresent([SalesTrendPointDTO].self, forKey: .salesTrend)
        
        // categorySales: 先尝试camelCase，再尝试snake_case
        if let categorySalesData = try? container.decodeIfPresent([CategorySalesDTO].self, forKey: .categorySales) {
            categorySales = categorySalesData
        } else {
            // 尝试snake_case
            let snakeCaseContainer = try decoder.container(keyedBy: SnakeCaseCodingKeys.self)
            categorySales = try? snakeCaseContainer.decodeIfPresent([CategorySalesDTO].self, forKey: .categorySales)
        }
        
        // topProducts: 先尝试camelCase，再尝试snake_case
        if let topProductsData = try? container.decodeIfPresent([TopProductDTO].self, forKey: .topProducts) {
            topProducts = topProductsData
        } else {
            // 尝试snake_case
            let snakeCaseContainer = try decoder.container(keyedBy: SnakeCaseCodingKeys.self)
            topProducts = try? snakeCaseContainer.decodeIfPresent([TopProductDTO].self, forKey: .topProducts)
        }
    }
    
    // Snake_case的CodingKeys
    enum SnakeCaseCodingKeys: String, CodingKey {
        case date
        case hourlySales = "hourly_sales"
        case dailySales = "daily_sales"
        case categorySales = "category_sales"
        case topProducts = "top_products"
        case trafficByHour = "traffic_by_hour"
        case period
        case startDate = "start_date"
        case endDate = "end_date"
        case salesTrend = "sales_trend"
    }
}

/// 日销售数据DTO（周/月维度）
struct DailySalesDTO: Codable, Sendable {
    var day: Int?          // 天数（月维度：1-31，服务端实际返回）
    var date: String?      // 日期字符串（周维度，兼容旧格式）
    var salesAmount: Double // 销售额
    var orderCount: Int    // 订单数
    
    // 获取日期字符串（优先使用date，如果没有则根据day计算）
    func getDateString(year: Int? = nil, month: Int? = nil) -> String {
        if let date = date, !date.isEmpty {
            return date
        }
        
        // 如果有day，根据year和month计算日期
        if let day = day, let year = year, let month = month {
            let calendar = Calendar.current
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            
            if let date = calendar.date(from: components) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: date)
            }
        }
        
        return ""
    }
}
