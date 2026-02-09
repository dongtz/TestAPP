//
//  InventoryListView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 库存管理视图
struct InventoryListView: View {
    
    @StateObject private var viewModel = InventoryViewModel()
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if viewModel.isLoading && viewModel.products.isEmpty {
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
                        
                        // 搜索栏
                        searchBarSection
                            .padding(.horizontal, AppConstants.UI.standardSpacing)
                            .padding(.bottom, 16)
                        
                        // 统计卡片
                        statisticsSection
                            .padding(.horizontal, AppConstants.UI.standardSpacing)
                            .padding(.bottom, 20)
                        
                        // 库存预警
                        if viewModel.warningCount > 0 || viewModel.outOfStockCount > 0 {
                            warningSection
                                .padding(.horizontal, AppConstants.UI.standardSpacing)
                                .padding(.bottom, 20)
                        }
                        
                        // 商品列表
                        productsListSection
                            .padding(.horizontal, AppConstants.UI.standardSpacing)
                            .padding(.bottom, 20)
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
        .navigationTitle("库存管理")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - 页面标题
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("库存管理")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("共 \(viewModel.totalProducts) 个商品")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 筛选按钮
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.appPrimary.opacity(0.12))
                    .clipShape(Circle())
            }
        }
    }
    
    // MARK: - 搜索栏
    
    private var searchBarSection: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 16))
                
                TextField("搜索商品名称/型号/条码", text: $viewModel.searchText)
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
                    .onSubmit {
                        viewModel.searchProducts()
                    }
                    .onChange(of: viewModel.searchText) { _, newValue in
                        if newValue.isEmpty {
                            viewModel.filteredProducts = viewModel.products
                        } else {
                            viewModel.searchProducts()
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.filteredProducts = viewModel.products
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - 统计卡片
    
    private var statisticsSection: some View {
        HStack(spacing: 12) {
            StatisticCard(
                value: "\(viewModel.totalProducts)",
                label: "总商品",
                color: Color(hex: "#3B82F6")
            )
            
            StatisticCard(
                value: "\(viewModel.warningCount)",
                label: "预警",
                color: Color(hex: "#EF4444")
            )
            
            StatisticCard(
                value: "\(viewModel.outOfStockCount)",
                label: "缺货",
                color: Color(hex: "#F59E0B")
            )
        }
    }
    
    // MARK: - 库存预警
    
    private var warningSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("库存预警")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                Spacer()
                Button(action: {
                    viewModel.filterByCategory(nil)
                }) {
                    Text("查看全部")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.appPrimary)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(warningProducts.prefix(3), id: \.id) { product in
                    InventoryWarningCard(product: product)
                }
            }
        }
    }
    
    // MARK: - 商品列表
    
    private var productsListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.searchText.isEmpty {
                Text("搜索结果")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            } else {
                Text("全部商品")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            
            if viewModel.filteredProducts.isEmpty {
                EmptyStateView(
                    icon: "cube.box",
                    title: viewModel.searchText.isEmpty ? "暂无商品" : "未找到商品",
                    message: viewModel.searchText.isEmpty ? "快去添加第一个商品吧" : "请尝试其他关键词"
                )
                .frame(height: 300)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredProducts, id: \.id) { product in
                        InventoryProductCard(product: product)
                    }
                }
            }
        }
    }
    
    // MARK: - 辅助属性
    
    private var warningProducts: [Product] {
        viewModel.products.filter { $0.isLowStock || $0.isOutOfStock }
            .sorted { $0.stock < $1.stock }
    }
}

// MARK: - 统计卡片组件

struct StatisticCard: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(color)
            
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - 库存预警卡片

struct InventoryWarningCard: View {
    let product: Product
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                // 商品图片占位
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color(hex: "#111827"))
                                .lineLimit(1)
                            
                            Text(product.specification.isEmpty ? product.model : product.specification)
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "#6B7280"))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // 状态标签
                        Text(statusText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(statusTextColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(statusBgColor)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("当前库存")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text("\(product.stock)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(statusTextColor)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Text("入库")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.appPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
    }
    
    private var statusText: String {
        if product.isOutOfStock {
            return "缺货"
        } else if product.isLowStock {
            return "低库存"
        } else {
            return "即将缺货"
        }
    }
    
    private var statusTextColor: Color {
        if product.isOutOfStock {
            return Color(hex: "#DC2626")
        } else if product.isLowStock {
            return Color(hex: "#EA580C")
        } else {
            return Color(hex: "#EA580C")
        }
    }
    
    private var statusBgColor: Color {
        // 使用适配暗黑模式的背景色
        if product.isOutOfStock {
            return Color(hex: "#DC2626").opacity(0.2)
        } else if product.isLowStock {
            return Color(hex: "#EA580C").opacity(0.2)
        } else {
            return Color(hex: "#EA580C").opacity(0.2)
        }
    }
}

// MARK: - 商品卡片组件

struct InventoryProductCard: View {
    let product: Product
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                // 商品图片占位
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            
                            Text(product.specification.isEmpty ? product.model : product.specification)
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // 库存状态
                        if product.isOutOfStock {
                            Text("缺货")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color(hex: "#DC2626"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#DC2626").opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        } else if product.isLowStock {
                            Text("低库存")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Color(hex: "#EA580C"))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#EA580C").opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("库存")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text("\(product.stock)")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(product.isLowStock ? Color(hex: "#EA580C") : (product.isOutOfStock ? Color(hex: "#DC2626") : .primary))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("售价")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                            Text("¥\(product.currentPrice.toCurrencyString)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
    }
}

#Preview {
    InventoryListView()
}
