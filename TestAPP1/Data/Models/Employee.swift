//
//  Employee.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 员工模型
@Model
final class Employee {
    var id: String
    var employeeNumber: String
    var name: String
    var phone: String
    var role: String
    var storeId: String
    var avatarURL: String
    var hireDate: Date
    var commissionRate: Double
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String,
        employeeNumber: String,
        name: String,
        phone: String,
        role: String,
        storeId: String,
        avatarURL: String = "",
        hireDate: Date,
        commissionRate: Double = 5.0,
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.employeeNumber = employeeNumber
        self.name = name
        self.phone = phone
        self.role = role
        self.storeId = storeId
        self.avatarURL = avatarURL
        self.hireDate = hireDate
        self.commissionRate = commissionRate
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - DTO

struct EmployeeDTO: Codable, Sendable {
    var id: String
    var employeeNumber: String
    var name: String
    var phone: String
    var role: String
    var storeId: String
    var avatarURL: String
    var hireDate: Date
    var commissionRate: Double
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date
    
    func toEmployee() -> Employee {
        Employee(
            id: id,
            employeeNumber: employeeNumber,
            name: name,
            phone: phone,
            role: role,
            storeId: storeId,
            avatarURL: avatarURL,
            hireDate: hireDate,
            commissionRate: commissionRate,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
