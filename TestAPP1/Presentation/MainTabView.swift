//
//  MainTabView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 主Tab导航视图
struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 首页-数据看板
            DashboardView()
                .tabItem {
                    Label("首页", systemImage: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // 经营分析
            AnalyticsView()
                .tabItem {
                    Label("分析", systemImage: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                }
                .tag(1)
            
            // 订单管理
            OrderListView()
                .tabItem {
                    Label("订单", systemImage: selectedTab == 2 ? "cart.fill" : "cart")
                }
                .tag(2)
            
            // 我的
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: selectedTab == 3 ? "person.fill" : "person")
                }
                .tag(3)
        }
        .tint(.appPrimary)
    }
}

#Preview {
    MainTabView()
}






