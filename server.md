# 3C零售通 - 服务端开发需求文档

## 1. 项目概述

### 1.1 项目简介
3C零售通服务端为iOS客户端提供数据接口支持，实现门店管理、订单处理、库存管理、数据分析等核心业务功能。支持多门店管理，提供实时数据统计和分析能力。

### 1.2 技术栈
- **后端框架**: Java Spring Boot 3.x
- **架构模式**: MVC (Model-View-Controller)
- **数据库**: MySQL 8.0+
- **ORM框架**: MyBatis / JPA (Hibernate)
- **构建工具**: Maven / Gradle
- **API文档**: SpringDoc OpenAPI (Swagger 3.0)
- **Java版本**: JDK 17+

### 1.3 接口规范
- **协议**: HTTP/HTTPS (开发环境可用HTTP，生产环境必须HTTPS)
- **数据格式**: JSON
- **字符编码**: UTF-8
- **日期格式**: ISO 8601 (例如: `2024-12-26T10:30:00Z`)
- **时区**: UTC+8 (北京时间)
- **Content-Type**: `application/json`

### 1.4 项目结构 (Spring Boot MVC)

```
src/
├── main/
│   ├── java/
│   │   └── com/retail/app/
│   │       ├── RetailApplication.java          # 启动类
│   │       ├── config/                          # 配置类
│   │       │   ├── WebConfig.java              # Web配置
│   │       │   ├── SecurityConfig.java         # 安全配置
│   │       │   └── SwaggerConfig.java          # API文档配置
│   │       ├── controller/                      # 控制器层 (C)
│   │       │   ├── AuthController.java
│   │       │   ├── DashboardController.java
│   │       │   ├── StoreController.java
│   │       │   ├── ProductController.java
│   │       │   ├── OrderController.java
│   │       │   ├── EmployeeController.java
│   │       │   ├── CustomerController.java
│   │       │   ├── AnalyticsController.java
│   │       │   └── InventoryController.java
│   │       ├── service/                         # 业务逻辑层 (M)
│   │       │   ├── AuthService.java
│   │       │   ├── DashboardService.java
│   │       │   ├── StoreService.java
│   │       │   ├── ProductService.java
│   │       │   ├── OrderService.java
│   │       │   ├── EmployeeService.java
│   │       │   ├── CustomerService.java
│   │       │   ├── AnalyticsService.java
│   │       │   └── InventoryService.java
│   │       ├── mapper/                          # 数据访问层 (MyBatis)
│   │       │   ├── UserMapper.java
│   │       │   ├── StoreMapper.java
│   │       │   ├── ProductMapper.java
│   │       │   ├── OrderMapper.java
│   │       │   ├── EmployeeMapper.java
│   │       │   ├── CustomerMapper.java
│   │       │   └── InventoryMapper.java
│   │       ├── model/                           # 数据模型 (Entity/DTO)
│   │       │   ├── entity/                      # 实体类 (对应数据库表)
│   │       │   │   ├── User.java
│   │       │   │   ├── Store.java
│   │       │   │   ├── Product.java
│   │       │   │   ├── Order.java
│   │       │   │   └── ...
│   │       │   └── dto/                         # 数据传输对象
│   │       │       ├── LoginRequest.java
│   │       │       ├── LoginResponse.java
│   │       │       ├── DashboardDataDTO.java
│   │       │       └── ...
│   │       ├── common/                          # 公共类
│   │       │   ├── Result.java                  # 统一响应结果
│   │       │   ├── PageResult.java              # 分页结果
│   │       │   ├── Exception/                   # 异常类
│   │       │   │   ├── BusinessException.java
│   │       │   │   └── GlobalExceptionHandler.java
│   │       │   └── util/                        # 工具类
│   │       │       ├── JwtUtil.java
│   │       │       ├── DateUtil.java
│   │       │       └── ...
│   │       └── annotation/                     # 自定义注解
│   │           └── RequireAuth.java
│   └── resources/
│       ├── application.yml                       # 应用配置
│       ├── application-dev.yml                  # 开发环境配置
│       ├── application-prod.yml                 # 生产环境配置
│       ├── mapper/                              # MyBatis XML映射文件
│       │   ├── UserMapper.xml
│       │   ├── StoreMapper.xml
│       │   └── ...
│       └── db/
│           └── migration/                       # 数据库迁移脚本
│               └── V1__init_schema.sql
└── test/
    └── java/
        └── com/retail/app/
            └── ...                               # 单元测试
```

---

## 2. 数据库表结构设计

### 2.1 用户表 (users)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 用户ID (UUID) |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| password | VARCHAR(255) | NOT NULL | 密码 (加密存储) |
| name | VARCHAR(50) | NOT NULL | 姓名 |
| phone | VARCHAR(20) | UNIQUE, NOT NULL | 手机号码 |
| role | VARCHAR(20) | NOT NULL | 角色 (店长/店员/管理员) |
| store_id | VARCHAR(36) | FOREIGN KEY | 所属门店ID |
| avatar_url | VARCHAR(500) | | 头像URL |
| last_login_at | DATETIME | | 最后登录时间 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |
| is_active | TINYINT(1) | DEFAULT 1 | 是否激活 |

**索引**:
- `idx_username` ON `username`
- `idx_phone` ON `phone`
- `idx_store_id` ON `store_id`

### 2.2 门店表 (stores)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 门店ID (UUID) |
| name | VARCHAR(100) | NOT NULL | 门店名称 |
| code | VARCHAR(50) | UNIQUE, NOT NULL | 门店编号 |
| city | VARCHAR(50) | NOT NULL | 城市 |
| address | VARCHAR(200) | NOT NULL | 详细地址 |
| phone | VARCHAR(20) | | 联系电话 |
| manager_name | VARCHAR(50) | | 店长姓名 |
| business_hours | VARCHAR(50) | | 营业时间 |
| status | VARCHAR(20) | DEFAULT '营业中' | 门店状态 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `idx_code` ON `code`
- `idx_city` ON `city`

### 2.3 商品表 (products)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 商品ID (UUID) |
| name | VARCHAR(200) | NOT NULL | 商品名称 |
| model | VARCHAR(100) | NOT NULL | 商品型号 |
| brand | VARCHAR(50) | NOT NULL | 品牌 |
| category | VARCHAR(50) | NOT NULL | 分类 |
| specification | TEXT | | 规格描述 |
| price | DECIMAL(10,2) | NOT NULL | 建议零售价 |
| promotion_price | DECIMAL(10,2) | DEFAULT 0 | 促销价 |
| cost_price | DECIMAL(10,2) | NOT NULL | 成本价 |
| stock | INT | DEFAULT 0 | 库存数量 |
| warning_stock | INT | DEFAULT 10 | 库存预警阈值 |
| image_url | VARCHAR(500) | | 商品图片URL |
| description | TEXT | | 商品描述 |
| tags | JSON | | 商品标签数组 |
| is_active | TINYINT(1) | DEFAULT 1 | 是否上架 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `idx_category` ON `category`
- `idx_brand` ON `brand`
- `idx_name` ON `name`
- `idx_model` ON `model`
- `FULLTEXT idx_search` ON `name`, `model`, `brand`

### 2.4 订单表 (orders)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 订单ID (UUID) |
| order_number | VARCHAR(50) | UNIQUE, NOT NULL | 订单编号 |
| store_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 门店ID |
| customer_id | VARCHAR(36) | FOREIGN KEY | 客户ID (可选) |
| employee_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 销售员工ID |
| subtotal_amount | DECIMAL(10,2) | NOT NULL | 商品总额 |
| discount_amount | DECIMAL(10,2) | DEFAULT 0 | 优惠金额 |
| total_amount | DECIMAL(10,2) | NOT NULL | 实付金额 |
| payment_method | VARCHAR(20) | NOT NULL | 支付方式 |
| status | VARCHAR(20) | NOT NULL | 订单状态 |
| note | TEXT | | 备注 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| paid_at | DATETIME | | 支付时间 |
| completed_at | DATETIME | | 完成时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `idx_order_number` ON `order_number`
- `idx_store_id` ON `store_id`
- `idx_customer_id` ON `customer_id`
- `idx_employee_id` ON `employee_id`
- `idx_status` ON `status`
- `idx_created_at` ON `created_at`

### 2.5 订单商品表 (order_items)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 订单商品ID (UUID) |
| order_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 订单ID |
| product_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 商品ID |
| product_name | VARCHAR(200) | NOT NULL | 商品名称 (快照) |
| product_model | VARCHAR(100) | NOT NULL | 商品型号 (快照) |
| price | DECIMAL(10,2) | NOT NULL | 单价 (快照) |
| quantity | INT | NOT NULL | 数量 |
| subtotal | DECIMAL(10,2) | NOT NULL | 小计 |
| created_at | DATETIME | NOT NULL | 创建时间 |

**索引**:
- `idx_order_id` ON `order_id`
- `idx_product_id` ON `product_id`

### 2.6 员工表 (employees)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 员工ID (UUID) |
| employee_number | VARCHAR(50) | UNIQUE, NOT NULL | 工号 |
| name | VARCHAR(50) | NOT NULL | 姓名 |
| phone | VARCHAR(20) | UNIQUE, NOT NULL | 手机号码 |
| role | VARCHAR(20) | NOT NULL | 角色 |
| store_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 所属门店ID |
| avatar_url | VARCHAR(500) | | 头像URL |
| hire_date | DATE | NOT NULL | 入职日期 |
| commission_rate | DECIMAL(5,2) | DEFAULT 5.00 | 提成比例 (%) |
| is_active | TINYINT(1) | DEFAULT 1 | 是否在职 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `idx_employee_number` ON `employee_number`
- `idx_store_id` ON `store_id`
- `idx_phone` ON `phone`

### 2.7 客户表 (customers)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 客户ID (UUID) |
| name | VARCHAR(50) | NOT NULL | 客户姓名 |
| phone | VARCHAR(20) | UNIQUE, NOT NULL | 手机号码 |
| gender | VARCHAR(10) | | 性别 |
| birthday | DATE | | 生日 |
| level | VARCHAR(20) | DEFAULT '普通' | 会员等级 |
| address | VARCHAR(200) | | 地址 |
| tags | JSON | | 标签数组 |
| total_spent | DECIMAL(10,2) | DEFAULT 0 | 累计消费金额 |
| total_orders | INT | DEFAULT 0 | 累计消费次数 |
| last_order_date | DATETIME | | 最后消费时间 |
| source | VARCHAR(50) | | 客户来源 |
| note | TEXT | | 备注 |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `idx_phone` ON `phone`
- `idx_level` ON `level`
- `idx_last_order_date` ON `last_order_date`

### 2.8 库存记录表 (inventory_logs)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 记录ID (UUID) |
| product_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 商品ID |
| store_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 门店ID |
| type | VARCHAR(20) | NOT NULL | 操作类型 (入库/出库/盘点/调拨) |
| quantity | INT | NOT NULL | 数量变化 (正数为入库，负数为出库) |
| before_stock | INT | NOT NULL | 操作前库存 |
| after_stock | INT | NOT NULL | 操作后库存 |
| operator_id | VARCHAR(36) | FOREIGN KEY | 操作人ID |
| note | TEXT | | 备注 |
| created_at | DATETIME | NOT NULL | 创建时间 |

**索引**:
- `idx_product_id` ON `product_id`
- `idx_store_id` ON `store_id`
- `idx_type` ON `type`
- `idx_created_at` ON `created_at`

### 2.9 门店商品库存表 (store_products)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 记录ID (UUID) |
| store_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 门店ID |
| product_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 商品ID |
| stock | INT | DEFAULT 0 | 库存数量 |
| warning_stock | INT | DEFAULT 10 | 预警阈值 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `UNIQUE idx_store_product` ON `store_id`, `product_id`
- `idx_stock` ON `stock`

### 2.10 门店日统计表 (store_daily_stats)

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | VARCHAR(36) | PRIMARY KEY | 记录ID (UUID) |
| store_id | VARCHAR(36) | FOREIGN KEY, NOT NULL | 门店ID |
| stat_date | DATE | NOT NULL | 统计日期 |
| sales | DECIMAL(10,2) | DEFAULT 0 | 销售额 |
| traffic | INT | DEFAULT 0 | 客流量 |
| orders | INT | DEFAULT 0 | 订单数 |
| avg_order_value | DECIMAL(10,2) | DEFAULT 0 | 客单价 |
| conversion_rate | DECIMAL(5,2) | DEFAULT 0 | 转化率 (%) |
| created_at | DATETIME | NOT NULL | 创建时间 |
| updated_at | DATETIME | NOT NULL | 更新时间 |

**索引**:
- `UNIQUE idx_store_date` ON `store_id`, `stat_date`
- `idx_stat_date` ON `stat_date`

---

## 3. RESTful API 接口定义

### 3.1 认证相关

#### 3.1.1 用户登录
```
POST /api/v1/auth/login
```

**请求体**:
```json
{
  "username": "string",
  "password": "string"
}
```

**响应**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "id": "string",
    "username": "string",
    "name": "string",
    "phone": "string",
    "role": "string",
    "store_id": "string",
    "store_name": "string",
    "avatar_url": "string",
    "token": "string",
    "last_login_at": "2024-12-26T10:30:00Z",
    "created_at": "2024-12-26T10:30:00Z"
  }
}
```

**错误响应**:
```json
{
  "code": 401,
  "message": "用户名或密码错误",
  "data": null
}
```

---

### 3.2 Dashboard 数据

#### 3.2.1 获取Dashboard数据
```
GET /api/v1/dashboard
Headers: Authorization: Bearer {token}
Query Parameters:
  - store_id (可选): 门店ID，不传则使用当前用户门店
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "today_sales": 12345.67,
    "yesterday_sales": 11234.56,
    "today_traffic": 156,
    "yesterday_traffic": 142,
    "today_orders": 48,
    "yesterday_orders": 45,
    "today_avg_order_value": 257.20,
    "yesterday_avg_order_value": 249.66,
    "conversion_rate": 30.77,
    "yesterday_conversion_rate": 31.69,
    "store_ranking": 3,
    "total_stores": 15,
    "month_sales": 345678.90,
    "month_target": 500000.00,
    "pending_orders": 5,
    "low_stock_count": 12,
    "pending_customers": 8
  }
}
```

---

### 3.3 门店相关

#### 3.3.1 获取门店列表
```
GET /api/v1/stores
Headers: Authorization: Bearer {token}
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": "string",
      "name": "string",
      "code": "string",
      "city": "string",
      "address": "string",
      "phone": "string",
      "manager_name": "string",
      "business_hours": "string",
      "status": "string",
      "today_sales": 0.00,
      "month_sales": 0.00,
      "ranking": 0,
      "created_at": "2024-12-26T10:30:00Z"
    }
  ]
}
```

#### 3.3.2 获取单个门店信息
```
GET /api/v1/stores/{store_id}
Headers: Authorization: Bearer {token}
```

---

### 3.4 商品相关

#### 3.4.1 获取商品列表
```
GET /api/v1/products
Headers: Authorization: Bearer {token}
Query Parameters:
  - category (可选): 商品分类
  - page (可选): 页码，默认1
  - page_size (可选): 每页数量，默认20
  - store_id (可选): 门店ID，用于查询门店库存
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": "string",
        "name": "string",
        "model": "string",
        "brand": "string",
        "category": "string",
        "specification": "string",
        "price": 0.00,
        "promotion_price": 0.00,
        "cost_price": 0.00,
        "stock": 0,
        "warning_stock": 10,
        "image_url": "string",
        "description": "string",
        "tags": ["string"],
        "is_active": true,
        "created_at": "2024-12-26T10:30:00Z"
      }
    ],
    "total": 100,
    "page": 1,
    "page_size": 20
  }
}
```

#### 3.4.2 搜索商品
```
GET /api/v1/products/search
Headers: Authorization: Bearer {token}
Query Parameters:
  - keyword: 搜索关键词 (必填)
  - store_id (可选): 门店ID
```

#### 3.4.3 获取商品详情
```
GET /api/v1/products/{product_id}
Headers: Authorization: Bearer {token}
Query Parameters:
  - store_id (可选): 门店ID，用于查询门店库存
```

---

### 3.5 订单相关

#### 3.5.1 获取订单列表
```
GET /api/v1/orders
Headers: Authorization: Bearer {token}
Query Parameters:
  - status (可选): 订单状态 (待支付/已支付/已完成/退款中/已退款/已取消)
  - start_date (可选): 开始日期 (YYYY-MM-DD)
  - end_date (可选): 结束日期 (YYYY-MM-DD)
  - page (可选): 页码，默认1
  - page_size (可选): 每页数量，默认20
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": "string",
        "order_number": "string",
        "store_id": "string",
        "store_name": "string",
        "customer_id": "string",
        "customer_name": "string",
        "customer_phone": "string",
        "employee_id": "string",
        "employee_name": "string",
        "items": [
          {
            "product_id": "string",
            "product_name": "string",
            "product_model": "string",
            "price": 0.00,
            "quantity": 1,
            "subtotal": 0.00
          }
        ],
        "subtotal_amount": 0.00,
        "discount_amount": 0.00,
        "total_amount": 0.00,
        "payment_method": "string",
        "status": "string",
        "note": "string",
        "created_at": "2024-12-26T10:30:00Z",
        "paid_at": "2024-12-26T10:30:00Z",
        "completed_at": "2024-12-26T10:30:00Z"
      }
    ],
    "total": 100,
    "page": 1,
    "page_size": 20
  }
}
```

#### 3.5.2 创建订单
```
POST /api/v1/orders
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "store_id": "string",
  "customer_id": "string",
  "items": [
    {
      "product_id": "string",
      "quantity": 1
    }
  ],
  "discount_amount": 0.00,
  "payment_method": "string",
  "note": "string"
}
```

**响应**: 返回创建的订单对象

#### 3.5.3 获取订单详情
```
GET /api/v1/orders/{order_id}
Headers: Authorization: Bearer {token}
```

#### 3.5.4 更新订单状态
```
PATCH /api/v1/orders/{order_id}/status
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "status": "已完成"
}
```

---

### 3.6 员工相关

#### 3.6.1 获取员工列表
```
GET /api/v1/employees
Headers: Authorization: Bearer {token}
Query Parameters:
  - store_id (可选): 门店ID
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": "string",
      "employee_number": "string",
      "name": "string",
      "phone": "string",
      "role": "string",
      "store_id": "string",
      "store_name": "string",
      "avatar_url": "string",
      "hire_date": "2024-12-26",
      "today_sales": 0.00,
      "week_sales": 0.00,
      "month_sales": 0.00,
      "today_orders": 0,
      "month_orders": 0,
      "ranking": 0,
      "commission_rate": 5.00,
      "month_commission": 0.00,
      "is_active": true,
      "created_at": "2024-12-26T10:30:00Z"
    }
  ]
}
```

#### 3.6.2 获取员工业绩排行榜
```
GET /api/v1/employees/ranking
Headers: Authorization: Bearer {token}
Query Parameters:
  - period: 统计周期 (today/week/month)
  - store_id (可选): 门店ID
  - limit (可选): 返回数量，默认10
```

---

### 3.7 客户相关

#### 3.7.1 获取客户列表
```
GET /api/v1/customers
Headers: Authorization: Bearer {token}
Query Parameters:
  - page (可选): 页码
  - page_size (可选): 每页数量
```

**响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "list": [
      {
        "id": "string",
        "name": "string",
        "phone": "string",
        "gender": "string",
        "birthday": "2024-12-26",
        "level": "string",
        "address": "string",
        "tags": ["string"],
        "total_spent": 0.00,
        "total_orders": 0,
        "last_order_date": "2024-12-26T10:30:00Z",
        "source": "string",
        "note": "string",
        "created_at": "2024-12-26T10:30:00Z"
      }
    ],
    "total": 100,
    "page": 1,
    "page_size": 20
  }
}
```

#### 3.7.2 搜索客户
```
GET /api/v1/customers/search
Headers: Authorization: Bearer {token}
Query Parameters:
  - keyword: 搜索关键词 (姓名或手机号)
```

#### 3.7.3 创建客户
```
POST /api/v1/customers
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "name": "string",
  "phone": "string",
  "gender": "string",
  "birthday": "2024-12-26",
  "level": "string",
  "address": "string",
  "tags": ["string"],
  "source": "string",
  "note": "string"
}
```

#### 3.7.4 获取客户详情
```
GET /api/v1/customers/{customer_id}
Headers: Authorization: Bearer {token}
```

---

### 3.8 分析数据相关

#### 3.8.1 获取分析数据
```
GET /api/v1/analytics/{period}
Headers: Authorization: Bearer {token}
Query Parameters:
  - period: 分析维度 (daily/weekly/monthly)
  - start_date (可选): 开始日期
  - end_date (可选): 结束日期
  - store_id (可选): 门店ID
```

**响应** (以daily为例):
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "period": "daily",
    "start_date": "2024-12-26",
    "end_date": "2024-12-26",
    "sales_trend": [
      {
        "hour": 9,
        "sales": 1234.56,
        "orders": 5
      }
    ],
    "category_sales": [
      {
        "category": "手机",
        "sales": 5678.90,
        "percentage": 45.6
      }
    ],
    "top_products": [
      {
        "product_id": "string",
        "product_name": "string",
        "sales": 1234.56,
        "quantity": 5
      }
    ],
    "traffic_by_hour": [
      {
        "hour": 9,
        "traffic": 15
      }
    ]
  }
}
```

---

### 3.9 库存相关

#### 3.9.1 获取库存列表
```
GET /api/v1/inventory
Headers: Authorization: Bearer {token}
Query Parameters:
  - store_id: 门店ID (必填)
  - category (可选): 商品分类
  - low_stock_only (可选): 仅显示低库存商品 (true/false)
```

#### 3.9.2 库存入库
```
POST /api/v1/inventory/inbound
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "store_id": "string",
  "product_id": "string",
  "quantity": 10,
  "note": "string"
}
```

#### 3.9.3 库存出库
```
POST /api/v1/inventory/outbound
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "store_id": "string",
  "product_id": "string",
  "quantity": 5,
  "note": "string"
}
```

#### 3.9.4 库存盘点
```
POST /api/v1/inventory/stocktake
Headers: Authorization: Bearer {token}
```

**请求体**:
```json
{
  "store_id": "string",
  "items": [
    {
      "product_id": "string",
      "actual_stock": 100
    }
  ],
  "note": "string"
}
```

---

## 4. 统一响应格式

### 4.1 成功响应
```json
{
  "code": 200,
  "message": "success",
  "data": {}
}
```

### 4.2 错误响应
```json
{
  "code": 400,
  "message": "错误描述",
  "data": null
}
```

### 4.3 HTTP状态码
- `200`: 成功
- `400`: 请求参数错误
- `401`: 未授权 (Token无效或过期)
- `403`: 无权限
- `404`: 资源不存在
- `500`: 服务器内部错误

---

## 5. 认证与授权

### 5.1 Token认证
- 使用JWT (JSON Web Token) 进行身份认证
- Token有效期: 7天
- Token刷新: 提供刷新Token接口

### 5.2 请求头
```
Authorization: Bearer {token}
Content-Type: application/json
```

### 5.3 权限控制
- **店长**: 可查看本店所有数据，可管理本店员工
- **店员**: 可查看本店数据，可创建订单
- **管理员**: 可查看所有门店数据

---

## 6. 业务逻辑说明

### 6.1 订单创建流程
1. 验证商品库存是否充足
2. 计算订单金额 (商品总额 - 优惠金额)
3. 创建订单记录
4. 创建订单商品明细
5. 扣减商品库存
6. 更新员工业绩统计
7. 更新客户消费记录 (如有客户)
8. 更新门店日统计

### 6.2 库存管理
- 每个门店维护独立的商品库存
- 订单出库时自动扣减库存
- 库存低于预警阈值时标记为低库存
- 库存操作记录在 `inventory_logs` 表中

### 6.3 数据统计
- 每日凌晨定时任务计算前一日统计数据
- 统计数据存储在 `store_daily_stats` 表中
- Dashboard数据实时计算（从数据库查询）

### 6.4 排名计算
- 门店排名: 按当日销售额排序
- 员工排名: 按当日/周/月销售额排序
- 排名每小时更新一次

---

## 7. 性能要求

### 7.1 响应时间
- 普通查询接口: < 200ms
- 列表查询接口: < 500ms
- 统计计算接口: < 1000ms

### 7.2 并发支持
- 支持至少500并发用户
- 数据库连接池优化 (HikariCP)
- 连接池配置建议:
  - `spring.datasource.hikari.maximum-pool-size=20`
  - `spring.datasource.hikari.minimum-idle=5`
  - `spring.datasource.hikari.connection-timeout=30000`

### 7.3 数据库优化
- 合理使用索引，避免全表扫描
- 复杂查询使用分页，避免一次性加载大量数据
- 定期优化慢查询
- 使用数据库连接池管理连接

---

## 8. 安全要求

### 8.1 数据加密
- 密码使用BCrypt加密存储
- 敏感数据传输使用HTTPS
- Token使用HS256算法签名

### 8.2 输入验证
- 所有用户输入进行验证和过滤
- 防止SQL注入
- 防止XSS攻击

### 8.3 接口限流
- 登录接口: 5次/分钟 (使用内存计数器实现)
- 普通接口: 100次/分钟
- 使用Guava RateLimiter或自定义限流器实现

---

## 9. 部署要求

### 9.1 环境配置
- 生产环境使用HTTPS
- 配置CORS允许iOS客户端访问
- 配置日志记录和监控

### 9.2 数据库备份
- 每日自动备份
- 保留最近30天备份
- 支持数据恢复

---

## 10. 开发建议

### 10.1 代码规范
- 遵循RESTful API设计规范
- 统一错误处理机制 (使用@ControllerAdvice)
- 完善的日志记录 (使用SLF4J + Logback)
- 遵循Java编码规范 (Google Java Style Guide)
- 使用Lombok简化代码 (可选)

### 10.2 Spring Boot 最佳实践

**统一响应结果类**:
```java
@Data
public class Result<T> {
    private Integer code;
    private String message;
    private T data;
    
    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage("success");
        result.setData(data);
        return result;
    }
    
    public static <T> Result<T> error(Integer code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        return result;
    }
}
```

**全局异常处理**:
```java
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public Result<?> handleBusinessException(BusinessException e) {
        return Result.error(e.getCode(), e.getMessage());
    }
    
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Result<?> handleException(Exception e) {
        log.error("系统异常", e);
        return Result.error(500, "系统内部错误");
    }
}
```

**JWT工具类**:
```java
@Component
public class JwtUtil {
    private static final String SECRET = "your-secret-key";
    private static final long EXPIRATION = 7 * 24 * 60 * 60 * 1000; // 7天
    
    public String generateToken(String userId) {
        return Jwts.builder()
                .setSubject(userId)
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(SignatureAlgorithm.HS512, SECRET)
                .compact();
    }
    
    public String getUserIdFromToken(String token) {
        Claims claims = Jwts.parser()
                .setSigningKey(SECRET)
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject();
    }
}
```

### 10.3 测试要求
- 单元测试覆盖率 > 80% (使用JUnit 5)
- Service层单元测试
- Controller层集成测试 (使用MockMvc)
- 性能压力测试 (使用JMeter)

### 10.4 文档要求
- 使用SpringDoc OpenAPI生成API文档
- 访问地址: `http://localhost:8080/api/v1/swagger-ui.html`
- 提供接口调用示例
- 记录业务逻辑说明

### 10.5 依赖管理 (pom.xml示例)

```xml
<dependencies>
    <!-- Spring Boot Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- MyBatis -->
    <dependency>
        <groupId>org.mybatis.spring.boot</groupId>
        <artifactId>mybatis-spring-boot-starter</artifactId>
        <version>3.0.3</version>
    </dependency>
    
    <!-- MySQL Driver -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
    </dependency>
    
    <!-- JWT -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt</artifactId>
        <version>0.9.1</version>
    </dependency>
    
    <!-- Lombok (可选) -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- Swagger/OpenAPI -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        <version>2.3.0</version>
    </dependency>
    
    <!-- Test -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

---

## 11. 业务逻辑详细说明

### 11.1 订单创建流程 (OrderService)

```java
@Transactional
public Order createOrder(CreateOrderRequest request) {
    // 1. 验证商品库存
    for (OrderItemRequest item : request.getItems()) {
        Product product = productMapper.selectById(item.getProductId());
        StoreProduct storeProduct = storeProductMapper.selectByStoreAndProduct(
            request.getStoreId(), item.getProductId());
        
        if (storeProduct.getStock() < item.getQuantity()) {
            throw new BusinessException("商品库存不足: " + product.getName());
        }
    }
    
    // 2. 计算订单金额
    BigDecimal subtotal = calculateSubtotal(request.getItems());
    BigDecimal discount = request.getDiscountAmount();
    BigDecimal total = subtotal.subtract(discount);
    
    // 3. 创建订单
    Order order = new Order();
    order.setOrderNumber(generateOrderNumber());
    order.setStoreId(request.getStoreId());
    order.setCustomerId(request.getCustomerId());
    order.setEmployeeId(request.getEmployeeId());
    order.setSubtotalAmount(subtotal);
    order.setDiscountAmount(discount);
    order.setTotalAmount(total);
    order.setPaymentMethod(request.getPaymentMethod());
    order.setStatus(OrderStatus.PAID.getCode());
    order.setCreatedAt(new Date());
    order.setPaidAt(new Date());
    orderMapper.insert(order);
    
    // 4. 创建订单商品明细
    for (OrderItemRequest item : request.getItems()) {
        Product product = productMapper.selectById(item.getProductId());
        OrderItem orderItem = new OrderItem();
        orderItem.setOrderId(order.getId());
        orderItem.setProductId(item.getProductId());
        orderItem.setProductName(product.getName());
        orderItem.setProductModel(product.getModel());
        orderItem.setPrice(product.getCurrentPrice());
        orderItem.setQuantity(item.getQuantity());
        orderItem.setSubtotal(product.getCurrentPrice().multiply(
            BigDecimal.valueOf(item.getQuantity())));
        orderItemMapper.insert(orderItem);
        
        // 5. 扣减库存
        storeProductMapper.decreaseStock(
            request.getStoreId(), 
            item.getProductId(), 
            item.getQuantity());
        
        // 6. 记录库存日志
        InventoryLog log = new InventoryLog();
        log.setProductId(item.getProductId());
        log.setStoreId(request.getStoreId());
        log.setType(InventoryType.OUTBOUND.getCode());
        log.setQuantity(-item.getQuantity());
        // ... 设置其他字段
        inventoryLogMapper.insert(log);
    }
    
    // 7. 更新员工业绩
    employeeMapper.updateSales(request.getEmployeeId(), total);
    
    // 8. 更新客户消费记录 (如有客户)
    if (request.getCustomerId() != null) {
        customerMapper.updateConsumption(
            request.getCustomerId(), 
            total, 
            1);
    }
    
    // 9. 更新门店日统计
    updateStoreDailyStats(request.getStoreId(), total, 1);
    
    return order;
}
```

### 11.2 Dashboard数据计算 (DashboardService)

```java
public DashboardDataDTO getDashboardData(String storeId) {
    Date today = new Date();
    Date yesterday = DateUtils.addDays(today, -1);
    
    // 今日数据
    StoreDailyStats todayStats = storeDailyStatsMapper.selectByStoreAndDate(
        storeId, today);
    
    // 昨日数据
    StoreDailyStats yesterdayStats = storeDailyStatsMapper.selectByStoreAndDate(
        storeId, yesterday);
    
    // 计算排名
    int ranking = storeMapper.getRankingByTodaySales(storeId);
    int totalStores = storeMapper.countAll();
    
    // 月度数据
    BigDecimal monthSales = orderMapper.sumMonthSales(storeId);
    BigDecimal monthTarget = storeMapper.getMonthTarget(storeId);
    
    // 待办事项
    int pendingOrders = orderMapper.countByStatus(storeId, OrderStatus.PENDING);
    int lowStockCount = storeProductMapper.countLowStock(storeId);
    int pendingCustomers = customerMapper.countPendingFollowUp(storeId);
    
    DashboardDataDTO dto = new DashboardDataDTO();
    dto.setTodaySales(todayStats.getSales());
    dto.setYesterdaySales(yesterdayStats.getSales());
    // ... 设置其他字段
    
    return dto;
}
```

### 11.3 库存管理

**入库操作**:
```java
@Transactional
public void inbound(InventoryInboundRequest request) {
    // 1. 更新库存
    StoreProduct storeProduct = storeProductMapper.selectByStoreAndProduct(
        request.getStoreId(), request.getProductId());
    
    if (storeProduct == null) {
        // 创建新记录
        storeProduct = new StoreProduct();
        storeProduct.setStoreId(request.getStoreId());
        storeProduct.setProductId(request.getProductId());
        storeProduct.setStock(request.getQuantity());
        storeProductMapper.insert(storeProduct);
    } else {
        // 增加库存
        storeProductMapper.increaseStock(
            request.getStoreId(), 
            request.getProductId(), 
            request.getQuantity());
    }
    
    // 2. 记录日志
    InventoryLog log = new InventoryLog();
    log.setType(InventoryType.INBOUND.getCode());
    log.setQuantity(request.getQuantity());
    // ... 设置其他字段
    inventoryLogMapper.insert(log);
}
```

### 11.4 数据统计定时任务

```java
@Component
public class DailyStatsTask {
    
    @Scheduled(cron = "0 0 1 * * ?") // 每天凌晨1点执行
    public void calculateDailyStats() {
        Date yesterday = DateUtils.addDays(new Date(), -1);
        List<Store> stores = storeMapper.selectAll();
        
        for (Store store : stores) {
            // 计算昨日统计数据
            StoreDailyStats stats = calculateStoreStats(store.getId(), yesterday);
            storeDailyStatsMapper.insertOrUpdate(stats);
            
            // 更新门店排名
            updateStoreRanking(store.getId());
        }
    }
}
```

## 12. 后续扩展功能

### 12.1 消息推送 (后续实现)
- 订单状态变更通知
- 库存预警通知
- 系统公告推送
- 使用第三方推送服务 (极光推送/个推)

### 12.2 数据导出 (后续实现)
- 订单数据导出Excel (使用Apache POI)
- 销售报表导出PDF (使用iText)
- 库存报表导出

### 12.3 文件上传 (后续实现)
- 商品图片上传
- 用户头像上传
- 使用本地存储或OSS

### 12.4 多租户支持 (后续实现)
- 支持多个品牌/公司
- 数据隔离
- 独立配置

---

## 附录

### A. 枚举值定义

**订单状态**:
- `pending`: 待支付
- `paid`: 已支付
- `completed`: 已完成
- `refunding`: 退款中
- `refunded`: 已退款
- `cancelled`: 已取消

**支付方式**:
- `cash`: 现金
- `wechat`: 微信支付
- `alipay`: 支付宝
- `card`: 刷卡
- `other`: 其他

**员工角色**:
- `manager`: 店长
- `staff`: 店员
- `admin`: 管理员

**客户等级**:
- `normal`: 普通
- `silver`: 银卡
- `gold`: 金卡
- `diamond`: 钻石

**商品分类**:
- `phone`: 手机
- `tablet`: 平板
- `laptop`: 笔记本
- `accessory`: 配件
- `smartDevice`: 智能硬件

### B. 日期时间格式
- 日期: `YYYY-MM-DD` (例如: `2024-12-26`)
- 日期时间: `YYYY-MM-DDTHH:mm:ssZ` (例如: `2024-12-26T10:30:00Z`)

### C. 金额格式
- 所有金额使用 `DECIMAL(10,2)` 类型
- JSON中金额为数字类型，保留2位小数

---

**文档版本**: v2.0  
**最后更新**: 2024-12-26  
**维护者**: 开发团队  
**技术栈**: Java Spring Boot 3.x + MySQL 8.0 + MyBatis + MVC架构

