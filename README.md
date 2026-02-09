# 3C零售通 - 门店管理APP

## 项目概述

3C零售通是一款面向3C行业零售门店的智能管理应用，为店长和店员提供经营数据分析、库存管理、订单处理、员工协作等全方位的门店运营解决方案。应用支持多门店管理，通过数据可视化和智能分析，帮助提升门店运营效率和销售业绩。

**设计理念**：注重操作便捷性、数据实时性和激励机制。

## 项目信息

- **项目名称**: 3C零售通 (TestAPP1)
- **开发语言**: Swift
- **最低支持版本**: iOS 17.0+
- **目标设备**: iPhone
- **架构模式**: MVVM + Clean Architecture
- **UI框架**: SwiftUI
- **开发状态**: 初始阶段

## 目标用户

- **店长**: 查看门店经营数据、分析业绩趋势、管理员工、审批流程
- **店员**: 录入销售数据、查询库存、管理客户、处理订单
- **区域经理**: 多门店数据对比、区域业绩分析（后期扩展）

## 核心功能模块

### 1. 数据看板（首页）

**功能描述**: 门店经营核心数据一览，实时掌握门店运营状况

**主要功能**:
- 今日核心指标：销售额、客流量、成交单数、客单价、转化率
- 实时排名：本店在所有门店中的排名位置
- 趋势对比：同比/环比数据对比，涨跌幅度显示
- 进度环形图：月度目标达成进度可视化
- 快捷入口：常用功能快速访问（扫码、录单、查库存等）
- 待办事项：库存预警、待处理订单、待跟进客户数量提醒
- 消息通知：总部公告、活动通知、系统消息

**设计要点**:
- 使用卡片式布局，信息分层清晰
- 关键数据大字号显示，涨跌用颜色区分（红涨绿跌）
- 下拉刷新实时更新数据
- 支持切换查看其他门店数据（店长权限）

### 2. 经营分析

**功能描述**: 多维度数据统计分析，支持日/周/月维度查看

**日维度分析**:
- 每日销售趋势曲线（按小时统计）
- 分品类销售占比饼图
- TOP10热销商品榜单
- 客流量分时段统计
- 今日vs昨日对比

**周维度分析**:
- 本周七天销售趋势
- 工作日vs周末业绩对比
- 周同比增长分析
- 本周新增客户数统计

**月维度分析**:
- 月度销售总览与目标达成率
- 每日销售柱状图
- 分品类月度销售排行
- 月同比/环比分析
- 月度业绩总结报告

**自定义分析**:
- 自由选择日期区间
- 多维度数据交叉分析
- 数据导出功能（Excel/PDF）

**可视化图表**:
- 折线图：趋势分析
- 柱状图：对比分析
- 饼图/环形图：占比分析
- 雷达图：多指标综合评估

### 3. 库存管理

**功能描述**: 实时掌握商品库存状态，提高库存周转效率

**主要功能**:
- 库存查询：支持商品名称/型号/条码搜索
- 扫码查库存：快速扫描商品条码查看库存
- 库存列表：分类展示，支持筛选排序
- 库存预警：低库存/滞销品红色标记提醒
- 入库登记：扫码或手动录入入库信息
- 出库记录：销售出库自动记录
- 库存盘点：支持扫码盘点，差异自动计算
- 调拨申请：跨门店调货申请与审批流程
- 库存报表：库存周转率、呆滞库存分析

**设计要点**:
- 首页显示预警商品数量，点击直达
- 列表支持多条件组合筛选
- 盘点模式：全屏扫码，连续录入体验优化

### 4. 商品管理

**功能描述**: 商品信息维护与价格管理

**主要功能**:
- 商品档案：型号、规格、品牌、分类、图片、描述
- 商品分类：手机、平板、笔记本、配件、智能硬件等
- 价格管理：建议零售价、促销价、会员价
- 价格历史：价格调整记录查询
- 促销活动：折扣、满减、赠品设置
- 商品标签：新品、热销、促销、缺货等状态标识
- 二维码生成：生成商品专属二维码
- 商品搜索：支持多关键词模糊搜索

### 5. 订单管理

**功能描述**: 订单全流程管理与售后处理

**主要功能**:
- 快速开单：扫码或搜索添加商品，选择支付方式
- 订单列表：待支付、已完成、售后中等状态筛选
- 订单详情：商品明细、客户信息、支付方式、时间节点
- 订单搜索：按订单号/客户/日期/商品查询
- 售后处理：退货、换货、维修申请与流程跟踪
- 支付统计：现金、微信、支付宝、刷卡占比分析
- 订单打印：小票打印功能（连接蓝牙打印机）
- 订单备注：记录特殊需求或注意事项

**快速开单流程**:
1. 扫码或搜索添加商品
2. 输入数量，自动计算金额
3. 选择客户（可选，用于会员管理）
4. 选择支付方式
5. 确认订单，生成订单号

### 6. 员工管理

**功能描述**: 员工信息管理与业绩激励

**主要功能**:
- 员工档案：姓名、工号、职位、联系方式、入职日期
- 排班管理：班次设置、排班日历、换班申请
- 考勤打卡：GPS定位打卡，上下班记录
- 业绩排行榜：日/周/月销售冠军榜单
- 个人业绩：销售额、成交单数、客单价、排名变化
- 提成计算：根据销售额自动计算提成
- 业绩目标：设置个人目标，进度可视化
- 权限管理：店长/店员角色权限配置

**激励机制**:
- 实时排名更新，激发竞争意识
- 达成目标奖励徽章
- 业绩曲线图展示个人成长

### 7. 客户管理（CRM）

**功能描述**: 客户信息管理与关系维护

**主要功能**:
- 客户档案：姓名、手机、生日、地址、标签
- 快速录入：开单时同步录入客户信息
- 会员等级：普通、银卡、金卡、钻石等级体系
- 消费历史：客户购买记录、累计消费、偏好分析
- 客户标签：优质客户、潜在客户、流失客户等
- 生日提醒：自动推送生日祝福和优惠券
- 跟进记录：客户沟通记录、跟进计划
- 营销推送：短信/推送通知发送（需客户授权）
- 客户搜索：按姓名/手机号快速查找

### 8. 门店管理

**功能描述**: 多门店信息管理与切换

**主要功能**:
- 门店列表：所有门店信息展示
- 门店详情：地址、联系方式、营业时间、负责人
- 门店切换：快速切换查看不同门店数据
- 门店排行：销售额、增长率排名
- 门店对比：多门店数据对比分析
- 区域分组：按城市/区域分组管理

### 9. 任务中心

**功能描述**: 工作任务管理与提醒

**主要功能**:
- 待办任务：库存预警、订单待处理、客户待跟进
- 任务打卡：日常巡检、陈列检查、卫生清洁等任务
- 任务模板：常规任务模板库
- 任务提醒：推送通知提醒
- 完成记录：任务完成情况统计

### 10. 消息通知

**功能描述**: 系统消息与公告通知

**主要功能**:
- 系统公告：总部发布的重要通知
- 活动通知：促销活动、新品上市
- 审批消息：调拨申请、售后审批状态
- 业绩提醒：目标达成、排名变化
- 消息分类：未读/已读标记

### 11. 我的（个人中心）

**功能描述**: 个人信息与系统设置

**主要功能**:
- 个人资料：头像、姓名、工号、职位
- 我的业绩：个人销售数据汇总
- 我的提成：提成明细与累计
- 账号安全：修改密码、手机绑定
- 系统设置：推送通知、深色模式、语言切换
- 帮助中心：使用指南、常见问题
- 关于我们：版本信息、隐私政策
- 退出登录

## 技术栈

### 开发语言与框架
- **Swift**: 主要开发语言，使用最新Swift特性
- **SwiftUI**: 声明式UI框架，iOS 17+
- **Combine**: 响应式编程框架，处理异步数据流

### 架构与设计模式
- **MVVM**: Model-View-ViewModel架构模式
- **Clean Architecture**: 分层架构，依赖倒置
- **Repository Pattern**: 数据访问层抽象
- **Coordinator Pattern**: 页面导航管理

### 数据层
- **SwiftData**: iOS 17原生数据持久化框架（本地缓存）
- **URLSession**: 网络请求，使用async/await
- **Keychain**: 存储敏感信息（Token、密码）
- **UserDefaults**: 用户偏好设置

### UI与图表
- **Swift Charts**: iOS 16+原生图表框架
- **SF Symbols**: 系统图标库
- **PhotosUI**: 图片选择器

### 工具与调试
- **OSLog**: 结构化日志
- **Instruments**: 性能分析工具
- **XCTest**: 单元测试框架

### 依赖管理
- **Swift Package Manager (SPM)**: 优先使用

### 可能的第三方依赖
- **Alamofire**: 网络请求库（可选，初期使用URLSession）
- **Kingfisher**: 图片加载与缓存（可选）
- **SnapKit**: Auto Layout DSL（可选，SwiftUI不需要）

## 项目架构

### 目录结构设计

```
TestAPP1/
├── App/
│   ├── TestAPP1App.swift          # 应用入口
│   └── AppCoordinator.swift       # 应用导航协调器
├── Core/
│   ├── Network/                   # 网络层
│   │   ├── NetworkManager.swift
│   │   ├── APIEndpoint.swift
│   │   └── NetworkError.swift
│   ├── Storage/                   # 数据持久化
│   │   ├── SwiftDataManager.swift
│   │   └── KeychainManager.swift
│   ├── Utils/                     # 工具类
│   │   ├── DateFormatter+Ext.swift
│   │   ├── String+Ext.swift
│   │   └── Color+Ext.swift
│   └── Constants/                 # 常量定义
│       └── AppConstants.swift
├── Data/
│   ├── Models/                    # 数据模型
│   │   ├── Store.swift           # 门店模型
│   │   ├── Product.swift         # 商品模型
│   │   ├── Order.swift           # 订单模型
│   │   ├── Employee.swift        # 员工模型
│   │   └── Customer.swift        # 客户模型
│   ├── Repositories/              # 数据仓库
│   │   ├── StoreRepository.swift
│   │   ├── ProductRepository.swift
│   │   └── OrderRepository.swift
│   └── Mock/                      # Mock数据
│       ├── MockDataManager.swift
│       └── MockData.json
├── Domain/
│   ├── UseCases/                  # 业务用例
│   │   ├── GetDashboardDataUseCase.swift
│   │   ├── GetSalesAnalyticsUseCase.swift
│   │   └── CreateOrderUseCase.swift
│   └── Entities/                  # 业务实体（如果需要）
├── Presentation/
│   ├── Dashboard/                 # 数据看板
│   │   ├── DashboardView.swift
│   │   ├── DashboardViewModel.swift
│   │   └── Components/
│   ├── Analytics/                 # 经营分析
│   │   ├── AnalyticsView.swift
│   │   ├── AnalyticsViewModel.swift
│   │   ├── DailyAnalyticsView.swift
│   │   ├── WeeklyAnalyticsView.swift
│   │   └── MonthlyAnalyticsView.swift
│   ├── Inventory/                 # 库存管理
│   │   ├── InventoryListView.swift
│   │   ├── InventoryViewModel.swift
│   │   └── InventoryDetailView.swift
│   ├── Product/                   # 商品管理
│   │   ├── ProductListView.swift
│   │   ├── ProductViewModel.swift
│   │   └── ProductDetailView.swift
│   ├── Order/                     # 订单管理
│   │   ├── OrderListView.swift
│   │   ├── OrderViewModel.swift
│   │   ├── CreateOrderView.swift
│   │   └── OrderDetailView.swift
│   ├── Employee/                  # 员工管理
│   │   ├── EmployeeListView.swift
│   │   ├── EmployeeViewModel.swift
│   │   └── PerformanceRankingView.swift
│   ├── Customer/                  # 客户管理
│   │   ├── CustomerListView.swift
│   │   ├── CustomerViewModel.swift
│   │   └── CustomerDetailView.swift
│   ├── Store/                     # 门店管理
│   │   ├── StoreListView.swift
│   │   ├── StoreViewModel.swift
│   │   └── StoreComparisonView.swift
│   ├── Task/                      # 任务中心
│   │   ├── TaskCenterView.swift
│   │   └── TaskViewModel.swift
│   ├── Message/                   # 消息通知
│   │   ├── MessageListView.swift
│   │   └── MessageViewModel.swift
│   ├── Profile/                   # 个人中心
│   │   ├── ProfileView.swift
│   │   ├── ProfileViewModel.swift
│   │   └── SettingsView.swift
│   ├── Auth/                      # 登录注册
│   │   ├── LoginView.swift
│   │   ├── LoginViewModel.swift
│   │   └── AuthManager.swift
│   └── Components/                # 通用组件
│       ├── CustomTabBar.swift
│       ├── LoadingView.swift
│       ├── EmptyStateView.swift
│       ├── ChartComponents/
│       └── CustomButton.swift
├── Resources/
│   ├── Assets.xcassets/          # 图片资源
│   ├── Localizable.xcstrings     # 多语言支持
│   └── LaunchScreen.storyboard
└── Tests/
    ├── UnitTests/
    └── UITests/
```

### 数据流设计

**离线优先策略**:
1. 应用启动时，优先加载本地缓存数据
2. 后台异步请求服务端最新数据
3. 数据返回后更新UI和本地缓存
4. 无网络时仍可查看历史数据

**Mock数据阶段**:
- 使用MockDataManager模拟API响应
- Mock数据存储在JSON文件中
- 通过协议抽象，后期无缝切换到真实API

**真实API接入**:
- Repository层统一切换到NetworkManager
- 保持ViewModel层代码不变
- 添加错误处理和重试机制

## Mock数据策略

### 实现方案

**协议定义**:
```swift
protocol DataProviderProtocol {
    func fetchDashboardData() async throws -> DashboardData
    func fetchSalesAnalytics(period: AnalyticsPeriod) async throws -> AnalyticsData
    // ... 其他数据接口
}
```

**Mock实现**:
```swift
class MockDataProvider: DataProviderProtocol {
    // 从本地JSON文件加载数据
    // 模拟网络延迟
    // 返回模拟数据
}
```

**真实API实现**:
```swift
class APIDataProvider: DataProviderProtocol {
    // 真实网络请求
    // 错误处理
    // 数据解析
}
```

**依赖注入**:
- 使用环境变量或配置文件控制使用Mock还是真实API
- 开发阶段使用Mock，生产环境使用真实API
- 测试环境可独立配置

### Mock数据内容

**门店数据**:
- 10个示例门店（不同城市、不同业绩水平）
- 门店基本信息、营业时间、负责人

**商品数据**:
- 50+个3C商品（手机、平板、笔记本、配件等）
- 完整的商品信息、价格、库存

**订单数据**:
- 近3个月的订单记录（每天20-50单）
- 不同支付方式、不同商品组合

**员工数据**:
- 每个门店5-8名员工
- 不同的业绩水平和排名

**客户数据**:
- 500+个客户记录
- 不同会员等级和消费习惯

## 开发计划

### 第一阶段：项目搭建与核心框架（1-2周）

**目标**: 完成项目架构搭建和Mock数据系统

**任务清单**:
- 创建项目目录结构
- 搭建MVVM架构基础
- 实现Mock数据管理系统
- 设计数据模型（SwiftData）
- 创建通用UI组件库
- 实现导航协调器
- 配置主题色和设计规范

**交付物**:
- 完整的项目架构
- Mock数据JSON文件
- 可运行的空壳应用

### 第二阶段：核心功能开发（3-4周）

#### Sprint 1: 登录与数据看板（1周）
- 登录界面与认证流程
- 数据看板UI实现
- 核心指标卡片组件
- 趋势图表展示
- 下拉刷新

#### Sprint 2: 经营分析模块（1周）
- 日/周/月维度切换
- 销售趋势图表（折线图、柱状图）
- 分品类占比分析（饼图）
- 自定义日期选择
- 数据导出功能

#### Sprint 3: 订单管理（1周）
- 快速开单流程
- 订单列表与搜索
- 订单详情展示
- 扫码添加商品
- 支付方式选择

#### Sprint 4: 库存管理（1周）
- 库存列表与搜索
- 扫码查库存
- 库存预警展示
- 入库/出库登记
- 库存盘点功能

### 第三阶段：扩展功能开发（2-3周）

#### Sprint 5: 商品与客户管理（1周）
- 商品信息管理
- 商品分类与搜索
- 客户档案管理
- 消费历史查询

#### Sprint 6: 员工管理（1周）
- 员工信息管理
- 业绩排行榜
- 考勤打卡
- 提成计算

#### Sprint 7: 门店与任务（1周）
- 多门店管理
- 门店切换与对比
- 任务中心
- 消息通知

### 第四阶段：优化与测试（1-2周）

**任务清单**:
- UI/UX优化
- 性能优化（Instruments分析）
- 内存泄漏检查
- 单元测试编写
- UI测试编写
- 真机测试
- Bug修复

### 第五阶段：API对接准备（1周）

**任务清单**:
- API接口文档对接
- 网络层实现
- 从Mock切换到真实API
- 错误处理完善
- 数据缓存策略
- 网络状态监控

## UI设计规范

### 配色方案

**主色调**:
- 主色：科技蓝 #007AFF
- 辅助色：橙色 #FF6B00（强调、警告）
- 成功：绿色 #34C759
- 失败/警告：红色 #FF3B30
- 中性色：灰色系列

**深色模式支持**:
- 自动适配系统深色模式
- 使用SwiftUI的语义化颜色

### 字体规范

- 使用系统默认字体（SF Pro）
- 支持Dynamic Type动态字体
- 标题：28-34pt，Bold
- 副标题：20-24pt，Semibold
- 正文：16-17pt，Regular
- 辅助文字：13-14pt，Regular

### 组件规范

**按钮**:
- 主要按钮：填充样式，圆角12pt
- 次要按钮：边框样式
- 文字按钮：纯文字链接

**卡片**:
- 圆角：12pt
- 阴影：轻微投影
- 内边距：16pt

**列表**:
- 分割线：1px，浅灰色
- 左右边距：16pt
- 行高：根据内容自适应

### 图标使用

- 优先使用SF Symbols
- 图标大小：20-24pt
- 保持视觉一致性

## 数据安全与隐私

- 用户密码使用Keychain安全存储
- Token存储在Keychain
- 敏感数据传输使用HTTPS
- 实现用户权限管理，不同角色不同权限
- 遵循iOS隐私保护规范，相机/相册权限申请
- 日志不输出敏感信息

## 性能优化策略

- 列表使用LazyVStack懒加载
- 图片异步加载与缓存
- 数据分页加载
- 避免主线程阻塞，耗时操作使用async/await
- 使用Instruments定期检测性能瓶颈
- 内存管理：注意避免循环引用

## 测试策略

**单元测试**:
- ViewModel业务逻辑测试
- UseCase测试
- Repository测试
- 工具类函数测试

**UI测试**:
- 核心业务流程测试（登录、开单）
- 页面跳转测试

**手动测试**:
- 不同设备尺寸测试（iPhone SE、iPhone 15 Pro Max）
- 深色/浅色模式测试
- 网络异常场景测试
- 边界条件测试

## 版本规划

**v1.0 - MVP版本**:
- 数据看板
- 经营分析（日/周/月）
- 订单管理（开单、查询）
- 库存管理（查询、预警）
- 登录认证
- Mock数据运行

**v1.1 - 功能完善**:
- 商品管理
- 客户管理
- 员工管理
- 多门店管理

**v1.2 - API对接**:
- 接入真实后端API
- 数据同步
- 离线缓存

**v2.0 - 高级功能**:
- 智能数据分析
- 销售预测
- 库存智能调拨建议
- 客户画像分析
- iPad版本支持

## 参考资料

- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata/)


## 项目成员

- 开发者：待定
- 项目周期：预计8-10周完成MVP版本
- 联系方式：待定

## 更新日志

**2024-12-26**:
- 项目初始化
- 完成需求分析与功能规划
- 完成技术选型与架构设计
- 创建项目README文档

---

**备注**: 本文档将随项目开发进度持续更新，记录功能变更、技术决策和优化建议。

