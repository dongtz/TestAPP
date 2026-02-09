//
//  MockDataProvider.swift
//  TestAPP1
//
//  Created by AI Assistant on 2025/02/09.
//

import Foundation

/// Mock数据提供者
/// 提供本地Mock数据，无需连接服务端
actor MockDataProvider: DataProviderProtocol {
    
    // MARK: - 模拟网络延迟
    
    private func simulateNetworkDelay() async throws {
        // 模拟100-500ms的网络延迟
        let delay = UInt64.random(in: 100_000_000...500_000_000)
        try await Task.sleep(nanoseconds: delay)
    }
    
    // MARK: - 认证相关
    
    func login(username: String, password: String) async throws -> User {
        try await simulateNetworkDelay()
        
        // 返回Mock用户
        return User(
            id: "user_001",
            username: username,
            name: "张三",
            phone: "13800138000",
            role: "店长",
            storeId: "store_001",
            avatarURL: "",
            lastLoginAt: Date(),
            createdAt: Date().addingTimeInterval(-86400 * 365),
            updatedAt: Date(),
            isActive: true
        )
    }
    
    // MARK: - Dashboard数据
    
    func fetchDashboardData() async throws -> DashboardData {
        try await simulateNetworkDelay()
        
        return DashboardData(
            todaySales: 45680.0,
            yesterdaySales: 42350.0,
            todayTraffic: 156,
            yesterdayTraffic: 142,
            todayOrders: 28,
            yesterdayOrders: 25,
            todayAvgOrderValue: 1631.4,
            yesterdayAvgOrderValue: 1694.0,
            conversionRate: 17.9,
            yesterdayConversionRate: 17.6,
            storeRanking: 3,
            totalStores: 12,
            monthSales: 892560.0,
            monthTarget: 1200000.0,
            pendingOrders: 5,
            lowStockCount: 8,
            pendingCustomers: 3
        )
    }
    
    // MARK: - 分析数据
    
    func fetchAnalyticsData(period: AnalyticsPeriod) async throws -> AnalyticsData {
        try await simulateNetworkDelay()
        
        switch period {
        case .day:
            return generateDailyAnalyticsData()
        case .week:
            return generateWeeklyAnalyticsData()
        case .month:
            return generateMonthlyAnalyticsData()
        }
    }
    
    private func generateDailyAnalyticsData() -> AnalyticsData {
        // 生成24小时的销售数据
        var salesTrend: [SalesTrendPoint] = []
        for hour in 0..<24 {
            let sales: Double
            if hour >= 9 && hour <= 21 {
                // 营业时间段有销售
                sales = Double.random(in: 500...5000)
            } else {
                // 非营业时间段销售额为0或极少
                sales = Double.random(in: 0...200)
            }
            salesTrend.append(SalesTrendPoint(
                time: String(format: "%02d:00", hour),
                value: sales,
                label: "\(hour)时"
            ))
        }
        
        return AnalyticsData(
            period: "日",
            salesTrend: salesTrend,
            categorySales: [
                CategorySales(category: "手机", amount: 28500, percentage: 45, icon: "📱"),
                CategorySales(category: "平板", amount: 12800, percentage: 20, icon: "📱"),
                CategorySales(category: "笔记本", amount: 15200, percentage: 24, icon: "💻"),
                CategorySales(category: "配件", amount: 4500, percentage: 7, icon: "🔌"),
                CategorySales(category: "智能硬件", amount: 2500, percentage: 4, icon: "🏠")
            ],
            topProducts: [
                TopProduct(rank: 1, productId: "p001", productName: "iPhone 15 Pro", salesCount: 12, salesAmount: 95988),
                TopProduct(rank: 2, productId: "p002", productName: "华为 Mate 60 Pro", salesCount: 8, salesAmount: 55992),
                TopProduct(rank: 3, productId: "p003", productName: "iPad Pro 12.9", salesCount: 5, salesAmount: 44995),
                TopProduct(rank: 4, productId: "p004", productName: "MacBook Air M3", salesCount: 4, salesAmount: 35996),
                TopProduct(rank: 5, productId: "p005", productName: "小米14", salesCount: 6, salesAmount: 23994)
            ],
            totalSales: 63500,
            totalOrders: 38,
            avgOrderValue: 1671.05,
            yearOverYearGrowth: 15.8,
            monthOverMonthGrowth: 8.2
        )
    }
    
    private func generateWeeklyAnalyticsData() -> AnalyticsData {
        // 生成7天的销售数据
        let days = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        var salesTrend: [SalesTrendPoint] = []
        
        for (index, day) in days.enumerated() {
            // 周末销售额更高
            let multiplier = (index == 5 || index == 6) ? 1.5 : 1.0
            let sales = Double.random(in: 30000...60000) * multiplier
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = Calendar.current.date(byAdding: .day, value: index - 6, to: Date())!
            
            salesTrend.append(SalesTrendPoint(
                time: dateFormatter.string(from: date),
                value: sales,
                label: day
            ))
        }
        
        return AnalyticsData(
            period: "周",
            salesTrend: salesTrend,
            categorySales: [
                CategorySales(category: "手机", amount: 185600, percentage: 48, icon: "📱"),
                CategorySales(category: "平板", amount: 75600, percentage: 20, icon: "📱"),
                CategorySales(category: "笔记本", amount: 91200, percentage: 24, icon: "💻"),
                CategorySales(category: "配件", amount: 22800, percentage: 6, icon: "🔌"),
                CategorySales(category: "智能硬件", amount: 7600, percentage: 2, icon: "🏠")
            ],
            topProducts: [
                TopProduct(rank: 1, productId: "p001", productName: "iPhone 15 Pro", salesCount: 78, salesAmount: 623922),
                TopProduct(rank: 2, productId: "p002", productName: "华为 Mate 60 Pro", salesCount: 52, salesAmount: 363948),
                TopProduct(rank: 3, productId: "p003", productName: "iPad Pro 12.9", salesCount: 32, salesAmount: 287968),
                TopProduct(rank: 4, productId: "p004", productName: "MacBook Air M3", salesCount: 24, salesAmount: 215976),
                TopProduct(rank: 5, productId: "p006", productName: "AirPods Pro 2", salesCount: 85, salesAmount: 169915)
            ],
            totalSales: 382800,
            totalOrders: 228,
            avgOrderValue: 1678.95,
            yearOverYearGrowth: 18.5,
            monthOverMonthGrowth: 12.3
        )
    }
    
    private func generateMonthlyAnalyticsData() -> AnalyticsData {
        // 生成30天的销售数据
        var salesTrend: [SalesTrendPoint] = []
        let calendar = Calendar.current
        let today = Date()
        
        for day in 1...30 {
            let sales = Double.random(in: 20000...70000)
            
            let components = calendar.dateComponents([.year, .month], from: today)
            var dateComponents = DateComponents(year: components.year, month: components.month, day: day)
            let date = calendar.date(from: dateComponents) ?? today
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            salesTrend.append(SalesTrendPoint(
                time: dateFormatter.string(from: date),
                value: sales,
                label: "\(day)日"
            ))
        }
        
        return AnalyticsData(
            period: "月",
            salesTrend: salesTrend,
            categorySales: [
                CategorySales(category: "手机", amount: 856000, percentage: 50, icon: "📱"),
                CategorySales(category: "平板", amount: 342400, percentage: 20, icon: "📱"),
                CategorySales(category: "笔记本", amount: 410880, percentage: 24, icon: "💻"),
                CategorySales(category: "配件", amount: 85600, percentage: 5, icon: "🔌"),
                CategorySales(category: "智能硬件", amount: 17120, percentage: 1, icon: "🏠")
            ],
            topProducts: [
                TopProduct(rank: 1, productId: "p001", productName: "iPhone 15 Pro", salesCount: 320, salesAmount: 2559680),
                TopProduct(rank: 2, productId: "p002", productName: "华为 Mate 60 Pro", salesCount: 210, salesAmount: 1469790),
                TopProduct(rank: 3, productId: "p003", productName: "iPad Pro 12.9", salesCount: 125, salesAmount: 1124875),
                TopProduct(rank: 4, productId: "p004", productName: "MacBook Air M3", salesCount: 95, salesAmount: 854905),
                TopProduct(rank: 5, productId: "p006", productName: "AirPods Pro 2", salesCount: 350, salesAmount: 699650)
            ],
            totalSales: 1712000,
            totalOrders: 980,
            avgOrderValue: 1746.94,
            yearOverYearGrowth: 22.6,
            monthOverMonthGrowth: 15.8
        )
    }
    
    // MARK: - 门店相关
    
    func fetchStores() async throws -> [Store] {
        try await simulateNetworkDelay()
        
        return [
            Store(id: "store_001", name: "北京朝阳门店", code: "BJCY001", city: "北京", address: "北京市朝阳区建国路88号", phone: "010-12345678", managerName: "张三", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_002", name: "北京西单店", code: "BJXD002", city: "北京", address: "北京市西城区西单北大街120号", phone: "010-87654321", managerName: "李四", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_003", name: "上海南京路店", code: "SHNL003", city: "上海", address: "上海市黄浦区南京东路800号", phone: "021-12345678", managerName: "王五", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_004", name: "上海陆家嘴店", code: "SHLZ004", city: "上海", address: "上海市浦东新区陆家嘴环路1000号", phone: "021-87654321", managerName: "赵六", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_005", name: "广州天河店", code: "GZTH005", city: "广州", address: "广州市天河区天河路208号", phone: "020-12345678", managerName: "孙七", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_006", name: "深圳福田店", code: "SZFT006", city: "深圳", address: "深圳市福田区福华三路168号", phone: "0755-12345678", managerName: "周八", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_007", name: "成都春熙路店", code: "CDCX007", city: "成都", address: "成都市锦江区春熙路8号", phone: "028-12345678", managerName: "吴九", businessHours: "09:00-22:00", status: "营业中"),
            Store(id: "store_008", name: "杭州西湖店", code: "HZXH008", city: "杭州", address: "杭州市上城区延安路258号", phone: "0571-12345678", managerName: "郑十", businessHours: "09:00-22:00", status: "营业中")
        ]
    }
    
    func fetchStore(id: String) async throws -> Store {
        try await simulateNetworkDelay()
        
        let stores = try await fetchStores()
        guard let store = stores.first(where: { $0.id == id }) else {
            throw NetworkError.serverError(statusCode: 404)
        }
        return store
    }
    
    // MARK: - 商品相关
    
    func fetchProducts() async throws -> [Product] {
        try await simulateNetworkDelay()
        return generateMockProducts()
    }
    
    func fetchProducts(category: String) async throws -> [Product] {
        try await simulateNetworkDelay()
        let products = generateMockProducts()
        return products.filter { $0.category == category }
    }
    
    func searchProducts(keyword: String) async throws -> [Product] {
        try await simulateNetworkDelay()
        let products = generateMockProducts()
        return products.filter { 
            $0.name.contains(keyword) || 
            $0.model.contains(keyword) ||
            $0.brand.contains(keyword)
        }
    }
    
    private func generateMockProducts() -> [Product] {
        return [
            // 手机
            Product(id: "p001", name: "iPhone 15 Pro", model: "A3108", brand: "Apple", category: "手机", specification: "256GB 钛金属", price: 8999, promotionPrice: 7999, costPrice: 7500, stock: 45, warningStock: 10, imageURL: "", productDescription: "A17 Pro芯片，钛金属设计", tags: ["热销", "新品"], isActive: true),
            Product(id: "p002", name: "华为 Mate 60 Pro", model: "ALN-AL00", brand: "华为", category: "手机", specification: "12GB+512GB 雅川青", price: 6999, promotionPrice: 0, costPrice: 5800, stock: 32, warningStock: 10, imageURL: "", productDescription: "卫星通话，玄武架构", tags: ["热销"], isActive: true),
            Product(id: "p005", name: "小米14", model: "23127PN0CC", brand: "小米", category: "手机", specification: "12GB+256GB 黑色", price: 3999, promotionPrice: 3799, costPrice: 3200, stock: 68, warningStock: 15, imageURL: "", productDescription: "徕卡光学镜头", tags: ["热销"], isActive: true),
            Product(id: "p007", name: "OPPO Find X7", model: "PHZ110", brand: "OPPO", category: "手机", specification: "16GB+512GB 星空黑", price: 4999, promotionPrice: 0, costPrice: 4200, stock: 25, warningStock: 8, imageURL: "", productDescription: "哈苏影像，天玑9300", tags: [], isActive: true),
            Product(id: "p008", name: "vivo X100 Pro", model: "V2309", brand: "vivo", category: "手机", specification: "16GB+512GB 星迹蓝", price: 5499, promotionPrice: 0, costPrice: 4600, stock: 18, warningStock: 8, imageURL: "", productDescription: "蔡司APO超级长焦", tags: ["新品"], isActive: true),
            
            // 平板
            Product(id: "p003", name: "iPad Pro 12.9", model: "A2436", brand: "Apple", category: "平板", specification: "256GB WiFi版 银色", price: 8999, promotionPrice: 8499, costPrice: 7800, stock: 20, warningStock: 5, imageURL: "", productDescription: "M2芯片，XDR显示屏", tags: ["热销"], isActive: true),
            Product(id: "p009", name: "华为 MatePad Pro", model: "WGR-W09", brand: "华为", category: "平板", specification: "12.6英寸 8GB+256GB", price: 4499, promotionPrice: 0, costPrice: 3800, stock: 15, warningStock: 5, imageURL: "", productDescription: "OLED全面屏，鸿蒙系统", tags: [], isActive: true),
            Product(id: "p010", name: "小米平板6 Pro", model: "23046RP50C", brand: "小米", category: "平板", specification: "11英寸 8GB+256GB", price: 2499, promotionPrice: 2299, costPrice: 2000, stock: 42, warningStock: 10, imageURL: "", productDescription: "骁龙8+，2.8K屏", tags: ["热销"], isActive: true),
            
            // 笔记本
            Product(id: "p004", name: "MacBook Air M3", model: "MRXN3CH/A", brand: "Apple", category: "笔记本", specification: "13.6英寸 8GB+256GB 午夜色", price: 8999, promotionPrice: 8499, costPrice: 7800, stock: 28, warningStock: 8, imageURL: "", productDescription: "M3芯片，轻薄便携", tags: ["热销"], isActive: true),
            Product(id: "p011", name: "华为 MateBook X Pro", model: "MRGFG-16", brand: "华为", category: "笔记本", specification: "14.2英寸 16GB+1TB 深空灰", price: 9999, promotionPrice: 0, costPrice: 8500, stock: 12, warningStock: 5, imageURL: "", productDescription: "微绒金属机身，3.1K原色屏", tags: ["高端"], isActive: true),
            Product(id: "p012", name: "联想 ThinkPad X1 Carbon", model: "21HMA001CD", brand: "联想", category: "笔记本", specification: "14英寸 16GB+512GB 黑色", price: 10999, promotionPrice: 9999, costPrice: 9200, stock: 8, warningStock: 3, imageURL: "", productDescription: "商务旗舰，碳纤维机身", tags: ["高端", "商务"], isActive: true),
            
            // 配件
            Product(id: "p006", name: "AirPods Pro 2", model: "MQD83CH/A", brand: "Apple", category: "配件", specification: "USB-C接口", price: 1999, promotionPrice: 1799, costPrice: 1500, stock: 120, warningStock: 30, imageURL: "", productDescription: "主动降噪，自适应音频", tags: ["热销"], isActive: true),
            Product(id: "p013", name: "华为 FreeBuds Pro 3", model: "T0016", brand: "华为", category: "配件", specification: "冰霜银", price: 1499, promotionPrice: 0, costPrice: 1200, stock: 85, warningStock: 20, imageURL: "", productDescription: "无损音质，智慧降噪", tags: [], isActive: true),
            Product(id: "p014", name: "小米充电宝 20000mAh", model: "PB200SZM", brand: "小米", category: "配件", specification: "50W快充版", price: 199, promotionPrice: 149, costPrice: 100, stock: 200, warningStock: 50, imageURL: "", productDescription: "双向快充，三口输出", tags: ["热销"], isActive: true),
            Product(id: "p015", name: "iPhone 15 Pro 手机壳", model: "MT1F3FE/A", brand: "Apple", category: "配件", specification: "精织斜纹保护壳", price: 479, promotionPrice: 0, costPrice: 300, stock: 65, warningStock: 20, imageURL: "", productDescription: "MagSafe兼容", tags: [], isActive: true),
            
            // 智能硬件
            Product(id: "p016", name: "小米手环8 Pro", model: "M2303B1", brand: "小米", category: "智能硬件", specification: "夜跃黑", price: 399, promotionPrice: 0, costPrice: 280, stock: 150, warningStock: 40, imageURL: "", productDescription: "1.74英寸AMOLED大屏", tags: ["热销"], isActive: true),
            Product(id: "p017", name: "华为 Watch GT 4", model: "ARA-B19", brand: "华为", category: "智能硬件", specification: "46mm 曜石黑", price: 1688, promotionPrice: 0, costPrice: 1300, stock: 35, warningStock: 10, imageURL: "", productDescription: "14天续航，科学运动", tags: [], isActive: true),
            Product(id: "p018", name: "Apple Watch Series 9", model: "MR8U3CH/A", brand: "Apple", category: "智能硬件", specification: "45mm 星光色", price: 3199, promotionPrice: 2999, costPrice: 2600, stock: 22, warningStock: 8, imageURL: "", productDescription: "S9芯片，双击手势", tags: [], isActive: true),
            Product(id: "p019", name: "小米空气净化器4 Pro", model: "AC-M15-SC", brand: "小米", category: "智能硬件", specification: "白色", price: 1299, promotionPrice: 999, costPrice: 800, stock: 18, warningStock: 5, imageURL: "", productDescription: "除醛除菌，99.99%抗菌", tags: [], isActive: true),
            Product(id: "p020", name: "华为智能眼镜2", model: "LFT-G00", brand: "华为", category: "智能硬件", specification: "飞行员光学镜", price: 1999, promotionPrice: 0, costPrice: 1500, stock: 10, warningStock: 3, imageURL: "", productDescription: "开放式聆听，智慧播报", tags: ["新品"], isActive: true)
        ]
    }
    
    // MARK: - 订单相关
    
    func fetchOrders() async throws -> [Order] {
        try await simulateNetworkDelay()
        return generateMockOrders()
    }
    
    func fetchOrders(status: String) async throws -> [Order] {
        try await simulateNetworkDelay()
        let orders = generateMockOrders()
        if status.isEmpty {
            return orders
        }
        return orders.filter { $0.status == status }
    }
    
    func createOrder(_ order: Order) async throws -> Order {
        try await simulateNetworkDelay()
        // 模拟创建订单，返回带订单号的订单
        var newOrder = order
        newOrder.orderNumber = generateOrderNumber()
        newOrder.createdAt = Date()
        newOrder.updatedAt = Date()
        return newOrder
    }
    
    func fetchOrderDetail(id: String) async throws -> Order {
        try await simulateNetworkDelay()
        let orders = generateMockOrders()
        guard let order = orders.first(where: { $0.id == id }) else {
            throw NetworkError.serverError(statusCode: 404)
        }
        return order
    }
    
    func cancelOrder(id: String, reason: String) async throws {
        try await simulateNetworkDelay()
        // 模拟取消订单成功
        print("✅ Mock取消订单成功: \(id), 原因: \(reason)")
    }
    
    private func generateOrderNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = dateFormatter.string(from: Date())
        let randomStr = String(format: "%04d", Int.random(in: 1000...9999))
        return "ORD\(dateStr)\(randomStr)"
    }
    
    private func generateMockOrders() -> [Order] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Order(
                id: "o001",
                orderNumber: "ORD202502090001",
                storeId: "store_001",
                customerId: "c001",
                customerName: "王大明",
                employeeId: "e001",
                items: [
                    OrderItem(productId: "p001", productName: "iPhone 15 Pro", productModel: "A3108", price: 8999, quantity: 1, subtotal: 8999),
                    OrderItem(productId: "p006", productName: "AirPods Pro 2", productModel: "MQD83CH/A", price: 1999, quantity: 1, subtotal: 1999)
                ],
                subtotalAmount: 10998,
                discountAmount: 1000,
                totalAmount: 9998,
                paymentMethod: "微信支付",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .hour, value: -2, to: today)!,
                paidAt: calendar.date(byAdding: .hour, value: -1, to: today)!,
                completedAt: calendar.date(byAdding: .minute, value: -30, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o002",
                orderNumber: "ORD202502090002",
                storeId: "store_001",
                customerId: "c002",
                customerName: "李小红",
                employeeId: "e001",
                items: [
                    OrderItem(productId: "p002", productName: "华为 Mate 60 Pro", productModel: "ALN-AL00", price: 6999, quantity: 1, subtotal: 6999)
                ],
                subtotalAmount: 6999,
                discountAmount: 0,
                totalAmount: 6999,
                paymentMethod: "支付宝",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .hour, value: -4, to: today)!,
                paidAt: calendar.date(byAdding: .hour, value: -3, to: today)!,
                completedAt: calendar.date(byAdding: .hour, value: -2, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o003",
                orderNumber: "ORD202502090003",
                storeId: "store_001",
                customerId: "c003",
                customerName: "张小明",
                employeeId: "e002",
                items: [
                    OrderItem(productId: "p003", productName: "iPad Pro 12.9", productModel: "A2436", price: 8999, quantity: 1, subtotal: 8999),
                    OrderItem(productId: "p015", productName: "iPhone 15 Pro 手机壳", productModel: "MT1F3FE/A", price: 479, quantity: 1, subtotal: 479)
                ],
                subtotalAmount: 9478,
                discountAmount: 500,
                totalAmount: 8978,
                paymentMethod: "银行卡",
                status: "待支付",
                note: "客户要求发票",
                createdAt: calendar.date(byAdding: .minute, value: -30, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o004",
                orderNumber: "ORD202502080001",
                storeId: "store_001",
                customerId: "c004",
                customerName: "刘婷婷",
                employeeId: "e001",
                items: [
                    OrderItem(productId: "p004", productName: "MacBook Air M3", productModel: "MRXN3CH/A", price: 8999, quantity: 1, subtotal: 8999)
                ],
                subtotalAmount: 8999,
                discountAmount: 500,
                totalAmount: 8499,
                paymentMethod: "现金",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                paidAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                completedAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o005",
                orderNumber: "ORD202502080002",
                storeId: "store_001",
                customerId: nil,
                customerName: "散客",
                employeeId: "e003",
                items: [
                    OrderItem(productId: "p014", productName: "小米充电宝 20000mAh", productModel: "PB200SZM", price: 199, quantity: 2, subtotal: 398),
                    OrderItem(productId: "p016", productName: "小米手环8 Pro", productModel: "M2303B1", price: 399, quantity: 1, subtotal: 399)
                ],
                subtotalAmount: 797,
                discountAmount: 50,
                totalAmount: 747,
                paymentMethod: "微信支付",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                paidAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                completedAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o006",
                orderNumber: "ORD202502080003",
                storeId: "store_001",
                customerId: "c005",
                customerName: "陈先生",
                employeeId: "e002",
                items: [
                    OrderItem(productId: "p005", productName: "小米14", productModel: "23127PN0CC", price: 3999, quantity: 1, subtotal: 3999),
                    OrderItem(productId: "p013", productName: "华为 FreeBuds Pro 3", productModel: "T0016", price: 1499, quantity: 1, subtotal: 1499)
                ],
                subtotalAmount: 5498,
                discountAmount: 200,
                totalAmount: 5298,
                paymentMethod: "支付宝",
                status: "已取消",
                note: "客户要求退货",
                createdAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o007",
                orderNumber: "ORD202502080004",
                storeId: "store_001",
                customerId: "c006",
                customerName: "赵女士",
                employeeId: "e001",
                items: [
                    OrderItem(productId: "p008", productName: "vivo X100 Pro", productModel: "V2309", price: 5499, quantity: 1, subtotal: 5499)
                ],
                subtotalAmount: 5499,
                discountAmount: 0,
                totalAmount: 5499,
                paymentMethod: "微信支付",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                paidAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                completedAt: calendar.date(byAdding: .day, value: -1, to: today)!,
                updatedAt: today
            ),
            Order(
                id: "o008",
                orderNumber: "ORD202502070001",
                storeId: "store_001",
                customerId: "c007",
                customerName: "孙先生",
                employeeId: "e002",
                items: [
                    OrderItem(productId: "p007", productName: "OPPO Find X7", productModel: "PHZ110", price: 4999, quantity: 1, subtotal: 4999),
                    OrderItem(productId: "p006", productName: "AirPods Pro 2", productModel: "MQD83CH/A", price: 1999, quantity: 1, subtotal: 1999)
                ],
                subtotalAmount: 6998,
                discountAmount: 300,
                totalAmount: 6698,
                paymentMethod: "银行卡",
                status: "已完成",
                note: "",
                createdAt: calendar.date(byAdding: .day, value: -2, to: today)!,
                paidAt: calendar.date(byAdding: .day, value: -2, to: today)!,
                completedAt: calendar.date(byAdding: .day, value: -2, to: today)!,
                updatedAt: today
            )
        ]
    }
    
    // MARK: - 员工相关
    
    func fetchEmployees() async throws -> [Employee] {
        try await simulateNetworkDelay()
        return generateMockEmployees()
    }
    
    func fetchEmployees(storeId: String) async throws -> [Employee] {
        try await simulateNetworkDelay()
        let employees = generateMockEmployees()
        return employees.filter { $0.storeId == storeId }
    }
    
    private func generateMockEmployees() -> [Employee] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Employee(
                id: "e001",
                employeeNumber: "E001",
                name: "张三",
                phone: "13800138001",
                role: "店长",
                storeId: "store_001",
                avatarURL: "",
                hireDate: calendar.date(byAdding: .year, value: -3, to: today)!,
                commissionRate: 5.0,
                isActive: true,
                createdAt: calendar.date(byAdding: .year, value: -3, to: today)!,
                updatedAt: today
            ),
            Employee(
                id: "e002",
                employeeNumber: "E002",
                name: "李四",
                phone: "13800138002",
                role: "店员",
                storeId: "store_001",
                avatarURL: "",
                hireDate: calendar.date(byAdding: .year, value: -2, to: today)!,
                commissionRate: 3.0,
                isActive: true,
                createdAt: calendar.date(byAdding: .year, value: -2, to: today)!,
                updatedAt: today
            ),
            Employee(
                id: "e003",
                employeeNumber: "E003",
                name: "王五",
                phone: "13800138003",
                role: "店员",
                storeId: "store_001",
                avatarURL: "",
                hireDate: calendar.date(byAdding: .year, value: -1, to: today)!,
                commissionRate: 3.0,
                isActive: true,
                createdAt: calendar.date(byAdding: .year, value: -1, to: today)!,
                updatedAt: today
            ),
            Employee(
                id: "e004",
                employeeNumber: "E004",
                name: "赵六",
                phone: "13800138004",
                role: "店员",
                storeId: "store_001",
                avatarURL: "",
                hireDate: calendar.date(byAdding: .month, value: -6, to: today)!,
                commissionRate: 3.0,
                isActive: true,
                createdAt: calendar.date(byAdding: .month, value: -6, to: today)!,
                updatedAt: today
            ),
            Employee(
                id: "e005",
                employeeNumber: "E005",
                name: "钱七",
                phone: "13800138005",
                role: "店员",
                storeId: "store_001",
                avatarURL: "",
                hireDate: calendar.date(byAdding: .month, value: -3, to: today)!,
                commissionRate: 3.0,
                isActive: true,
                createdAt: calendar.date(byAdding: .month, value: -3, to: today)!,
                updatedAt: today
            )
        ]
    }
    
    // MARK: - 客户相关
    
    func fetchCustomers() async throws -> [Customer] {
        try await simulateNetworkDelay()
        return generateMockCustomers()
    }
    
    func searchCustomers(keyword: String) async throws -> [Customer] {
        try await simulateNetworkDelay()
        let customers = generateMockCustomers()
        return customers.filter {
            $0.name.contains(keyword) || $0.phone.contains(keyword)
        }
    }
    
    func createCustomer(_ customer: Customer) async throws -> Customer {
        try await simulateNetworkDelay()
        var newCustomer = customer
        newCustomer.id = "c\(Int.random(in: 1000...9999))"
        newCustomer.createdAt = Date()
        newCustomer.updatedAt = Date()
        return newCustomer
    }
    
    private func generateMockCustomers() -> [Customer] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Customer(
                id: "c001",
                name: "王大明",
                phone: "13900000001",
                gender: "男",
                birthday: calendar.date(byAdding: .year, value: -30, to: today),
                level: "金卡",
                address: "北京市朝阳区建国路100号",
                tags: ["优质客户", "高频消费"],
                totalSpent: 125800,
                totalOrders: 15,
                lastOrderDate: calendar.date(byAdding: .day, value: -2, to: today),
                source: "门店",
                note: "喜欢苹果产品",
                createdAt: calendar.date(byAdding: .year, value: -2, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c002",
                name: "李小红",
                phone: "13900000002",
                gender: "女",
                birthday: calendar.date(byAdding: .year, value: -25, to: today),
                level: "银卡",
                address: "北京市海淀区中关村大街50号",
                tags: ["年轻客户"],
                totalSpent: 45600,
                totalOrders: 6,
                lastOrderDate: calendar.date(byAdding: .day, value: -5, to: today),
                source: "线上",
                note: "",
                createdAt: calendar.date(byAdding: .year, value: -1, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c003",
                name: "张小明",
                phone: "13900000003",
                gender: "男",
                birthday: calendar.date(byAdding: .year, value: -28, to: today),
                level: "普通",
                address: "北京市西城区金融街20号",
                tags: ["新客户"],
                totalSpent: 8999,
                totalOrders: 1,
                lastOrderDate: calendar.date(byAdding: .day, value: -1, to: today),
                source: "朋友介绍",
                note: "对iPad感兴趣",
                createdAt: calendar.date(byAdding: .month, value: -1, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c004",
                name: "刘婷婷",
                phone: "13900000004",
                gender: "女",
                birthday: calendar.date(byAdding: .year, value: -35, to: today),
                level: "钻石",
                address: "北京市东城区王府井大街88号",
                tags: ["VIP客户", "企业采购"],
                totalSpent: 358000,
                totalOrders: 32,
                lastOrderDate: calendar.date(byAdding: .day, value: -3, to: today),
                source: "门店",
                note: "公司采购负责人",
                createdAt: calendar.date(byAdding: .year, value: -3, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c005",
                name: "陈先生",
                phone: "13900000005",
                gender: "男",
                birthday: calendar.date(byAdding: .year, value: -40, to: today),
                level: "普通",
                address: "北京市丰台区方庄路30号",
                tags: ["流失客户"],
                totalSpent: 2999,
                totalOrders: 1,
                lastOrderDate: calendar.date(byAdding: .month, value: -6, to: today),
                source: "线上",
                note: "需要跟进",
                createdAt: calendar.date(byAdding: .year, value: -1, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c006",
                name: "赵女士",
                phone: "13900000006",
                gender: "女",
                birthday: calendar.date(byAdding: .year, value: -32, to: today),
                level: "金卡",
                address: "北京市通州区新华大街200号",
                tags: ["优质客户"],
                totalSpent: 89000,
                totalOrders: 12,
                lastOrderDate: calendar.date(byAdding: .day, value: -4, to: today),
                source: "门店",
                note: "喜欢vivo手机",
                createdAt: calendar.date(byAdding: .year, value: -2, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c007",
                name: "孙先生",
                phone: "13900000007",
                gender: "男",
                birthday: calendar.date(byAdding: .year, value: -26, to: today),
                level: "银卡",
                address: "北京市昌平区回龙观大街150号",
                tags: ["年轻客户", "数码爱好者"],
                totalSpent: 32800,
                totalOrders: 5,
                lastOrderDate: calendar.date(byAdding: .day, value: -6, to: today),
                source: "线上",
                note: "关注新品发布",
                createdAt: calendar.date(byAdding: .year, value: -1, to: today)!,
                updatedAt: today
            ),
            Customer(
                id: "c008",
                name: "周小姐",
                phone: "13900000008",
                gender: "女",
                birthday: calendar.date(byAdding: .year, value: -24, to: today),
                level: "普通",
                address: "北京市顺义区天竺大街10号",
                tags: ["新客户"],
                totalSpent: 0,
                totalOrders: 0,
                lastOrderDate: nil,
                source: "朋友介绍",
                note: "潜在客户",
                createdAt: calendar.date(byAdding: .day, value: -7, to: today)!,
                updatedAt: today
            )
        ]
    }
}
