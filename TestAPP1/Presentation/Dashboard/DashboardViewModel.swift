//
//  DashboardViewModel.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    
    @Published var dashboardData: DashboardData?
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        Task {
            await loadDashboardData()
        }
    }
    
    /// 加载Dashboard数据
    func loadDashboardData() async {
        isLoading = true
        error = nil
        
        do {
            let data = try await DataRepository.shared.fetchDashboardData()
            dashboardData = data
        } catch let networkError as NetworkError {
            // 如果是请求被取消，不显示错误（这是正常的用户操作）
            if case .cancelled = networkError {
                print("⚠️ Dashboard数据请求被取消，忽略此错误")
                // 不设置error，保持当前数据
            } else {
                self.error = networkError
                print("❌ 加载Dashboard数据失败: \(networkError.localizedDescription)")
            }
        } catch {
            self.error = error
            print("❌ 加载Dashboard数据失败: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// 刷新数据
    func refresh() async {
        // 刷新时不重置error，避免显示之前的错误
        await loadDashboardData()
    }
}

