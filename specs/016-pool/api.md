# 016-pool - API 接口

## 基础信息

- **监控路径**: `/druid/*`
- **登录路径**: `/druid/login.html`
- **数据格式**: HTML/JSON
- **认证方式**: 会话认证（独立于主系统）

## 监控页面列表

### 1. 登录页面

**路径**: `/druid/login.html`

**方法**: GET/POST

**请求参数（POST）：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| loginUsername | String | 是 | 用户名 |
| loginPassword | String | 是 | 密码 |

**响应：**
- 成功：重定向到 `/druid/index.html`
- 失败：返回登录页面并显示错误信息

**配置：**
```yaml
spring:
  datasource:
    druid:
      stat-view-servlet:
        login-username: admin
        login-password: admin
```

---

### 2. 监控首页

**路径**: `/druid/index.html`

**方法**: GET

**权限**: Druid 监控登录认证

**内容**: 显示所有监控模块入口

**模块列表：**
- 数据源监控
- SQL 监控
- SQL 慢查询
- Wall 监控
- Spring 监控
- URI 监控
- JSON API 监控

---

### 3. 数据源监控

**路径**: `/druid/datasource.html`

**方法**: GET

**返回数据：**

```json
{
  "Result": [
    {
      "ID": 0,
      "Name": "dataSource",
      "DbType": "mysql",
      "DriverClassName": "com.mysql.cj.jdbc.Driver",
      "URL": "jdbc:mysql://localhost:3306/ruoyi",
      "UserName": "root",
      "Filter": "stat,wall,slf4j",
      "ConnectCount": 100,
      "CloseCount": 95,
      "ActiveCount": 5,
      "PoolingCount": 10,
      "ActivePeak": 15,
      "PoolingPeak": 20,
      "InitialSize": 5,
      "MinIdle": 5,
      "MaxActive": 20,
      "MaxWait": 60000
    }
  ]
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| ID | int | 数据源 ID |
| Name | String | 数据源名称 |
| DbType | String | 数据库类型 |
| DriverClassName | String | 驱动类名 |
| URL | String | 连接 URL（脱敏） |
| UserName | String | 用户名（脱敏） |
| Filter | String | 过滤器配置 |
| ConnectCount | long | 连接总数 |
| CloseCount | long | 关闭总数 |
| ActiveCount | int | 活跃连接数 |
| PoolingCount | int | 空闲连接数 |
| ActivePeak | int | 活跃峰值 |
| PoolingPeak | int | 空闲峰值 |
| InitialSize | int | 初始大小 |
| MinIdle | int | 最小空闲 |
| MaxActive | int | 最大活跃 |
| MaxWait | long | 最大等待 |

---

### 4. SQL 监控

**路径**: `/druid/sql.json`

**方法**: GET

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| orderBy | String | 否 | 排序字段 |
| order | String | 否 | 排序方向（asc/desc） |
| offset | int | 否 | 偏移量 |
| limit | int | 否 | 每页数量 |

**返回数据：**

```json
{
  "Result": [
    {
      "ID": 1,
      "SQL": "SELECT * FROM sys_user WHERE user_id = ?",
      "ExecuteCount": 1000,
      "FetchRowCount": 5000,
      "ExecuteTimeTotal": 12345,
      "ExecuteTimeMax": 156,
      "EffectedRowCount": 0,
      "LastExecuteTime": "2024-01-15 10:30:00",
      "IsSlowSql": false
    }
  ],
  "TotalRow": 100
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| ID | int | SQL 统计 ID |
| SQL | String | SQL 语句（脱敏） |
| ExecuteCount | long | 执行次数 |
| FetchRowCount | long | 返回行数 |
| ExecuteTimeTotal | long | 总执行时间 (ms) |
| ExecuteTimeMax | long | 最大执行时间 (ms) |
| EffectedRowCount | long | 影响行数 |
| LastExecuteTime | String | 最后执行时间 |
| IsSlowSql | boolean | 是否慢查询 |

**排序字段：**
- `SQL`: SQL 语句
- `ExecuteCount`: 执行次数
- `ExecuteTimeTotal`: 总执行时间
- `ExecuteTimeMax`: 最大执行时间
- `FetchRowCount`: 返回行数
- `LastExecuteTime`: 最后执行时间

---

### 5. 慢查询监控

**路径**: `/druid/slowsql.json`

**方法**: GET

**返回数据：**

```json
{
  "Result": [
    {
      "ID": 1,
      "SQL": "SELECT * FROM sys_user u LEFT JOIN sys_dept d ON u.dept_id = d.dept_id WHERE ...",
      "ExecuteCount": 10,
      "ExecuteTimeTotal": 15234,
      "ExecuteTimeMax": 2000,
      "LastExecuteTime": "2024-01-15 10:30:00"
    }
  ]
}
```

**慢查询阈值配置：**
```yaml
spring:
  datasource:
    druid:
      filter:
        stat:
          slow-sql-millis: 1000
          log-slow-sql: true
```

---

### 6. Wall 防火墙监控

**路径**: `/druid/wall.json`

**方法**: GET

**返回数据：**

```json
{
  "Result": {
    "RequestCount": 10000,
    "CheckCount": 10000,
    "DenyCount": 5,
    "HardCheckCount": 100,
    "ViolationMessageList": [
      {
        "Message": "sql injection violation",
        "SQL": "SELECT * FROM user WHERE id = 1 OR 1=1",
        "Time": "2024-01-15 10:30:00"
      }
    ]
  }
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| RequestCount | long | 请求总数 |
| CheckCount | long | 检查总数 |
| DenyCount | long | 拦截总数 |
| HardCheckCount | long | 硬检查次数 |
| ViolationMessageList | Array | 违规消息列表 |

---

### 7. Spring 监控

**路径**: `/druid/spring.json`

**方法**: GET

**返回数据：**

```json
{
  "Result": [
    {
      "BeanName": "userService",
      "BeanClass": "com.ruoyi.system.service.impl.UserServiceImpl",
      "ExecuteCount": 5000,
      "ExecuteTimeTotal": 25000,
      "ExecuteTimeMax": 100
    }
  ]
}
```

---

### 8. URI 监控

**路径**: `/druid/uri.json`

**方法**: GET

**返回数据：**

```json
{
  "Result": [
    {
      "URI": "/system/user/list",
      "RequestCount": 1000,
      "ExecuteTimeTotal": 50000,
      "ExecuteTimeMax": 200,
      "JDBCEntityCount": 5000,
      "ErrorCount": 0
    }
  ]
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| URI | String | 请求 URI |
| RequestCount | long | 请求次数 |
| ExecuteTimeTotal | long | 总执行时间 (ms) |
| ExecuteTimeMax | long | 最大执行时间 (ms) |
| JDBCEntityCount | long | JDBC 实体数 |
| ErrorCount | long | 错误次数 |

---

## 错误响应

### 401 未授权

```json
{
  "error": "Unauthorized",
  "message": "需要登录"
}
```

### 403 禁止访问

```json
{
  "error": "Forbidden",
  "message": "IP 不在白名单中"
}
```

### 500 服务器错误

```json
{
  "error": "Internal Server Error",
  "message": "详细错误信息"
}
```

## 配置 API

### 允许访问 IP 配置

**配置项：**
```yaml
spring:
  datasource:
    druid:
      stat-view-servlet:
        allow: 127.0.0.1,192.168.1.0/24
        deny: 192.168.1.100
```

**规则：**
- `allow`: 允许的 IP 列表（逗号分隔）
- `deny`: 禁止的 IP 列表（逗号分隔）
- 支持 CIDR 格式
- deny 优先级高于 allow

### 重置统计数据

**路径**: `/druid/reset-password.html`

**功能**: 重置监控统计数据

**配置：**
```yaml
spring:
  datasource:
    druid:
      stat-view-servlet:
        reset-enable: false  # 禁止重置
```

## 前端集成

### iFrame 组件

**文件位置**: `ruoyi-ui/src/components/iFrame/index.vue`

**使用方式：**
```vue
<template>
  <i-frame :src="url" />
</template>

<script>
import iFrame from "@/components/iFrame/index"

export default {
  name: "Druid",
  components: { iFrame },
  data() {
    return {
      url: process.env.VUE_APP_BASE_API + "/druid/login.html"
    }
  }
}
</script>
```

### 环境变量配置

**.env 文件：**
```bash
VUE_APP_BASE_API = /dev-api
```

**代理配置（vue.config.js）：**
```javascript
proxy: {
  '/dev-api': {
    target: 'http://localhost:8080',
    changeOrigin: true,
    pathRewrite: {
      '^/dev-api': ''
    }
  }
}
```

## 安全配置建议

### 1. 生产环境配置

```yaml
spring:
  datasource:
    druid:
      stat-view-servlet:
        enabled: true
        url-pattern: /druid/*
        reset-enable: false  # 禁止重置
        login-username: admin  # 强密码
        login-password: YourStrongPassword123!
        allow: 127.0.0.1  # 仅允许本地访问
```

### 2. 内网访问配置

```yaml
allow: 127.0.0.1,192.168.1.0/24
deny:  # 禁止特定 IP
```

### 3. 禁用监控（极端情况）

```yaml
spring:
  datasource:
    druid:
      stat-view-servlet:
        enabled: false
```

## 性能优化建议

### 1. 统计过滤配置

```yaml
spring:
  datasource:
    druid:
      filter:
        stat:
          enabled: true
          db-type: mysql
          log-slow-sql: true
          slow-sql-millis: 1000
          merge-sql: true  # 合并相同 SQL
```

### 2. 内存管理

```yaml
# 限制最大 SQL 统计数量
druid.stat.maxSqlCount: 1000

# 限制最大慢查询数量
druid.stat.slowSqlCount: 100
```

### 3. 异步日志

```yaml
# 启用异步日志记录
druid.stat.log-enabled: true
druid.stat.async-enabled: true
```
