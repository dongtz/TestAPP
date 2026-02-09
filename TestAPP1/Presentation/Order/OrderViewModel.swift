//
//  OrderViewModel.swift
//  TestAPP1
//
//  Created by Tianzhedong on 2025/12/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OrderViewModel: ObservableObject {
    
    @Published var orders: [Order] = []
    @Published var filteredOrders: [Order] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedStatus: OrderStatusFilter = .all
    
    // 统计数据
    @Published var todayCompletedCount: Int = 0
    
    private let repository = DataRepository.shared
    
    init() {
        Task {
            await loadOrders()
        }
    }
    
    /// 加载订单列表
    func loadOrders() async {
        isLoading = true
        error = nil
        
        do {
            // 根据选中的状态筛选
            let status: String?
            switch selectedStatus {
            case .all:
                status = nil
            case .pending:
                status = "PENDING"
            case .completed:
                status = "PAID"  // 服务端使用PAID表示已支付/已完成
            case .afterSale:
                status = nil  // 售后需要单独处理
            }
            
            var orders = try await repository.fetchOrders(status: status)
            
            // 如果是售后筛选，需要过滤出退款相关的订单
            if selectedStatus == .afterSale {
                orders = orders.filter { order in
                    order.status == OrderStatus.refunding.rawValue ||
                    order.status == OrderStatus.refunded.rawValue
                }
            }
            
            self.orders = orders
            updateFilteredOrders()
            updateStatistics()
        } catch let networkError as NetworkError {
            // 如果是请求被取消，不显示错误
            if case .cancelled = networkError {
                print("⚠️ 订单数据请求被取消，忽略此错误")
            } else {
                self.error = networkError
                print("❌ 加载订单数据失败: \(networkError.localizedDescription)")
            }
        } catch {
            self.error = error
            print("❌ 加载订单数据失败: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// 根据状态筛选订单
    func filterByStatus(_ status: OrderStatusFilter) {
        selectedStatus = status
        updateFilteredOrders()
    }
    
    /// 更新筛选后的订单列表
    private func updateFilteredOrders() {
        switch selectedStatus {
        case .all:
            filteredOrders = orders
        case .pending:
            filteredOrders = orders.filter { $0.status == OrderStatus.pending.rawValue }
        case .completed:
            filteredOrders = orders.filter { $0.status == OrderStatus.completed.rawValue }
        case .afterSale:
            filteredOrders = orders.filter { 
                $0.status == OrderStatus.refunding.rawValue || 
                $0.status == OrderStatus.refunded.rawValue 
            }
        }
    }
    
    /// 更新统计数据
    private func updateStatistics() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayCompletedCount = orders.filter { order in
            if let completedAt = order.completedAt {
                return calendar.isDate(completedAt, inSameDayAs: today) &&
                       order.status == OrderStatus.completed.rawValue
            }
            return false
        }.count
    }
    
    /// 刷新数据
    func refresh() async {
        await loadOrders()
    }
}

/// 订单状态筛选
enum OrderStatusFilter: String, CaseIterable {
    case all = "全部"
    case pending = "待支付"
    case completed = "已完成"
    case afterSale = "售后"
}


