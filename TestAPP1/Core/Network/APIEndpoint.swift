//
//  APIEndpoint.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// API端点枚举
enum APIEndpoint: Sendable {
    case login
    case dashboardToday(storeId: String?)
    case dashboardRanking(storeId: String, period: String?)
    case dashboardTodos(storeId: String)
    case dashboardMessages(storeId: String?, employeeId: String?, isRead: Bool?, messageType: String?, page: Int?, pageSize: Int?)
    case stores
    case products
    case orders(storeId: String?, orderStatus: String?, startDate: String?, endDate: String?, keyword: String?, page: Int?, pageSize: Int?)
    case orderDetail(id: String)
    case createOrder
    case cancelOrder(id: String)
    case orderPaymentStats(storeId: String, startDate: String, endDate: String)
    case employees
    case customers
    case analytics(period: String, storeId: String?, startDate: String?, endDate: String?)
    
    /// 基础URL
    private var baseURL: String {
        // 开发环境使用本地服务
        #if DEBUG
        return "http://localhost:8080/api"
        #else
        return "https://api.example.com/api"
        #endif
    }
    
    /// 完整的URL路径
    var path: String {
        switch self {
        case .login:
            return "\(baseURL)/auth/login"
        case .dashboardToday(let storeId):
            var url = "\(baseURL)/dashboard/today"
            if let storeId = storeId, let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url += "?storeId=\(encoded)"
            }
            return url
        case .dashboardRanking(let storeId, let period):
            guard let encodedStoreId = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return "\(baseURL)/dashboard/ranking"
            }
            var url = "\(baseURL)/dashboard/ranking?storeId=\(encodedStoreId)"
            if let period = period, let encodedPeriod = period.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                url += "&period=\(encodedPeriod)"
            }
            return url
        case .dashboardTodos(let storeId):
            guard let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return "\(baseURL)/dashboard/todos"
            }
            return "\(baseURL)/dashboard/todos?storeId=\(encoded)"
        case .dashboardMessages(let storeId, let employeeId, let isRead, let messageType, let page, let pageSize):
            var url = "\(baseURL)/dashboard/messages"
            var params: [String] = []
            if let storeId = storeId, let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("storeId=\(encoded)")
            }
            if let employeeId = employeeId, let encoded = employeeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("employeeId=\(encoded)")
            }
            if let isRead = isRead {
                params.append("isRead=\(isRead)")
            }
            if let messageType = messageType, let encoded = messageType.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("messageType=\(encoded)")
            }
            if let page = page {
                params.append("page=\(page)")
            }
            if let pageSize = pageSize {
                params.append("pageSize=\(pageSize)")
            }
            if !params.isEmpty {
                url += "?" + params.joined(separator: "&")
            }
            return url
        case .stores:
            return "\(baseURL)/stores"
        case .products:
            return "\(baseURL)/products"
        case .orders(let storeId, let orderStatus, let startDate, let endDate, let keyword, let page, let pageSize):
            var url = "\(baseURL)/orders"
            var params: [String] = []
            if let storeId = storeId, let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("storeId=\(encoded)")
            }
            if let orderStatus = orderStatus, let encoded = orderStatus.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("orderStatus=\(encoded)")
            }
            if let startDate = startDate, let encoded = startDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("startDate=\(encoded)")
            }
            if let endDate = endDate, let encoded = endDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("endDate=\(encoded)")
            }
            if let keyword = keyword, let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("keyword=\(encoded)")
            }
            if let page = page {
                params.append("page=\(page)")
            }
            if let pageSize = pageSize {
                params.append("pageSize=\(pageSize)")
            }
            if !params.isEmpty {
                url += "?" + params.joined(separator: "&")
            }
            return url
        case .orderDetail(let id):
            guard let encoded = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return "\(baseURL)/orders/\(id)"
            }
            return "\(baseURL)/orders/\(encoded)"
        case .createOrder:
            return "\(baseURL)/orders"
        case .cancelOrder(let id):
            guard let encoded = id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return "\(baseURL)/orders/\(id)/cancel"
            }
            return "\(baseURL)/orders/\(encoded)/cancel"
        case .orderPaymentStats(let storeId, let startDate, let endDate):
            var url = "\(baseURL)/orders/payment-stats"
            var params: [String] = []
            if let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("storeId=\(encoded)")
            }
            if let encoded = startDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("startDate=\(encoded)")
            }
            if let encoded = endDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("endDate=\(encoded)")
            }
            if !params.isEmpty {
                url += "?" + params.joined(separator: "&")
            }
            return url
        case .employees:
            return "\(baseURL)/employees"
        case .customers:
            return "\(baseURL)/customers"
        case .analytics(let period, let storeId, let startDate, let endDate):
            // 根据首页接口模式，使用 /api/analytics/{period}
            var url = "\(baseURL)/analytics/\(period)"
            var params: [String] = []
            if let storeId = storeId, let encoded = storeId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("storeId=\(encoded)")
            }
            if let startDate = startDate, let encoded = startDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("startDate=\(encoded)")
            }
            if let endDate = endDate, let encoded = endDate.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                params.append("endDate=\(encoded)")
            }
            if !params.isEmpty {
                url += "?" + params.joined(separator: "&")
            }
            return url
        }
    }
    
    /// HTTP请求方法
    var method: String {
        switch self {
        case .login, .createOrder:
            return "POST"
        case .cancelOrder:
            return "PUT"
        default:
            return "GET"
        }
    }
}

