//
//  DataCard.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 数据卡片组件
struct DataCard: View {
    
    var title: String
    var value: String
    var subtitle: String? = nil
    var icon: String? = nil
    var trend: TrendType? = nil
    var trendValue: String? = nil
    
    enum TrendType {
        case up
        case down
        case neutral
        
        var color: Color {
            switch self {
            case .up: return .priceUp
            case .down: return .priceDown
            case .neutral: return .neutral
            }
        }
        
        var icon: String {
            switch self {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            case .neutral: return "minus"
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题行
            HStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: 16, height: 16)
                }
            }
            .frame(height: 20)
            
            Spacer(minLength: 0)
            
            // 数值行
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                if let trend = trend, let trendValue = trendValue {
                    HStack(spacing: 2) {
                        Image(systemName: trend.icon)
                            .font(.caption2)
                        Text(trendValue)
                            .font(.caption2)
                    }
                    .foregroundStyle(trend.color)
                    .lineLimit(1)
                }
            }
            .frame(height: 32)
            
            // 副标题
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(height: 16)
            } else {
                // 占位，保持高度一致
                Spacer()
                    .frame(height: 16)
            }
        }
        .frame(height: 100) // 固定高度，确保所有卡片一致
        .frame(maxWidth: .infinity) // 确保宽度一致
        .padding(16)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.UI.cardCornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview("数据卡片-基础") {
    DataCard(
        title: "今日销售额",
        value: "¥128,500"
    )
    .padding()
}

#Preview("数据卡片-带趋势") {
    DataCard(
        title: "今日销售额",
        value: "¥128,500",
        subtitle: "昨日 ¥115,300",
        icon: "yensign.circle",
        trend: .up,
        trendValue: "+11.4%"
    )
    .padding()
}

#Preview("数据卡片-下降趋势") {
    DataCard(
        title: "客流量",
        value: "156",
        subtitle: "昨日 168人",
        icon: "person.2",
        trend: .down,
        trendValue: "-7.1%"
    )
    .padding()
}



