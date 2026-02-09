//
//  ProfileView.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import SwiftUI

/// 个人中心视图
struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(Color.appPrimary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("张三")
                                .font(.headline)
                            Text("店长 · 北京朝阳门店")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("我的业绩") {
                    NavigationLink {
                        Text("业绩详情")
                    } label: {
                        Label("本月业绩", systemImage: "chart.bar.fill")
                    }
                    
                    NavigationLink {
                        Text("提成明细")
                    } label: {
                        Label("我的提成", systemImage: "yensign.circle.fill")
                    }
                }
                
                Section("系统设置") {
                    NavigationLink {
                        Text("账号设置")
                    } label: {
                        Label("账号设置", systemImage: "person.fill")
                    }
                    
                    NavigationLink {
                        Text("系统设置")
                    } label: {
                        Label("系统设置", systemImage: "gearshape.fill")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        // 退出登录
                    } label: {
                        HStack {
                            Spacer()
                            Text("退出登录")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("我的")
        }
    }
}

#Preview {
    ProfileView()
}

