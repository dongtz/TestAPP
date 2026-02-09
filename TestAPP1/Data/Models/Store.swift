//
//  Store.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 门店状态
enum StoreStatus: String, Codable {
    case open = "营业中"
    case closed = "已关闭"
    case maintenance = "维护中"
}

/// 门店模型
@Model
final class Store {
    var id: String
    var name: String
    var code: String
    var city: String
    var address: String
    var phone: String
    var managerName: String
    var businessHours: String
    var status: String
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String,
        name: String,
        code: String,
        city: String,
        address: String,
        phone: String = "",
        managerName: String = "",
        businessHours: String = "",
        status: String = "营业中",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.code = code
        self.city = city
        self.address = address
        self.phone = phone
        self.managerName = managerName
        self.businessHours = businessHours
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - DTO

struct StoreDTO: Codable, Sendable {
    var id: String
    var name: String
    var code: String
    var city: String
    var address: String
    var phone: String
    var managerName: String
    var businessHours: String
    var status: String
    var createdAt: Date
    var updatedAt: Date
    
    func toStore() -> Store {
        Store(
            id: id,
            name: name,
            code: code,
            city: city,
            address: address,
            phone: phone,
            managerName: managerName,
            businessHours: businessHours,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
