//
//  DesignSystem.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 设计系统预览
/// 展示所有设计规范和UI组件
struct DesignSystemPreview: View {
    
    var body: some View {
        NavigationStack {
            List {
                // 颜色
                Section("主题色") {
                    ColorRow(name: "主色", color: Color(hex: ThemeColors.primary))
                    ColorRow(name: "辅助色", color: Color(hex: ThemeColors.accent))
                    ColorRow(name: "成功色", color: Color(hex: ThemeColors.success))
                    ColorRow(name: "警告色", color: Color(hex: ThemeColors.warning))
                }
                
                // 字体
                Section("字体规范") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("标题 - 28-34pt Bold")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("副标题 - 20-24pt Semibold")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("正文 - 16-17pt Regular")
                            .font(.body)
                        
                        Text("辅助文字 - 13-14pt Regular")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Text("说明文字 - 11-12pt Regular")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                // 间距
                Section("间距规范") {
                    VStack(alignment: .leading, spacing: 12) {
                        SpacingRow(name: "标准间距", value: AppConstants.UI.standardSpacing)
                        SpacingRow(name: "小间距", value: AppConstants.UI.smallSpacing)
                        SpacingRow(name: "大间距", value: AppConstants.UI.largeSpacing)
                        SpacingRow(name: "卡片圆角", value: AppConstants.UI.cardCornerRadius)
                    }
                }
                
                // 组件示例
                Section("按钮组件") {
                    VStack(spacing: 12) {
                        CustomButton(title: "主要按钮", style: .primary, action: {})
                        CustomButton(title: "次要按钮", style: .secondary, action: {})
                        CustomButton(title: "边框按钮", style: .outline, action: {})
                        CustomButton(title: "文字按钮", style: .text, action: {})
                    }
                    .padding(.vertical, 8)
                }
                
                Section("数据卡片") {
                    VStack(spacing: 12) {
                        DataCard(
                            title: "今日销售额",
                            value: "¥128,500",
                            subtitle: "昨日 ¥115,300",
                            icon: "yensign.circle",
                            trend: .up,
                            trendValue: "+11.4%"
                        )
                        
                        DataCard(
                            title: "客流量",
                            value: "156",
                            subtitle: "昨日 168人",
                            icon: "person.2",
                            trend: .down,
                            trendValue: "-7.1%"
                        )
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("设计系统")
        }
    }
}

/// 颜色行组件
struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 40)
            
            Text(name)
                .font(.body)
            
            Spacer()
        }
    }
}

/// 间距行组件
struct SpacingRow: View {
    let name: String
    let value: CGFloat
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
            
            Spacer()
            
            Text("\(Int(value))pt")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Rectangle()
                .fill(Color.appPrimary)
                .frame(width: value, height: 20)
        }
    }
}

#Preview {
    DesignSystemPreview()
}






