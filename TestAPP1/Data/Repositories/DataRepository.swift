//
//  DataRepository.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 数据仓库
/// 统一的数据访问层，根据配置切换Mock或真实API
actor DataRepository {
    
    static let shared = DataRepository()
    
    private let dataProvider: DataProviderProtocol
    
    private init() {
        // 使用Mock数据提供者（前端独立运行模式）
        self.dataProvider = MockDataProvider()
        print("✅ 使用Mock数据模式（前端独立运行）")
    }
    
    // MARK: - 对外提供的接口
    
    func login(username: String, password: String) async throws -> User {
        try await dataProvider.login(username: username, password: password)
    }
    
    func fetchDashboardData() async throws -> DashboardData {
        return try await dataProvider.fetchDashboardData()
    }
    
    func fetchAnalyticsData(period: AnalyticsPeriod) async throws -> AnalyticsData {
        return try await dataProvider.fetchAnalyticsData(period: period)
    }
    
    func fetchStores() async throws -> [Store] {
        try await dataProvider.fetchStores()
    }
    
    func fetchStore(id: String) async throws -> Store {
        try await dataProvider.fetchStore(id: id)
    }
    
    func fetchProducts() async throws -> [Product] {
        try await dataProvider.fetchProducts()
    }
    
    func fetchProducts(category: String) async throws -> [Product] {
        try await dataProvider.fetchProducts(category: category)
    }
    
    func searchProducts(keyword: String) async throws -> [Product] {
        try await dataProvider.searchProducts(keyword: keyword)
    }
    
    func fetchOrders() async throws -> [Order] {
        try await dataProvider.fetchOrders()
    }
    
    func fetchOrders(status: String?) async throws -> [Order] {
        if let status = status, !status.isEmpty {
            return try await dataProvider.fetchOrders(status: status)
        }
        return try await dataProvider.fetchOrders()
    }
    
    func createOrder(_ order: Order) async throws -> Order {
        try await dataProvider.createOrder(order)
    }
    
    func fetchOrderDetail(id: String) async throws -> Order {
        try await dataProvider.fetchOrderDetail(id: id)
    }
    
    func cancelOrder(id: String, reason: String) async throws {
        try await dataProvider.cancelOrder(id: id, reason: reason)
    }
    
    func fetchEmployees() async throws -> [Employee] {
        try await dataProvider.fetchEmployees()
    }
    
    func fetchEmployees(storeId: String) async throws -> [Employee] {
        try await dataProvider.fetchEmployees(storeId: storeId)
    }
    
    func fetchCustomers() async throws -> [Customer] {
        try await dataProvider.fetchCustomers()
    }
    
    func searchCustomers(keyword: String) async throws -> [Customer] {
        try await dataProvider.searchCustomers(keyword: keyword)
    }
    
    func createCustomer(_ customer: Customer) async throws -> Customer {
        try await dataProvider.createCustomer(customer)
    }
}
