//
//  LoadingView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 加载中视图
struct LoadingView: View {
    
    var message: String = "加载中..."
    
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.appPrimary)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

/// 小型加载指示器（用于按钮等小区域）
struct SmallLoadingView: View {
    
    var body: some View {
        ProgressView()
            .scaleEffect(0.8)
            .tint(.white)
    }
}

#Preview("加载视图") {
    LoadingView()
}

#Preview("加载视图-自定义文字") {
    LoadingView(message: "正在加载数据...")
}






