//
//  OrderListView.swift
//  TestAPP1
//
//  Created by Tianzhedong on 2025/12/26.
//

import SwiftUI

/// 订单列表视图
struct OrderListView: View {
    
    @StateObject private var viewModel = OrderViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.orders.isEmpty {
                    LoadingView(message: "加载中...")
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 页面标题
                            headerSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                            
                            // 筛选标签栏
                            filterSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 16)
                            
                            // 订单列表
                            ordersListSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("订单")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // TODO: 跳转到创建订单页面
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.appPrimary)
                            .clipShape(Circle())
                            .shadow(color: Color.appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
            }
        }
    }
    
    // MARK: - 页面标题
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("订单管理")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("今日已完成 \(viewModel.todayCompletedCount) 单")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
    
    // MARK: - 筛选标签栏
    
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(OrderStatusFilter.allCases, id: \.self) { filter in
                    FilterButton(
                        title: filter.rawValue,
                        isSelected: viewModel.selectedStatus == filter
                    ) {
                        viewModel.filterByStatus(filter)
                    }
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - 订单列表
    
    private var ordersListSection: some View {
        VStack(spacing: 12) {
            if viewModel.filteredOrders.isEmpty {
                EmptyStateView(
                    icon: "doc.text",
                    title: "暂无订单",
                    message: viewModel.selectedStatus == .all ? "快去创建第一个订单吧" : "该状态下暂无订单"
                )
                .frame(height: 400)
            } else {
                ForEach(viewModel.filteredOrders, id: \.id) { order in
                    OrderCard(order: order)
                }
            }
        }
    }
}

// MARK: - 筛选按钮组件

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appPrimary : Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: isSelected ? .clear : Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
        }
    }
}

// MARK: - 订单卡片组件

struct OrderCard: View {
    let order: Order
    
    var body: some View {
        Button(action: {
            // TODO: 跳转到订单详情
        }) {
            VStack(spacing: 12) {
                // 订单号和状态
                HStack {
                    HStack(spacing: 8) {
                        Text("订单号:")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        Text(order.orderNumber)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                    
                    // 状态标签
                    Text(statusText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(statusTextColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusBgColor)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                // 商品信息
                HStack(spacing: 12) {
                    // 商品图片占位
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 64, height: 64)
                    
                    // 商品详情
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mainProductName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        
                        Text(productQuantityText)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        
                        if let customerName = order.customerName {
                            Text("客户: \(customerName)")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    
                    Spacer()
                    
                    // 金额和支付方式
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("¥\(order.totalAmount.toFormattedCurrency)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        Text(order.paymentMethod)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
                
                // 分割线和底部信息
                Divider()
                    .background(Color.divider)
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 16))
                            .foregroundStyle(.secondary)
                        Text(timeText)
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: 跳转到订单详情
                    }) {
                        Text("查看详情")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.appPrimary)
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - 辅助属性
    
    private var mainProductName: String {
        order.items.first?.productName ?? "未知商品"
    }
    
    private var productQuantityText: String {
        if order.items.count == 1 {
            let item = order.items[0]
            return "x\(item.quantity)"
        } else {
            let firstItem = order.items[0]
            let otherItems = order.items.dropFirst()
            let otherText = otherItems.map { "\($0.productName) x\($0.quantity)" }.joined(separator: " + ")
            return "x\(firstItem.quantity) + \(otherText)"
        }
    }
    
    private var statusText: String {
        order.status
    }
    
    private var statusTextColor: Color {
        switch order.status {
        case OrderStatus.completed.rawValue:
            return Color(hex: "#15803D")
        case OrderStatus.pending.rawValue:
            return Color(hex: "#EA580C")
        case OrderStatus.refunding.rawValue, OrderStatus.refunded.rawValue:
            return Color(hex: "#DC2626")
        default:
            return .secondary
        }
    }
    
    private var statusBgColor: Color {
        // 使用适配暗黑模式的背景色
        switch order.status {
        case OrderStatus.completed.rawValue:
            return Color(hex: "#15803D").opacity(0.2)
        case OrderStatus.pending.rawValue:
            return Color(hex: "#EA580C").opacity(0.2)
        case OrderStatus.refunding.rawValue, OrderStatus.refunded.rawValue:
            return Color(hex: "#DC2626").opacity(0.2)
        default:
            return Color.secondary.opacity(0.1)
        }
    }
    
    private var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: order.createdAt)
    }
}

#Preview {
    NavigationStack {
        OrderListView()
    }
}
