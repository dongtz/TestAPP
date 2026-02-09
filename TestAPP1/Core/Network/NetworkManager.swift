//
//  NetworkManager.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 网络请求管理器（后续接入真实API时使用）
actor NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    /// 发送GET请求（返回统一响应格式）
    func get<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        guard let url = URL(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = AppConstants.Data.networkTimeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 添加认证Token
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "NetworkManager", code: -1))
            }
            
            // 检查HTTP状态码
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ HTTP状态码错误: \(httpResponse.statusCode)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("   响应内容: \(jsonString)")
                }
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 打印原始响应数据（用于调试）
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 收到完整响应: \(jsonString)")
            }
            
            // 解析统一响应格式
            // 服务端返回的可能是camelCase或snake_case，先尝试camelCase
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            
            print("📥 响应状态码: \(apiResponse.code), 消息: \(apiResponse.message)")
            
            // 检查业务状态码
            guard apiResponse.isSuccess else {
                print("❌ 业务状态码错误: \(apiResponse.code), 消息: \(apiResponse.message)")
                throw NetworkError.serverError(statusCode: apiResponse.code)
            }
            
            // 返回数据
            guard let result = apiResponse.data else {
                print("❌ 响应数据为空")
                throw NetworkError.decodingError
            }
            
            return result
            
        } catch let decodingError as DecodingError {
            print("❌ JSON解析错误详情:")
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("   类型不匹配: 期望 \(type), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
                print("   上下文: \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("   值未找到: 类型 \(type), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .keyNotFound(let key, let context):
                print("   键未找到: \(key.stringValue), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .dataCorrupted(let context):
                print("   数据损坏: \(context.debugDescription)")
                print("   路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            @unknown default:
                print("   未知错误: \(decodingError)")
            }
            throw NetworkError.decodingError
            
        } catch let urlError as URLError {
            // 处理URL错误，特别是请求被取消的情况
            if urlError.code == .cancelled {
                print("⚠️ 网络请求被取消（可能是用户快速刷新导致的）")
                throw NetworkError.cancelled
            } else {
                print("❌ URL错误: \(urlError.localizedDescription), 错误码: \(urlError.code.rawValue)")
                throw NetworkError.unknown(urlError)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    /// 发送POST请求
    func post<T: Decodable, U: Encodable>(endpoint: APIEndpoint, body: U) async throws -> T {
        return try await sendRequest(method: "POST", endpoint: endpoint, body: body)
    }
    
    /// 发送PUT请求
    func put<T: Decodable, U: Encodable>(endpoint: APIEndpoint, body: U) async throws -> T {
        return try await sendRequest(method: "PUT", endpoint: endpoint, body: body)
    }
    
    /// 通用请求方法
    private func sendRequest<T: Decodable, U: Encodable>(method: String, endpoint: APIEndpoint, body: U) async throws -> T {
        guard let url = URL(string: endpoint.path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = AppConstants.Data.networkTimeout
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 添加认证Token
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 添加员工ID（开发阶段使用）
        request.setValue("1", forHTTPHeaderField: "X-Employee-Id")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys  // 使用camelCase，与服务端一致
            request.httpBody = try encoder.encode(body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(NSError(domain: "NetworkManager", code: -1))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ HTTP状态码错误: \(httpResponse.statusCode), 响应: \(jsonString)")
                }
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            // 打印原始响应数据（用于调试）
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 收到完整响应: \(jsonString)")
            }
            
            // 解析统一响应格式
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys  // 使用camelCase，与服务端一致
            
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
            
            print("📥 响应状态码: \(apiResponse.code), 消息: \(apiResponse.message)")
            
            // 检查业务状态码
            guard apiResponse.isSuccess else {
                print("❌ 业务状态码错误: \(apiResponse.code), 消息: \(apiResponse.message)")
                throw NetworkError.serverError(statusCode: apiResponse.code)
            }
            
            // 返回数据（可能为null，如取消订单接口）
            guard let result = apiResponse.data else {
                // 如果data为null，尝试返回一个默认值（对于EmptyResponse）
                if T.self == APIDataProvider.EmptyResponse.self {
                    return APIDataProvider.EmptyResponse() as! T
                }
                print("❌ 响应数据为空")
                throw NetworkError.decodingError
            }
            
            return result
            
        } catch let decodingError as DecodingError {
            print("❌ JSON解析错误详情:")
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("   类型不匹配: 期望 \(type), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .valueNotFound(let type, let context):
                print("   值未找到: 类型 \(type), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .keyNotFound(let key, let context):
                print("   键未找到: \(key.stringValue), 路径: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            case .dataCorrupted(let context):
                print("   数据损坏: \(context.debugDescription)")
            @unknown default:
                print("   未知错误: \(decodingError)")
            }
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    /// 获取认证Token
    private func getAuthToken() -> String? {
        // 从Keychain获取Token
        return KeychainManager.shared.getAuthToken()
    }
}

