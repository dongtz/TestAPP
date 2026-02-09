//
//  TestAPP1App.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/25.
//

import SwiftUI
import SwiftData

@main
struct TestAPP1App: App {
    
    // SwiftData模型容器配置
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Store.self,
            Product.self,
            Order.self,
            Employee.self,
            Customer.self,
            User.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
