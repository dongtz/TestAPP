//
//  SectionHeader.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 分组标题组件
struct SectionHeader: View {
    
    var title: String
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack(spacing: 4) {
                        Text(actionTitle)
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.appPrimary)
                }
            }
        }
        .padding(.horizontal, AppConstants.UI.standardSpacing)
        .padding(.vertical, AppConstants.UI.smallSpacing)
    }
}

#Preview("分组标题-基础") {
    SectionHeader(title: "热销商品")
}

#Preview("分组标题-带副标题") {
    SectionHeader(
        title: "热销商品",
        subtitle: "本月最受欢迎"
    )
}

#Preview("分组标题-带操作") {
    SectionHeader(
        title: "热销商品",
        subtitle: "本月最受欢迎",
        actionTitle: "查看全部",
        action: {}
    )
}

