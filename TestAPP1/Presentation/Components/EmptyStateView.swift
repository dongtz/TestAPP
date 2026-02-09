//
//  EmptyStateView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 空状态视图
struct EmptyStateView: View {
    
    var icon: String = "tray"
    var title: String = "暂无数据"
    var message: String = ""
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.appPrimary)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview("空状态-基础") {
    EmptyStateView()
}

#Preview("空状态-带消息") {
    EmptyStateView(
        icon: "cart",
        title: "暂无订单",
        message: "您还没有任何订单记录"
    )
}

#Preview("空状态-带操作按钮") {
    EmptyStateView(
        icon: "person.3",
        title: "暂无客户",
        message: "快去添加第一个客户吧",
        actionTitle: "添加客户",
        action: {}
    )
}






