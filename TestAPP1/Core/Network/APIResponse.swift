//
//  APIResponse.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 服务端统一响应格式
struct APIResponse<T: Decodable>: Decodable, Sendable {
    var code: Int
    var message: String
    var data: T?
    
    /// 判断是否成功
    var isSuccess: Bool {
        code == 200
    }
    
    /// 获取数据，如果失败则抛出错误
    func getData() throws -> T {
        guard isSuccess, let data = data else {
            throw NetworkError.serverError(statusCode: code)
        }
        return data
    }
}

