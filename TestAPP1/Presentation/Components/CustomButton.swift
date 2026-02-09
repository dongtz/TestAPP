//
//  CustomButton.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 自定义按钮组件
struct CustomButton: View {
    
    var title: String
    var icon: String? = nil
    var style: ButtonStyle = .primary
    var size: ButtonSize = .medium
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var action: () -> Void
    
    enum ButtonStyle {
        case primary
        case secondary
        case outline
        case text
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .appPrimary
            case .secondary: return .secondary
            case .outline, .text: return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .white
            case .outline: return .appPrimary
            case .text: return .appPrimary
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .outline: return .appPrimary
            default: return nil
            }
        }
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }
        
        var fontSize: Font {
            switch self {
            case .small: return .footnote
            case .medium: return .subheadline
            case .large: return .body
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(style.foregroundColor)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .fontWeight(.medium)
                }
            }
            .font(size.fontSize)
            .foregroundStyle(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style.borderColor ?? .clear, lineWidth: 1)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

#Preview("按钮-主要样式") {
    VStack(spacing: 16) {
        CustomButton(
            title: "登录",
            style: .primary,
            action: {}
        )
        
        CustomButton(
            title: "登录",
            icon: "person.fill",
            style: .primary,
            action: {}
        )
        
        CustomButton(
            title: "登录中...",
            style: .primary,
            isLoading: true,
            action: {}
        )
    }
    .padding()
}

#Preview("按钮-不同样式") {
    VStack(spacing: 16) {
        CustomButton(
            title: "主要按钮",
            style: .primary,
            action: {}
        )
        
        CustomButton(
            title: "次要按钮",
            style: .secondary,
            action: {}
        )
        
        CustomButton(
            title: "边框按钮",
            style: .outline,
            action: {}
        )
        
        CustomButton(
            title: "文字按钮",
            style: .text,
            action: {}
        )
    }
    .padding()
}

#Preview("按钮-不同尺寸") {
    VStack(spacing: 16) {
        CustomButton(
            title: "小按钮",
            style: .primary,
            size: .small,
            action: {}
        )
        
        CustomButton(
            title: "中等按钮",
            style: .primary,
            size: .medium,
            action: {}
        )
        
        CustomButton(
            title: "大按钮",
            style: .primary,
            size: .large,
            action: {}
        )
    }
    .padding()
}






