//
//  APIDataProvider.swift
//  TestAPP1
//
//  Created by Tianzhe Dong on 2025/12/26.
//

import Foundation

/// 真实API数据提供者
/// 通过NetworkManager调用服务端接口
actor APIDataProvider: DataProviderProtocol {
    
    private let networkManager = NetworkManager.shared
    
    // MARK: - 认证相关
    
    func login(username: String, password: String) async throws -> User {
        // TODO: 实现登录接口
        throw NetworkError.notImplemented
    }
    
    // MARK: - Dashboard数据
    
    func fetchDashboardData() async throws -> DashboardData {
        // 获取当前门店ID（从UserManager获取，如果没有则使用默认值）
        let storeId = UserManager.shared.getCurrentStoreId()
        print("📊 开始获取Dashboard数据，门店ID: \(storeId)")
        
        // 并行请求多个接口
        async let todayData = fetchDashboardToday(storeId: storeId)
        async let rankingData = fetchDashboardRanking(storeId: storeId, period: "DAILY")
        async let todosData = fetchDashboardTodos(storeId: storeId)
        
        // 等待所有请求完成
        let (today, ranking, todos) = try await (todayData, rankingData, todosData)
        
        print("✅ Dashboard数据获取成功:")
        print("   今日销售额: \(today.salesAmount)")
        print("   客流量: \(today.customerCount)")
        print("   订单数: \(today.orderCount)")
        print("   排名: \(ranking.currentRank)/\(ranking.totalStores)")
        
        // 转换为DashboardData
        let result = convertToDashboardData(today: today, ranking: ranking, todos: todos)
        
        print("✅ DashboardData转换完成:")
        print("   todaySales: \(result.todaySales)")
        print("   todayTraffic: \(result.todayTraffic)")
        print("   todayOrders: \(result.todayOrders)")
        
        return result
    }
    
    // MARK: - 私有方法：调用具体接口
    
    /// 获取今日核心指标
    private func fetchDashboardToday(storeId: String) async throws -> DashboardTodayDTO {
        let endpoint = APIEndpoint.dashboardToday(storeId: storeId)
        print("📡 请求今日数据: \(endpoint.path)")
        do {
            let result = try await networkManager.get(endpoint: endpoint) as DashboardTodayDTO
            print("✅ 今日数据获取成功: \(result)")
            return result
        } catch {
            print("❌ 今日数据获取失败: \(error)")
            throw error
        }
    }
    
    /// 获取门店排名
    private func fetchDashboardRanking(storeId: String, period: String?) async throws -> DashboardRankingDTO {
        let endpoint = APIEndpoint.dashboardRanking(storeId: storeId, period: period)
        return try await networkManager.get(endpoint: endpoint)
    }
    
    /// 获取待办事项
    private func fetchDashboardTodos(storeId: String) async throws -> DashboardTodosDTO {
        let endpoint = APIEndpoint.dashboardTodos(storeId: storeId)
        return try await networkManager.get(endpoint: endpoint)
    }
    
    /// 将多个DTO转换为DashboardData
    private func convertToDashboardData(
        today: DashboardTodayDTO,
        ranking: DashboardRankingDTO,
        todos: DashboardTodosDTO
    ) -> DashboardData {
        // 计算昨日数据（从今日数据和增长率反推）
        let yesterdaySales = today.yesterdaySalesAmount
        
        // 根据增长率计算昨日客流量和订单数
        // 增长率 = (今日 - 昨日) / 昨日 * 100
        // 昨日 = 今日 / (1 + 增长率/100)
        // 注意：当增长率为-100%时，分母为0，需要特殊处理
        let growthFactor = 1.0 + today.dayOverDayGrowth / 100.0
        
        // 安全检查：避免除以0或负数
        let safeGrowthFactor = max(0.01, abs(growthFactor)) // 至少为0.01，避免除以0
        
        let yesterdayTraffic: Int
        let yesterdayOrders: Int
        
        if growthFactor > 0 {
            yesterdayTraffic = Int(Double(today.customerCount) / growthFactor)
            yesterdayOrders = Int(Double(today.orderCount) / growthFactor)
        } else {
            // 如果增长率为负数且接近-100%，使用昨日销售额反推
            // 假设客单价和转化率变化不大，用销售额比例估算
            let salesRatio = yesterdaySales > 0 ? today.salesAmount / yesterdaySales : 1.0
            yesterdayTraffic = Int(Double(today.customerCount) / max(salesRatio, 0.01))
            yesterdayOrders = Int(Double(today.orderCount) / max(salesRatio, 0.01))
        }
        
        // 昨日客单价 = 昨日销售额 / 昨日订单数
        let yesterdayAvgOrderValue = yesterdaySales / Double(max(yesterdayOrders, 1))
        
        // 昨日转化率（简化计算，使用今日转化率减去增长率影响）
        // 注意：这里假设转化率变化与整体增长率相关，实际应该从服务端获取
        let conversionRateChange = today.dayOverDayGrowth / 100.0
        let yesterdayConversionRate = max(0, min(100, today.conversionRate * (1.0 - conversionRateChange)))
        
        return DashboardData(
            todaySales: today.salesAmount,
            yesterdaySales: yesterdaySales,
            todayTraffic: today.customerCount,
            yesterdayTraffic: max(0, yesterdayTraffic),
            todayOrders: today.orderCount,
            yesterdayOrders: max(0, yesterdayOrders),
            todayAvgOrderValue: today.avgOrderAmount,
            yesterdayAvgOrderValue: yesterdayAvgOrderValue,
            conversionRate: today.conversionRate,
            yesterdayConversionRate: yesterdayConversionRate,
            storeRanking: ranking.currentRank,
            totalStores: ranking.totalStores,
            monthSales: today.monthlyCompleted,
            monthTarget: today.monthlyTarget,
            pendingOrders: todos.pendingOrderCount,
            lowStockCount: todos.inventoryWarningCount,
            pendingCustomers: todos.followUpCustomerCount
        )
    }
    
    // MARK: - 分析数据
    
    func fetchAnalyticsData(period: AnalyticsPeriod) async throws -> AnalyticsData {
        // 获取当前门店ID
        let storeId = UserManager.shared.getCurrentStoreId()
        print("📊 开始获取分析数据，门店ID: \(storeId), 维度: \(period.rawValue)")
        
        // 将AnalyticsPeriod转换为服务端格式
        let periodString: String
        switch period {
        case .day:
            periodString = "daily"
        case .week:
            periodString = "weekly"
        case .month:
            periodString = "monthly"
        }
        
        // 调用接口
        let endpoint = APIEndpoint.analytics(
            period: periodString,
            storeId: storeId,
            startDate: nil,
            endDate: nil
        )
        
        print("📡 请求分析数据: \(endpoint.path)")
        
        do {
            let dto = try await networkManager.get(endpoint: endpoint) as AnalyticsDataDTO
            print("✅ 分析数据获取成功 (维度: \(period.rawValue)):")
            if let hourlySales = dto.hourlySales {
                print("   hourlySales数量: \(hourlySales.count)")
                if !hourlySales.isEmpty {
                    print("   前3条hourlySales: \(hourlySales.prefix(3).map { "hour:\($0.hour), sales:\($0.salesAmount)" })")
                }
            }
            if let dailySales = dto.dailySales {
                print("   dailySales数量: \(dailySales.count)")
                if !dailySales.isEmpty {
                    print("   前3条dailySales: \(dailySales.prefix(3).map { "day:\($0.day ?? 0), date:\($0.date ?? ""), sales:\($0.salesAmount)" })")
                }
            }
            if let year = dto.year, let month = dto.month {
                print("   年月: \(year)-\(month)")
            }
            if let salesTrend = dto.salesTrend {
                print("   salesTrend数量: \(salesTrend.count)")
            }
            print("   品类数量: \(dto.categorySales?.count ?? 0)")
            if let categorySales = dto.categorySales, !categorySales.isEmpty {
                print("   品类详情: \(categorySales.map { "\($0.name): \($0.amount)" })")
            }
            print("   热销商品数: \(dto.topProducts?.count ?? 0)")
            if let topProducts = dto.topProducts, !topProducts.isEmpty {
                print("   热销商品详情: \(topProducts.map { "\($0.productName): \($0.amount)" })")
            }
            
            // 转换为AnalyticsData
            let result = convertToAnalyticsData(dto: dto, period: period)
            print("✅ AnalyticsData转换完成 (维度: \(period.rawValue)):")
            print("   销售趋势点数: \(result.salesTrend.count)")
            if !result.salesTrend.isEmpty {
                print("   前3条销售趋势: \(result.salesTrend.prefix(3).map { "\($0.label): \($0.value)" })")
            } else {
                print("   ⚠️ 销售趋势数据为空！")
            }
            print("   品类数量: \(result.categorySales.count)")
            print("   热销商品数: \(result.topProducts.count)")
            return result
        } catch {
            print("❌ 分析数据获取失败: \(error)")
            throw error
        }
    }
    
    /// 将AnalyticsDataDTO转换为AnalyticsData
    private func convertToAnalyticsData(dto: AnalyticsDataDTO, period: AnalyticsPeriod) -> AnalyticsData {
        // 转换销售趋势数据
        var salesTrend: [SalesTrendPoint] = []
        
        switch period {
        case .day:
            // 日维度：使用hourlySales
            if let hourlySales = dto.hourlySales {
                salesTrend = hourlySales.map { hourly -> SalesTrendPoint in
                    let time = String(format: "%02d:00", hourly.hour)
                    let label = "\(hourly.hour)时"
                    return SalesTrendPoint(
                        time: time,
                        value: hourly.salesAmount,
                        label: label
                    )
                }
            } else if let salesTrendData = dto.salesTrend {
                // 兼容旧格式
                salesTrend = salesTrendData.map { point -> SalesTrendPoint in
                    let time: String
                    let label: String
                    if let hour = point.hour {
                        time = String(format: "%02d:00", hour)
                        label = "\(hour)时"
                    } else {
                        time = ""
                        label = ""
                    }
                    return SalesTrendPoint(
                        time: time,
                        value: point.sales,
                        label: label
                    )
                }
            }
        case .week, .month:
            // 周/月维度：优先使用dailySales
            if let dailySales = dto.dailySales {
                print("   使用dailySales数据，数量: \(dailySales.count)")
                salesTrend = dailySales.map { daily -> SalesTrendPoint in
                    // 获取日期字符串（根据day或date字段）
                    let dateString = daily.getDateString(year: dto.year, month: dto.month)
                    let label: String
                    if period == .week {
                        label = formatWeekDate(dateString)
                    } else {
                        // 月维度：显示天数（day）
                        if let day = daily.day {
                            label = "\(day)日"
                        } else {
                            label = formatMonthDate(dateString)
                        }
                    }
                    return SalesTrendPoint(
                        time: dateString,
                        value: daily.salesAmount,
                        label: label
                    )
                }
            } else if let hourlySales = dto.hourlySales {
                // 服务端可能对周/月维度也使用hourlySales，但hour字段可能表示日期索引
                print("   使用hourlySales数据（周/月维度），数量: \(hourlySales.count)")
                salesTrend = hourlySales.map { hourly -> SalesTrendPoint in
                    // 对于周/月维度，hour可能表示日期索引，需要根据period计算实际日期
                    let dateString = calculateDateFromHour(hour: hourly.hour, period: period)
                    let label = period == .week ? formatWeekDate(dateString) : formatMonthDate(dateString)
                    return SalesTrendPoint(
                        time: dateString,
                        value: hourly.salesAmount,
                        label: label
                    )
                }
            } else if let salesTrendData = dto.salesTrend {
                // 兼容旧格式
                print("   使用salesTrend数据（兼容格式），数量: \(salesTrendData.count)")
                salesTrend = salesTrendData.map { point -> SalesTrendPoint in
                    let time = point.date ?? ""
                    let label = period == .week ? formatWeekDate(time) : formatMonthDate(time)
                    return SalesTrendPoint(
                        time: time,
                        value: point.sales,
                        label: label
                    )
                }
            } else {
                print("   ⚠️ 周/月维度没有找到销售趋势数据")
            }
        }
        
        // 转换品类销售数据（过滤掉无效数据）
        let categorySales = (dto.categorySales ?? [])
            .filter { categoryDto -> Bool in
                // 至少需要有categoryName或category字段，或者有销售额
                let hasName = (categoryDto.categoryName != nil && !categoryDto.categoryName!.isEmpty) || 
                             (categoryDto.category != nil && !categoryDto.category!.isEmpty)
                let hasAmount = categoryDto.amount > 0
                return hasName || hasAmount
            }
            .map { categoryDto -> CategorySales in
                CategorySales(
                    category: categoryDto.name,
                    amount: categoryDto.amount,
                    percentage: categoryDto.percentage ?? 0,
                    icon: getCategoryIcon(categoryDto.name)
                )
            }
        
        // 转换热销商品数据
        let topProducts = (dto.topProducts ?? []).enumerated().map { index, dto -> TopProduct in
            TopProduct(
                rank: index + 1,
                productId: dto.productId,
                productName: dto.productName,
                salesCount: dto.quantity,
                salesAmount: dto.amount
            )
        }
        
        // 计算总销售额和总订单数
        let totalSales: Double
        let totalOrders: Int
        
        switch period {
        case .day:
            if let hourlySales = dto.hourlySales {
                totalSales = hourlySales.reduce(0) { $0 + $1.salesAmount }
                totalOrders = hourlySales.reduce(0) { $0 + $1.orderCount }
            } else if let salesTrendData = dto.salesTrend {
                totalSales = salesTrendData.reduce(0) { $0 + $1.sales }
                totalOrders = salesTrendData.compactMap { $0.orders }.reduce(0, +)
            } else {
                totalSales = 0
                totalOrders = 0
            }
        case .week, .month:
            if let dailySales = dto.dailySales {
                totalSales = dailySales.reduce(0) { $0 + $1.salesAmount }
                totalOrders = dailySales.reduce(0) { $0 + $1.orderCount }
            } else if let hourlySales = dto.hourlySales {
                // 周/月维度也可能使用hourlySales
                totalSales = hourlySales.reduce(0) { $0 + $1.salesAmount }
                totalOrders = hourlySales.reduce(0) { $0 + $1.orderCount }
            } else if let salesTrendData = dto.salesTrend {
                totalSales = salesTrendData.reduce(0) { $0 + $1.sales }
                totalOrders = salesTrendData.compactMap { $0.orders }.reduce(0, +)
            } else {
                totalSales = 0
                totalOrders = 0
            }
        }
        
        let avgOrderValue = totalOrders > 0 ? totalSales / Double(totalOrders) : 0
        
        return AnalyticsData(
            period: period.rawValue,
            salesTrend: salesTrend,
            categorySales: categorySales,
            topProducts: topProducts,
            totalSales: totalSales,
            totalOrders: totalOrders,
            avgOrderValue: avgOrderValue,
            yearOverYearGrowth: 0, // 服务端暂未返回，后续补充
            monthOverMonthGrowth: 0 // 服务端暂未返回，后续补充
        )
    }
    
    /// 格式化周维度日期
    private func formatWeekDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "MM-dd"
        return formatter.string(from: date)
    }
    
    /// 格式化月维度日期
    private func formatMonthDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    /// 根据hour和period计算实际日期（用于周/月维度）
    /// 注意：这个方法假设hour表示日期索引，实际可能需要根据服务端返回的数据格式调整
    private func calculateDateFromHour(hour: Int, period: AnalyticsPeriod) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .week:
            // 周维度：hour可能表示本周的第几天（0-6，0表示周一）
            // 或者表示从周一开始的天数偏移
            let weekday = calendar.component(.weekday, from: now)
            let mondayOffset = (weekday + 5) % 7 // 转换为周一为0
            let targetDay = hour - mondayOffset
            if let date = calendar.date(byAdding: .day, value: targetDay, to: now) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: date)
            }
        case .month:
            // 月维度：hour可能表示本月的第几天（1-31）
            let components = calendar.dateComponents([.year, .month], from: now)
            if let firstDay = calendar.date(from: components),
               let targetDate = calendar.date(byAdding: .day, value: hour - 1, to: firstDay) {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: targetDate)
            }
        case .day:
            // 日维度不需要此方法
            break
        }
        
        // 如果计算失败，返回当前日期
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: now)
    }
    
    /// 获取品类图标
    private func getCategoryIcon(_ category: String) -> String {
        switch category {
        case "手机":
            return "📱"
        case "平板":
            return "📱"
        case "笔记本":
            return "💻"
        case "配件":
            return "🔌"
        case "智能硬件":
            return "🏠"
        default:
            return "📦"
        }
    }
    
    // MARK: - 门店相关
    
    func fetchStores() async throws -> [Store] {
        // TODO: 实现门店列表接口
        throw NetworkError.notImplemented
    }
    
    func fetchStore(id: String) async throws -> Store {
        // TODO: 实现门店详情接口
        throw NetworkError.notImplemented
    }
    
    // MARK: - 商品相关
    
    func fetchProducts() async throws -> [Product] {
        // TODO: 实现商品列表接口
        throw NetworkError.notImplemented
    }
    
    func fetchProducts(category: String) async throws -> [Product] {
        // TODO: 实现分类商品接口
        throw NetworkError.notImplemented
    }
    
    func searchProducts(keyword: String) async throws -> [Product] {
        // TODO: 实现商品搜索接口
        throw NetworkError.notImplemented
    }
    
    // MARK: - 订单相关
    
    func fetchOrders() async throws -> [Order] {
        return try await fetchOrders(status: nil, startDate: nil, endDate: nil, keyword: nil, page: nil, pageSize: nil)
    }
    
    func fetchOrders(status: String) async throws -> [Order] {
        return try await fetchOrders(status: status, startDate: nil, endDate: nil, keyword: nil, page: nil, pageSize: nil)
    }
    
    /// 获取订单列表（支持筛选和分页）
    private func fetchOrders(
        status: String?,
        startDate: String?,
        endDate: String?,
        keyword: String?,
        page: Int?,
        pageSize: Int?
    ) async throws -> [Order] {
        let storeId = UserManager.shared.getCurrentStoreId()
        print("📊 开始获取订单列表，门店ID: \(storeId)")
        
        let endpoint = APIEndpoint.orders(
            storeId: storeId,
            orderStatus: status,
            startDate: startDate,
            endDate: endDate,
            keyword: keyword,
            page: page ?? 1,
            pageSize: pageSize ?? 100  // 默认100条，避免分页
        )
        
        print("📡 请求订单列表: \(endpoint.path)")
        
        do {
            let response = try await networkManager.get(endpoint: endpoint) as OrderListDTO
            print("✅ 订单列表获取成功，数量: \(response.list.count)")
            
            // 转换为Order模型
            let orders = response.list.map { $0.toOrder() }
            return orders
        } catch {
            print("❌ 订单列表获取失败: \(error)")
            throw error
        }
    }
    
    func createOrder(_ order: Order) async throws -> Order {
        let storeId = UserManager.shared.getCurrentStoreId()
        print("📊 开始创建订单，门店ID: \(storeId)")
        
        // 构建请求DTO
        let request = CreateOrderRequestDTO(
            storeId: storeId,
            customerId: order.customerId,
            items: order.items.map { item in
                CreateOrderItemDTO(
                    productId: item.productId,
                    quantity: item.quantity
                )
            },
            paymentMethod: convertPaymentMethodToServer(order.paymentMethod),
            discountAmount: order.discountAmount > 0 ? order.discountAmount : nil,
            remark: order.note.isEmpty ? nil : order.note
        )
        
        let endpoint = APIEndpoint.createOrder
        print("📡 请求创建订单: \(endpoint.path)")
        
        do {
            let response = try await networkManager.post(endpoint: endpoint, body: request) as OrderDTO
            print("✅ 订单创建成功，订单号: \(response.orderNo)")
            
            return response.toOrder()
        } catch {
            print("❌ 订单创建失败: \(error)")
            throw error
        }
    }
    
    /// 获取订单详情
    func fetchOrderDetail(id: String) async throws -> Order {
        let endpoint = APIEndpoint.orderDetail(id: id)
        print("📡 请求订单详情: \(endpoint.path)")
        
        do {
            let response = try await networkManager.get(endpoint: endpoint) as OrderDTO
            print("✅ 订单详情获取成功，订单号: \(response.orderNo)")
            
            return response.toOrder()
        } catch {
            print("❌ 订单详情获取失败: \(error)")
            throw error
        }
    }
    
    /// 取消订单
    func cancelOrder(id: String, reason: String) async throws {
        let endpoint = APIEndpoint.cancelOrder(id: id)
        print("📡 请求取消订单: \(endpoint.path)")
        
        let request = CancelOrderRequestDTO(reason: reason)
        
        do {
            // 取消订单接口返回null，不需要解析响应
            _ = try await networkManager.put(endpoint: endpoint, body: request) as APIResponse<EmptyResponse>
            print("✅ 订单取消成功")
        } catch {
            print("❌ 订单取消失败: \(error)")
            throw error
        }
    }
    
    /// 转换支付方式为服务端格式
    private func convertPaymentMethodToServer(_ method: String) -> String {
        switch method {
        case "现金":
            return "CASH"
        case "微信支付":
            return "WECHAT"
        case "支付宝":
            return "ALIPAY"
        case "银行卡":
            return "CARD"
        default:
            return "CASH"
        }
    }
    
    /// 空响应类型（用于取消订单等返回null的接口）
    struct EmptyResponse: Codable, Sendable {
        init() {}
    }
    
    // MARK: - 员工相关
    
    func fetchEmployees() async throws -> [Employee] {
        // TODO: 实现员工列表接口
        throw NetworkError.notImplemented
    }
    
    func fetchEmployees(storeId: String) async throws -> [Employee] {
        // TODO: 实现门店员工接口
        throw NetworkError.notImplemented
    }
    
    // MARK: - 客户相关
    
    func fetchCustomers() async throws -> [Customer] {
        // TODO: 实现客户列表接口
        throw NetworkError.notImplemented
    }
    
    func searchCustomers(keyword: String) async throws -> [Customer] {
        // TODO: 实现客户搜索接口
        throw NetworkError.notImplemented
    }
    
    func createCustomer(_ customer: Customer) async throws -> Customer {
        // TODO: 实现创建客户接口
        throw NetworkError.notImplemented
    }
}

