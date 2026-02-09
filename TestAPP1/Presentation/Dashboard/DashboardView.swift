//
//  DashboardView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 数据看板视图
struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.dashboardData == nil {
                    LoadingView(message: "加载中...")
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                } else if let data = viewModel.dashboardData {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 顶部信息栏
                            headerSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                            
                            // 门店排名卡片
                            rankingCard(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 今日数据
                            todayDataSection(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 快捷操作
                            quickActionsSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 待办事项
                            todoSection(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - 顶部信息栏
    
    private var headerSection: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("当前门店")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("北京朝阳门店")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
            
            // 用户头像
            Button(action: {}) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#3B82F6"), Color(hex: "#8B5CF6")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay {
                        Text("张")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .shadow(color: Color(hex: "#3B82F6").opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    // MARK: - 门店排名卡片
    
    private func rankingCard(data: DashboardData) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("今日门店排名")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(data.storeRanking)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                        Text("/\(data.totalStores)")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                }
                
                Spacer()
                
                // 排名变化
                VStack(alignment: .trailing, spacing: 6) {
                    Text("较昨日")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.75))
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.caption2)
                            .fontWeight(.semibold)
                        Text("2名")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.white.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            // 本月销售和目标
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("本月销售")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                    Text("¥\(formatCurrency(data.monthSales))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("目标完成")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.75))
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(data.monthTargetRate))")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(hex: "#667eea"), Color(hex: "#764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color(hex: "#667eea").opacity(0.3), radius: 16, x: 0, y: 8)
    }
    
    // MARK: - 今日数据
    
    private func todayDataSection(data: DashboardData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                Text("今日数据")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("查看详情")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.appPrimary)
                }
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 14),
                GridItem(.flexible(), spacing: 14)
            ], spacing: 14) {
                DataCard(
                    title: "今日销售额",
                    value: "¥\(formatCurrency(data.todaySales))",
                    subtitle: "昨日 ¥\(formatCurrency(data.yesterdaySales))",
                    icon: "yensign.circle.fill",
                    trend: data.salesChangeRate >= 0 ? .up : .down,
                    trendValue: String(format: "%.1f%%", abs(data.salesChangeRate))
                )
                
                DataCard(
                    title: "客流量",
                    value: "\(data.todayTraffic)人",
                    subtitle: "昨日 \(data.yesterdayTraffic)人",
                    icon: "person.2.fill",
                    trend: data.trafficChangeRate >= 0 ? .up : .down,
                    trendValue: String(format: "%.1f%%", abs(data.trafficChangeRate))
                )
                
                DataCard(
                    title: "成交单数",
                    value: "\(data.todayOrders)单",
                    subtitle: "昨日 \(data.yesterdayOrders)单",
                    icon: "doc.text.fill",
                    trend: data.ordersChangeRate >= 0 ? .up : .down,
                    trendValue: String(format: "%.1f%%", abs(data.ordersChangeRate))
                )
                
                DataCard(
                    title: "转化率",
                    value: String(format: "%.1f%%", data.conversionRate),
                    subtitle: "昨日 \(String(format: "%.1f%%", data.yesterdayConversionRate))",
                    icon: "percent",
                    trend: data.conversionRate >= data.yesterdayConversionRate ? .up : .down,
                    trendValue: String(format: "+%.1f%%", abs(data.conversionRate - data.yesterdayConversionRate))
                )
            }
        }
    }
    
    // MARK: - 快捷操作
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("快捷操作")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            HStack(spacing: 20) {
                NavigationLink(destination: Text("快速开单")) {
                    QuickActionButtonContent(
                        icon: "plus.circle.fill",
                        title: "快速开单",
                        color: Color(hex: "#3B82F6")
                    )
                }
                
                NavigationLink(destination: InventoryListView()) {
                    QuickActionButtonContent(
                        icon: "barcode.viewfinder",
                        title: "库存查询",
                        color: Color(hex: "#10B981")
                    )
                }
                
                NavigationLink(destination: Text("客户管理")) {
                    QuickActionButtonContent(
                        icon: "person.3.fill",
                        title: "客户管理",
                        color: Color(hex: "#8B5CF6")
                    )
                }
                
                NavigationLink(destination: AnalyticsView()) {
                    QuickActionButtonContent(
                        icon: "chart.bar.fill",
                        title: "数据分析",
                        color: Color(hex: "#F59E0B")
                    )
                }
            }
        }
    }
    
    // MARK: - 待办事项
    
    private func todoSection(data: DashboardData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("待办事项")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            VStack(spacing: 14) {
                if data.lowStockCount > 0 {
                    TodoItemCard(
                        icon: "exclamationmark.triangle.fill",
                        title: "库存预警",
                        subtitle: "\(data.lowStockCount)个商品库存不足",
                        color: .red
                    )
                }
                
                if data.pendingOrders > 0 {
                    TodoItemCard(
                        icon: "doc.text.fill",
                        title: "待处理订单",
                        subtitle: "\(data.pendingOrders)个订单待处理",
                        color: .blue
                    )
                }
                
                if data.pendingCustomers > 0 {
                    TodoItemCard(
                        icon: "person.crop.circle.badge.plus",
                        title: "待跟进客户",
                        subtitle: "\(data.pendingCustomers)个客户待跟进",
                        color: .purple
                    )
                }
            }
        }
    }
    
    // MARK: - 辅助方法
    
    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 10000 {
            return String(format: "%.1f万", amount / 10000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
}

// MARK: - 快捷操作按钮组件

/// 快捷操作按钮内容（用于 NavigationLink）
struct QuickActionButtonContent: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(color)
                .frame(width: 64, height: 64)
                .background(color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: color.opacity(0.15), radius: 8, x: 0, y: 4)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

/// 快捷操作按钮（用于普通按钮场景）
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            QuickActionButtonContent(icon: icon, title: title, color: color)
        }
    }
}

// MARK: - 待办事项卡片组件

struct TodoItemCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.primary.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
            }
            .padding(18)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        }
    }
}

#Preview {
    DashboardView()
}



