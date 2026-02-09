//
//  Order.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 订单状态
enum OrderStatus: String, Codable {
    case pending = "待支付"
    case paid = "已支付"
    case completed = "已完成"
    case cancelled = "已取消"
    case refunding = "退款中"
    case refunded = "已退款"
}

/// 支付方式
enum PaymentMethod: String, Codable {
    case cash = "现金"
    case alipay = "支付宝"
    case wechat = "微信支付"
    case card = "银行卡"
    case other = "其他"
}

/// 订单商品项
struct OrderItem: Codable, Sendable {
    var productId: String
    var productName: String
    var productModel: String
    var price: Double
    var quantity: Int
    var subtotal: Double
}

/// 订单模型
@Model
final class Order {
    var id: String
    var orderNumber: String
    var storeId: String
    var customerId: String?
    var customerName: String?  // 客户名称（快照，用于显示）
    var employeeId: String
    var items: [OrderItem]
    var subtotalAmount: Double
    var discountAmount: Double
    var totalAmount: Double
    var paymentMethod: String
    var status: String
    var note: String
    var createdAt: Date
    var paidAt: Date?
    var completedAt: Date?
    var updatedAt: Date
    
    init(
        id: String,
        orderNumber: String,
        storeId: String,
        customerId: String? = nil,
        customerName: String? = nil,
        employeeId: String,
        items: [OrderItem] = [],
        subtotalAmount: Double,
        discountAmount: Double = 0,
        totalAmount: Double,
        paymentMethod: String,
        status: String,
        note: String = "",
        createdAt: Date = Date(),
        paidAt: Date? = nil,
        completedAt: Date? = nil,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.storeId = storeId
        self.customerId = customerId
        self.customerName = customerName
        self.employeeId = employeeId
        self.items = items
        self.subtotalAmount = subtotalAmount
        self.discountAmount = discountAmount
        self.totalAmount = totalAmount
        self.paymentMethod = paymentMethod
        self.status = status
        self.note = note
        self.createdAt = createdAt
        self.paidAt = paidAt
        self.completedAt = completedAt
        self.updatedAt = updatedAt
    }
}
