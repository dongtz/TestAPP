//
//  OrderDTO.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2026/01/05.
//

import Foundation

/// 订单明细DTO（服务端返回格式）
struct OrderItemDTO: Codable, Sendable {
    var id: String?
    var productId: String  // 服务端可能返回Long，需要转换
    var productName: String
    var productImage: String?
    var productPrice: Double
    var quantity: Int
    var subtotal: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case productName
        case productImage
        case productPrice
        case quantity
        case subtotal
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // id可能是Long或String
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            id = try? container.decodeIfPresent(String.self, forKey: .id)
        }
        
        // productId可能是Long或String
        if let productIdInt = try? container.decode(Int.self, forKey: .productId) {
            productId = String(productIdInt)
        } else {
            productId = try container.decode(String.self, forKey: .productId)
        }
        
        productName = try container.decode(String.self, forKey: .productName)
        productImage = try? container.decodeIfPresent(String.self, forKey: .productImage)
        productPrice = try container.decode(Double.self, forKey: .productPrice)
        quantity = try container.decode(Int.self, forKey: .quantity)
        subtotal = try container.decode(Double.self, forKey: .subtotal)
    }
    
    /// 转换为OrderItem
    func toOrderItem() -> OrderItem {
        OrderItem(
            productId: productId,
            productName: productName,
            productModel: "", // 服务端未返回，使用空字符串
            price: productPrice,
            quantity: quantity,
            subtotal: subtotal
        )
    }
}

/// 订单DTO（服务端返回格式）
struct OrderDTO: Codable, Sendable {
    var id: String
    var orderNo: String  // 服务端返回的是orderNo，不是orderNumber
    var storeId: String
    var storeName: String?
    var customerId: String?
    var customerName: String?
    var customerPhone: String?
    var employeeId: String
    var employeeName: String?
    var totalAmount: Double  // 服务端返回的是totalAmount，对应订单总金额
    var discountAmount: Double
    var actualAmount: Double  // 服务端返回的是actualAmount，对应实付金额
    var paymentMethod: String
    var paymentMethodDesc: String?
    var orderStatus: String  // 服务端返回的是orderStatus（PENDING/PAID/CANCELLED/REFUNDED）
    var orderStatusDesc: String?
    var remark: String?
    var createdAt: String  // 服务端返回的是字符串格式的日期
    var paidAt: String?
    var completedAt: String?
    var items: [OrderItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderNo
        case storeId
        case storeName
        case customerId
        case customerName
        case customerPhone
        case employeeId
        case employeeName
        case totalAmount
        case discountAmount
        case actualAmount
        case paymentMethod
        case paymentMethodDesc
        case orderStatus
        case orderStatusDesc
        case remark
        case createdAt
        case paidAt
        case completedAt
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // id可能是Long或String
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        
        orderNo = try container.decode(String.self, forKey: .orderNo)
        
        // storeId可能是Long或String
        if let storeIdInt = try? container.decode(Int.self, forKey: .storeId) {
            storeId = String(storeIdInt)
        } else {
            storeId = try container.decode(String.self, forKey: .storeId)
        }
        
        storeName = try? container.decodeIfPresent(String.self, forKey: .storeName)
        
        // customerId可能是Long或String或null
        if let customerIdInt = try? container.decodeIfPresent(Int.self, forKey: .customerId) {
            customerId = String(customerIdInt)
        } else {
            customerId = try? container.decodeIfPresent(String.self, forKey: .customerId)
        }
        
        customerName = try? container.decodeIfPresent(String.self, forKey: .customerName)
        customerPhone = try? container.decodeIfPresent(String.self, forKey: .customerPhone)
        
        // employeeId可能是Long或String
        if let employeeIdInt = try? container.decode(Int.self, forKey: .employeeId) {
            employeeId = String(employeeIdInt)
        } else {
            employeeId = try container.decode(String.self, forKey: .employeeId)
        }
        
        employeeName = try? container.decodeIfPresent(String.self, forKey: .employeeName)
        totalAmount = try container.decode(Double.self, forKey: .totalAmount)
        discountAmount = try container.decode(Double.self, forKey: .discountAmount)
        actualAmount = try container.decode(Double.self, forKey: .actualAmount)
        paymentMethod = try container.decode(String.self, forKey: .paymentMethod)
        paymentMethodDesc = try? container.decodeIfPresent(String.self, forKey: .paymentMethodDesc)
        orderStatus = try container.decode(String.self, forKey: .orderStatus)
        orderStatusDesc = try? container.decodeIfPresent(String.self, forKey: .orderStatusDesc)
        remark = try? container.decodeIfPresent(String.self, forKey: .remark)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        paidAt = try? container.decodeIfPresent(String.self, forKey: .paidAt)
        completedAt = try? container.decodeIfPresent(String.self, forKey: .completedAt)
        items = try container.decode([OrderItemDTO].self, forKey: .items)
    }
    
    /// 转换为Order模型
    func toOrder() -> Order {
        // 解析日期字符串（支持多种格式）
        let createdAtDate = parseDate(createdAt) ?? Date()
        let paidAtDate = paidAt.flatMap { parseDate($0) }
        let completedAtDate = completedAt.flatMap { parseDate($0) }
        
        // 转换订单状态（服务端返回的是PENDING/PAID/CANCELLED/REFUNDED，需要转换为中文）
        let status = convertOrderStatus(orderStatus)
        
        // 转换支付方式（服务端返回的是CASH/WECHAT/ALIPAY/CARD，需要转换为中文）
        let paymentMethodStr = convertPaymentMethod(paymentMethod)
        
        return Order(
            id: id,
            orderNumber: orderNo,
            storeId: storeId,
            customerId: customerId,
            customerName: customerName,
            employeeId: employeeId,
            items: items.map { $0.toOrderItem() },
            subtotalAmount: totalAmount,  // 订单总金额
            discountAmount: discountAmount,
            totalAmount: actualAmount,  // 实付金额
            paymentMethod: paymentMethodStr,
            status: status,
            note: remark ?? "",
            createdAt: createdAtDate,
            paidAt: paidAtDate,
            completedAt: completedAtDate,
            updatedAt: createdAtDate
        )
    }
    
    /// 转换订单状态
    private func convertOrderStatus(_ status: String) -> String {
        switch status.uppercased() {
        case "PENDING":
            return "待支付"
        case "PAID":
            return "已支付"
        case "CANCELLED":
            return "已取消"
        case "REFUNDED":
            return "已退款"
        default:
            return status
        }
    }
    
    /// 转换支付方式
    private func convertPaymentMethod(_ method: String) -> String {
        switch method.uppercased() {
        case "CASH":
            return "现金"
        case "WECHAT":
            return "微信支付"
        case "ALIPAY":
            return "支付宝"
        case "CARD":
            return "银行卡"
        default:
            return method
        }
    }
    
    /// 解析日期字符串（支持多种格式）
    private func parseDate(_ dateString: String) -> Date? {
        // 尝试ISO8601格式（带毫秒）
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        
        // 尝试ISO8601格式（不带毫秒）
        iso8601Formatter.formatOptions = [.withInternetDateTime]
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        
        // 尝试标准格式：yyyy-MM-dd HH:mm:ss
        let standardFormatter = DateFormatter()
        standardFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        standardFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = standardFormatter.date(from: dateString) {
            return date
        }
        
        // 尝试格式：yyyy-MM-dd'T'HH:mm:ss
        standardFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = standardFormatter.date(from: dateString) {
            return date
        }
        
        return nil
    }
}

/// 订单列表响应DTO
struct OrderListDTO: Codable, Sendable {
    var list: [OrderDTO]
    var total: Int
    var page: Int
    var pageSize: Int
    var totalPages: Int?
}

/// 创建订单请求DTO
struct CreateOrderRequestDTO: Codable, Sendable {
    var storeId: String
    var customerId: String?
    var items: [CreateOrderItemDTO]
    var paymentMethod: String
    var discountAmount: Double?
    var remark: String?
}

/// 创建订单商品项DTO
struct CreateOrderItemDTO: Codable, Sendable {
    var productId: String
    var quantity: Int
}

/// 取消订单请求DTO
struct CancelOrderRequestDTO: Codable, Sendable {
    var reason: String
}

