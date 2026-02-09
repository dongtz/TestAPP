//
//  Customer.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 客户会员等级
enum CustomerLevel: String, Codable {
    case normal = "普通"
    case silver = "银卡"
    case gold = "金卡"
    case platinum = "白金"
    case diamond = "钻石"
}

/// 客户模型
@Model
final class Customer {
    var id: String
    var name: String
    var phone: String
    var gender: String?
    var birthday: Date?
    var level: String
    var address: String?
    var tags: [String]
    var totalSpent: Double
    var totalOrders: Int
    var lastOrderDate: Date?
    var source: String?
    var note: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String,
        name: String,
        phone: String,
        gender: String? = nil,
        birthday: Date? = nil,
        level: String = "普通",
        address: String? = nil,
        tags: [String] = [],
        totalSpent: Double = 0,
        totalOrders: Int = 0,
        lastOrderDate: Date? = nil,
        source: String? = nil,
        note: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.gender = gender
        self.birthday = birthday
        self.level = level
        self.address = address
        self.tags = tags
        self.totalSpent = totalSpent
        self.totalOrders = totalOrders
        self.lastOrderDate = lastOrderDate
        self.source = source
        self.note = note
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - DTO

struct CustomerDTO: Codable, Sendable {
    var id: String
    var name: String
    var phone: String
    var gender: String?
    var birthday: Date?
    var level: String
    var address: String?
    var tags: [String]
    var totalSpent: Double
    var totalOrders: Int
    var lastOrderDate: Date?
    var source: String?
    var note: String?
    var createdAt: Date
    var updatedAt: Date
    
    func toCustomer() -> Customer {
        Customer(
            id: id,
            name: name,
            phone: phone,
            gender: gender,
            birthday: birthday,
            level: level,
            address: address,
            tags: tags,
            totalSpent: totalSpent,
            totalOrders: totalOrders,
            lastOrderDate: lastOrderDate,
            source: source,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
