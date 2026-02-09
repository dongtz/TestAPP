//
//  Product.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation
import SwiftData

/// 商品分类
enum ProductCategory: String, Codable, CaseIterable {
    case phone = "手机"
    case tablet = "平板"
    case laptop = "笔记本"
    case accessory = "配件"
    case smartDevice = "智能硬件"
}

/// 商品模型
@Model
final class Product {
    /// 商品ID
    var id: String
    /// 商品名称
    var name: String
    /// 商品型号
    var model: String
    /// 品牌
    var brand: String
    /// 分类
    var category: String
    /// 规格描述
    var specification: String
    /// 建议零售价
    var price: Double
    /// 促销价（0表示无促销）
    var promotionPrice: Double
    /// 成本价
    var costPrice: Double
    /// 库存数量
    var stock: Int
    /// 库存预警阈值
    var warningStock: Int
    /// 商品图片URL
    var imageURL: String
    /// 商品描述
    var productDescription: String
    /// 商品标签（新品、热销、促销等）
    var tags: [String]
    /// 是否上架
    var isActive: Bool
    /// 创建时间
    var createdAt: Date
    
    init(
        id: String,
        name: String,
        model: String,
        brand: String,
        category: String,
        specification: String = "",
        price: Double,
        promotionPrice: Double = 0,
        costPrice: Double,
        stock: Int = 0,
        warningStock: Int = 10,
        imageURL: String = "",
        productDescription: String = "",
        tags: [String] = [],
        isActive: Bool = true,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.model = model
        self.brand = brand
        self.category = category
        self.specification = specification
        self.price = price
        self.promotionPrice = promotionPrice
        self.costPrice = costPrice
        self.stock = stock
        self.warningStock = warningStock
        self.imageURL = imageURL
        self.productDescription = productDescription
        self.tags = tags
        self.isActive = isActive
        self.createdAt = createdAt
    }
    
    /// 是否低库存
    var isLowStock: Bool {
        stock > 0 && stock <= warningStock
    }
    
    /// 是否缺货
    var isOutOfStock: Bool {
        stock <= 0
    }
    
    /// 当前售价（优先使用促销价）
    var currentPrice: Double {
        promotionPrice > 0 ? promotionPrice : price
    }
}

// MARK: - 用于JSON解析的DTO

struct ProductDTO: Codable, Sendable {
    var id: String
    var name: String
    var model: String
    var brand: String
    var category: String
    var specification: String
    var price: Double
    var promotionPrice: Double
    var costPrice: Double
    var stock: Int
    var warningStock: Int
    var imageURL: String
    var productDescription: String
    var tags: [String]
    var isActive: Bool
    var createdAt: Date
    
    func toProduct() -> Product {
        Product(
            id: id,
            name: name,
            model: model,
            brand: brand,
            category: category,
            specification: specification,
            price: price,
            promotionPrice: promotionPrice,
            costPrice: costPrice,
            stock: stock,
            warningStock: warningStock,
            imageURL: imageURL,
            productDescription: productDescription,
            tags: tags,
            isActive: isActive,
            createdAt: createdAt
        )
    }
}




