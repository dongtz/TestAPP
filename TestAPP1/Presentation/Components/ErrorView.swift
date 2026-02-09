//
//  ErrorView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 错误视图
struct ErrorView: View {
    
    var error: Error
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 64))
                .foregroundStyle(.red)
            
            VStack(spacing: 8) {
                Text("出错了")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Label("重试", systemImage: "arrow.clockwise")
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

#Preview("错误视图") {
    ErrorView(
        error: NSError(domain: "", code: -1, userInfo: [
            NSLocalizedDescriptionKey: "网络连接失败，请检查网络设置"
        ]),
        retryAction: {}
    )
}






