//
//  User.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 用户角色
enum UserRole: String, Codable {
    case manager = "店长"
    case employee = "店员"
    case admin = "管理员"
}

/// 用户模型
@Model
final class User {
    var id: String
    var username: String
    var name: String
    var phone: String
    var role: String
    var storeId: String?
    var avatarURL: String
    var lastLoginAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var isActive: Bool
    
    init(
        id: String,
        username: String,
        name: String,
        phone: String,
        role: String,
        storeId: String? = nil,
        avatarURL: String = "",
        lastLoginAt: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.phone = phone
        self.role = role
        self.storeId = storeId
        self.avatarURL = avatarURL
        self.lastLoginAt = lastLoginAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isActive = isActive
    }
}

// MARK: - DTO

struct UserDTO: Codable, Sendable {
    var id: String
    var username: String
    var name: String
    var phone: String
    var role: String
    var storeId: String?
    var avatarURL: String
    var lastLoginAt: Date?
    var createdAt: Date
    var updatedAt: Date
    var isActive: Bool
    
    func toUser() -> User {
        User(
            id: id,
            username: username,
            name: name,
            phone: phone,
            role: role,
            storeId: storeId,
            avatarURL: avatarURL,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isActive: isActive
        )
    }
}
