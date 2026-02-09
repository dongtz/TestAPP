//
//  SalesTrendChart.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI
import Charts

/// 销售趋势图表组件
struct SalesTrendChart: View {
    
    let dataPoints: [SalesTrendPoint]
    let period: AnalyticsPeriod
    
    var body: some View {
        Chart {
            ForEach(Array(dataPoints.enumerated()), id: \.offset) { index, point in
                LineMark(
                    x: .value("时间", point.label),
                    y: .value("销售额", point.value)
                )
                .foregroundStyle(Color(hex: "#3B82F6"))
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("时间", point.label),
                    y: .value("销售额", point.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: "#3B82F6").opacity(0.3),
                            Color(hex: "#3B82F6").opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: getXAxisValues()) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let stringValue = value.as(String.self) {
                        Text(formatXAxisLabel(stringValue))
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .rotationEffect(.degrees(-45))
                            .offset(x: 0, y: 5)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel {
                    if let doubleValue = value.as(Double.self) {
                        Text(formatValue(doubleValue))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(height: 240)  // 增加高度，为旋转的标签留出空间
        .padding(.bottom, 20)  // 底部额外padding，避免标签被裁剪
    }
    
    /// 获取X轴要显示的值（根据数据点数量和维度智能选择）
    private func getXAxisValues() -> [String] {
        guard !dataPoints.isEmpty else { return [] }
        
        let totalCount = dataPoints.count
        let desiredCount: Int
        
        switch period {
        case .day:
            // 日维度：最多显示8个标签（每3小时一个）
            desiredCount = min(8, totalCount)
        case .week:
            // 周维度：显示7个标签（每天一个）
            desiredCount = min(7, totalCount)
        case .month:
            // 月维度：显示6-8个标签（每4-5天一个）
            desiredCount = min(8, totalCount)
        }
        
        // 如果数据点数量少于等于期望数量，全部显示
        if totalCount <= desiredCount {
            return dataPoints.map { $0.label }
        }
        
        // 否则均匀选择要显示的标签
        let step = Double(totalCount - 1) / Double(desiredCount - 1)
        var indices: [Int] = []
        
        for i in 0..<desiredCount {
            let index = Int(round(Double(i) * step))
            indices.append(min(index, totalCount - 1))
        }
        
        // 确保包含第一个和最后一个
        if !indices.contains(0) {
            indices.insert(0, at: 0)
        }
        if !indices.contains(totalCount - 1) {
            indices.append(totalCount - 1)
        }
        
        // 去重并排序
        indices = Array(Set(indices)).sorted()
        
        return indices.map { dataPoints[$0].label }
    }
    
    /// 格式化X轴标签（根据维度使用更短的格式）
    private func formatXAxisLabel(_ label: String) -> String {
        switch period {
        case .day:
            // 日维度：保持原样（如 "9时"）
            return label
        case .week:
            // 周维度：如果是 "MM-dd" 格式，只显示日期部分
            if label.contains("-") {
                let components = label.split(separator: "-")
                if components.count >= 2 {
                    return "\(components[1])日"
                }
            }
            return label
        case .month:
            // 月维度：如果是 "X日" 格式，保持原样；如果是日期格式，提取日期
            if label.hasSuffix("日") {
                return label
            } else if label.contains("-") {
                let components = label.split(separator: "-")
                if components.count >= 3 {
                    return "\(components[2])日"
                }
            }
            return label
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if value >= 10000 {
            return String(format: "%.1f万", value / 10000)
        } else {
            return String(format: "%.0f", value)
        }
    }
}

#Preview {
    SalesTrendChart(
        dataPoints: [
            SalesTrendPoint(time: "09:00", value: 8500, label: "09:00"),
            SalesTrendPoint(time: "12:00", value: 18000, label: "12:00"),
            SalesTrendPoint(time: "15:00", value: 20000, label: "15:00"),
            SalesTrendPoint(time: "18:00", value: 25000, label: "18:00"),
            SalesTrendPoint(time: "21:00", value: 28000, label: "21:00")
        ],
        period: .day
    )
    .padding()
}

