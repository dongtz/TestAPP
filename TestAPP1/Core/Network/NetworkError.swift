//
//  NetworkError.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 网络请求错误类型
enum NetworkError: LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case serverError(statusCode: Int)
    case decodingError
    case notImplemented
    case cancelled  // 请求被取消
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL地址"
        case .noInternetConnection:
            return "网络连接失败，请检查网络设置"
        case .timeout:
            return "请求超时，请稍后重试"
        case .serverError(let statusCode):
            return "服务器错误（\(statusCode)）"
        case .decodingError:
            return "数据解析失败"
        case .notImplemented:
            return "接口尚未实现"
        case .cancelled:
            return "请求已取消"
        case .unknown(let error):
            return "未知错误: \(error.localizedDescription)"
        }
    }
}



