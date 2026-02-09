//
//  InventoryViewModel.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class InventoryViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var searchText = ""
    @Published var selectedCategory: String? = nil
    
    // 统计数据
    @Published var totalProducts: Int = 0
    @Published var warningCount: Int = 0
    @Published var outOfStockCount: Int = 0
    
    private let repository = DataRepository.shared
    
    init() {
        Task {
            await loadProducts()
        }
    }
    
    /// 加载商品列表
    func loadProducts() async {
        isLoading = true
        error = nil
        
        do {
            let products = try await repository.fetchProducts()
            self.products = products
            self.filteredProducts = products
            updateStatistics()
        } catch {
            self.error = error
            print("❌ 加载商品数据失败: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// 搜索商品
    func searchProducts() {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            Task {
                do {
                    let results = try await repository.searchProducts(keyword: searchText)
                    filteredProducts = results
                } catch {
                    print("❌ 搜索失败: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 按分类筛选
    func filterByCategory(_ category: String?) {
        selectedCategory = category
        if let category = category {
            filteredProducts = products.filter { $0.category == category }
        } else {
            filteredProducts = products
        }
        updateStatistics()
    }
    
    /// 更新统计数据
    private func updateStatistics() {
        totalProducts = filteredProducts.count
        warningCount = filteredProducts.filter { $0.isLowStock }.count
        outOfStockCount = filteredProducts.filter { $0.isOutOfStock }.count
    }
    
    /// 刷新数据
    func refresh() async {
        await loadProducts()
    }
}




