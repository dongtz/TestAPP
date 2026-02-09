//
//  AnalyticsViewModel.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AnalyticsViewModel: ObservableObject {
    
    @Published var analyticsData: AnalyticsData?
    @Published var selectedPeriod: AnalyticsPeriod = .day
    @Published var isLoading = false
    @Published var error: Error?
    
    
    init() {
        Task {
            await loadAnalyticsData(period: selectedPeriod)
        }
    }
    
    /// 加载分析数据
    func loadAnalyticsData(period: AnalyticsPeriod) async {
        isLoading = true
        error = nil
        selectedPeriod = period
        
        do {
            // 从数据仓库获取分析数据
            let data = try await DataRepository.shared.fetchAnalyticsData(period: period)
            var analyticsDataWithPeriod = data
            analyticsDataWithPeriod.period = period.rawValue
            analyticsData = analyticsDataWithPeriod
            print("✅ 分析数据加载成功，销售趋势点数: \(data.salesTrend.count)")
        } catch let networkError as NetworkError {
            // 如果是请求被取消，不显示错误（这是正常的用户操作）
            if case .cancelled = networkError {
                print("⚠️ 分析数据请求被取消，忽略此错误")
                // 不设置error，保持当前数据
            } else {
                self.error = networkError
                print("❌ 加载分析数据失败: \(networkError.localizedDescription)")
            }
        } catch {
            self.error = error
            print("❌ 加载分析数据失败: \(error)")
        }
        
        isLoading = false
    }
    
    /// 切换分析维度
    func switchPeriod(_ period: AnalyticsPeriod) {
        Task {
            await loadAnalyticsData(period: period)
        }
    }
    
    /// 刷新数据
    func refresh() async {
        await loadAnalyticsData(period: selectedPeriod)
    }
}

