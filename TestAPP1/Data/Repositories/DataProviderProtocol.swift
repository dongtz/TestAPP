//
//  DataProviderProtocol.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 数据提供者协议
/// 定义统一的数据访问接口，支持Mock和真实API两种实现
protocol DataProviderProtocol: Sendable {
    // MARK: - 认证相关
    func login(username: String, password: String) async throws -> User
    
    // MARK: - Dashboard数据
    func fetchDashboardData() async throws -> DashboardData
    
    // MARK: - 分析数据
    func fetchAnalyticsData(period: AnalyticsPeriod) async throws -> AnalyticsData
    
    // MARK: - 门店相关
    func fetchStores() async throws -> [Store]
    func fetchStore(id: String) async throws -> Store
    
    // MARK: - 商品相关
    func fetchProducts() async throws -> [Product]
    func fetchProducts(category: String) async throws -> [Product]
    func searchProducts(keyword: String) async throws -> [Product]
    
    // MARK: - 订单相关
    func fetchOrders() async throws -> [Order]
    func fetchOrders(status: String) async throws -> [Order]
    func createOrder(_ order: Order) async throws -> Order
    func fetchOrderDetail(id: String) async throws -> Order
    func cancelOrder(id: String, reason: String) async throws
    
    // MARK: - 员工相关
    func fetchEmployees() async throws -> [Employee]
    func fetchEmployees(storeId: String) async throws -> [Employee]
    
    // MARK: - 客户相关
    func fetchCustomers() async throws -> [Customer]
    func searchCustomers(keyword: String) async throws -> [Customer]
    func createCustomer(_ customer: Customer) async throws -> Customer
}
