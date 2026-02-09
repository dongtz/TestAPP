//
//  AnalyticsView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI
import Charts

/// 经营分析视图
struct AnalyticsView: View {
    
    @StateObject private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.analyticsData == nil {
                    LoadingView(message: "加载中...")
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                } else if let data = viewModel.analyticsData {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 页面标题
                            headerSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.top, 8)
                                .padding(.bottom, 20)
                            
                            // 维度切换
                            periodSelector
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 销售趋势图
                            salesTrendSection(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 分品类销售
                            categorySalesSection(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                            
                            // 热销商品TOP5
                            topProductsSection(data: data)
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("分析")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - 页面标题
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("经营分析")
                .font(.title)
                .fontWeight(.bold)
            Text("数据洞察，助力决策")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - 维度切换
    
    private var periodSelector: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    viewModel.switchPeriod(period)
                }) {
                    Text(period.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(viewModel.selectedPeriod == period ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            viewModel.selectedPeriod == period
                            ? Color.appPrimary
                            : Color.cardBackground
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(4)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - 销售趋势图
    
    private func salesTrendSection(data: AnalyticsData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(periodTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Text("单位：元")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if data.salesTrend.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("暂无销售趋势数据")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    SalesTrendChart(dataPoints: data.salesTrend, period: viewModel.selectedPeriod)
                    
                    // 统计信息
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("总销售额")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("¥\(formatCurrency(data.totalSales))")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("总订单")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(data.totalOrders)单")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - 分品类销售
    
    private func categorySalesSection(data: AnalyticsData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("分品类销售")
                .font(.title3)
                .fontWeight(.bold)
            
            if data.categorySales.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.pie.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("暂无品类销售数据")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            } else {
                VStack(spacing: 14) {
                    ForEach(data.categorySales, id: \.category) { category in
                        CategorySalesRow(category: category)
                    }
                }
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - 热销商品TOP榜
    
    private func topProductsSection(data: AnalyticsData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("热销商品TOP榜")
                .font(.title3)
                .fontWeight(.bold)
            
            if data.topProducts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("暂无热销商品数据")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            } else {
                VStack(spacing: 12) {
                    ForEach(data.topProducts, id: \.productId) { product in
                        TopProductRow(product: product)
                    }
                }
                .padding(18)
                .background(Color.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - 辅助属性
    
    private var periodTitle: String {
        switch viewModel.selectedPeriod {
        case .day: return "今日销售趋势"
        case .week: return "本周销售趋势"
        case .month: return "本月销售趋势"
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

// MARK: - 品类销售行组件

struct CategorySalesRow: View {
    let category: CategorySales
    
    var body: some View {
        HStack(spacing: 14) {
            // 图标
            Text(category.icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // 品类信息
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(category.category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("¥\(formatAmount(category.amount))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                // 进度条
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 6)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(categoryColor)
                            .frame(width: geometry.size.width * (category.percentage / 100), height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
    }
    
    private var categoryColor: Color {
        switch category.category {
        case "手机": return Color(hex: "#3B82F6")
        case "笔记本": return Color(hex: "#8B5CF6")
        case "配件": return Color(hex: "#10B981")
        case "智能硬件": return Color(hex: "#F59E0B")
        default: return Color.appPrimary
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        if amount >= 10000 {
            return String(format: "%.1f万", amount / 10000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
}

// MARK: - 热销商品行组件

struct TopProductRow: View {
    let product: TopProduct
    
    var body: some View {
        HStack(spacing: 14) {
            // 排名
            ZStack {
                Circle()
                    .fill(rankColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Text("\(product.rank)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(rankColor)
            }
            
            // 商品图标
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(productIconColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Text(productIcon)
                    .font(.system(size: 24))
            }
            
            // 商品信息
            VStack(alignment: .leading, spacing: 4) {
                Text(product.productName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("销售 \(product.salesCount) 台")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 销售金额
            VStack(alignment: .trailing, spacing: 2) {
                Text("¥\(formatAmount(product.salesAmount))")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var rankColor: Color {
        switch product.rank {
        case 1: return Color(hex: "#FBBF24") // 金色
        case 2: return Color(hex: "#9CA3AF") // 银色
        case 3: return Color(hex: "#F97316") // 铜色
        default: return Color.gray
        }
    }
    
    /// 根据商品名称推断图标
    private var productIcon: String {
        let name = product.productName.lowercased()
        
        // 手机相关
        if name.contains("iphone") || name.contains("手机") || name.contains("phone") {
            return "📱"
        }
        // 平板相关
        else if name.contains("ipad") || name.contains("平板") || name.contains("tablet") {
            return "📱"
        }
        // 笔记本相关
        else if name.contains("macbook") || name.contains("笔记本") || name.contains("laptop") || name.contains("电脑") {
            return "💻"
        }
        // 配件相关
        else if name.contains("充电") || name.contains("数据线") || name.contains("线") || name.contains("配件") || name.contains("accessory") {
            return "🔌"
        }
        // 智能硬件相关
        else if name.contains("智能") || name.contains("硬件") || name.contains("smart") || name.contains("watch") || name.contains("手表") {
            return "⌚"
        }
        // 耳机相关
        else if name.contains("耳机") || name.contains("earphone") || name.contains("airpods") {
            return "🎧"
        }
        // 默认图标
        else {
            return "📦"
        }
    }
    
    /// 根据商品名称推断图标颜色
    private var productIconColor: Color {
        let name = product.productName.lowercased()
        
        // 手机相关
        if name.contains("iphone") || name.contains("手机") || name.contains("phone") {
            return Color(hex: "#3B82F6")
        }
        // 平板相关
        else if name.contains("ipad") || name.contains("平板") || name.contains("tablet") {
            return Color(hex: "#8B5CF6")
        }
        // 笔记本相关
        else if name.contains("macbook") || name.contains("笔记本") || name.contains("laptop") || name.contains("电脑") {
            return Color(hex: "#6366F1")
        }
        // 配件相关
        else if name.contains("充电") || name.contains("数据线") || name.contains("线") || name.contains("配件") || name.contains("accessory") {
            return Color(hex: "#10B981")
        }
        // 智能硬件相关
        else if name.contains("智能") || name.contains("硬件") || name.contains("smart") || name.contains("watch") || name.contains("手表") {
            return Color(hex: "#F59E0B")
        }
        // 耳机相关
        else if name.contains("耳机") || name.contains("earphone") || name.contains("airpods") {
            return Color(hex: "#EC4899")
        }
        // 默认颜色
        else {
            return Color.gray
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        if amount >= 10000 {
            return String(format: "%.1f万", amount / 10000)
        } else {
            return String(format: "%.0f", amount)
        }
    }
}

#Preview {
    AnalyticsView()
}



