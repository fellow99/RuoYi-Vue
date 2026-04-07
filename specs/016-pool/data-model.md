# 016-pool - 数据模型

## 实体关系图

```
┌─────────────────────────┐
│   DruidStatData         │
├─────────────────────────┤
│ - dataSource            │
│ - connections           │
│ - sqlList               │
│ - wallData              │
│ - springData            │
└───────────┬─────────────┘
            │
    ┌───────┼───────┬──────────┬──────────┐
    ↓       ↓       ↓          ↓          ↓
┌────────┐ ┌──────┐ ┌────────┐ ┌──────┐ ┌──────────┐
│DataSource│ │Connection│ │ SqlStat│ │ Wall │ │ Spring   │
│Info     │ │Info   │ │        │ │Data  │ │ Data     │
└────────┘ └──────┘ └────────┘ └──────┘ └──────────┘
```

## 数据模型详细定义

### DruidStatData（Druid 统计数据）

**说明：** Druid 监控数据的聚合根，包含所有监控子数据。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| dataSource | DataSourceInfo | 数据源配置信息 |
| connections | ConnectionInfo | 连接池连接信息 |
| sqlList | List<SqlStat> | SQL 执行统计列表 |
| wallData | WallData | SQL 防火墙数据 |
| springData | SpringData | Spring 监控数据 |

---

### DataSourceInfo（数据源信息）

**说明：** 数据库数据源配置信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| name | String | 数据源名称 |
| url | String | 数据库连接 URL |
| username | String | 用户名（脱敏） |
| driverClassName | String | 驱动类名 |
| initialSize | int | 初始连接数 |
| minIdle | int | 最小空闲连接数 |
| maxActive | int | 最大活跃连接数 |
| maxWait | long | 最大等待时间 (ms) |
| timeBetweenEvictionRunsMillis | long | 检测间隔 |
| minEvictableIdleTimeMillis | long | 最小空闲时间 |
| validationQuery | String | 验证查询 SQL |
| testWhileIdle | boolean | 空闲时检测 |
| testOnBorrow | boolean | 借出时检测 |
| testOnReturn | boolean | 归还时检测 |
| poolPreparedStatements | boolean | 缓存预处理语句 |
| maxPoolPreparedStatementPerConnectionSize | int | 最大缓存大小 |

**配置示例：**
```yaml
url: jdbc:mysql://localhost:3306/ruoyi?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
username: root
password: ******
driver-class-name: com.mysql.cj.jdbc.Driver
initial-size: 5
min-idle: 5
max-active: 20
max-wait: 60000
```

---

### ConnectionInfo（连接池信息）

**说明：** 数据库连接池运行状态信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| activeCount | int | 活跃连接数（正在使用） |
| poolingCount | int | 连接池中连接数（空闲） |
| createCount | long | 创建连接总数 |
| destroyCount | long | 销毁连接总数 |
| connectCount | long | 连接总数 |
| closeCount | long | 关闭连接总数 |
| lastCreateStartTime | long | 最后一次创建开始时间 |
| lastCreateEndTime | long | 最后一次创建结束时间 |
| nettyIOWaitThreadCount | int | Netty IO 等待线程数 |

**计算公式：**
```
当前总连接数 = activeCount + poolingCount
连接使用率 = activeCount / maxActive × 100%
```

**告警阈值：**
- 连接使用率 > 80%：警告
- 连接使用率 > 90%：严重
- activeCount > maxActive：错误

---

### SqlStat（SQL 执行统计）

**说明：** 单条 SQL 语句的执行统计信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| sql | String | SQL 语句（脱敏） |
| executeCount | long | 执行次数 |
| fetchRowCount | long | 返回行数总计 |
| executeTimeTotal | long | 总执行时间 (ms) |
| executeTimeMax | long | 最大执行时间 (ms) |
| effectedRowCount | long | 影响行数总计 |
| readStringLength | long | 读取字符串长度 |
| readBytesLength | long | 读取字节长度 |
| inputStreamOpenCount | long | 输入流打开次数 |
| readerOpenCount | long | 读取器打开次数 |
| name | String | SQL 名称/标识 |
| dbType | String | 数据库类型 |
| formatSql | String | 格式化后的 SQL |
| isSlowSql | boolean | 是否慢查询 |
| lastExecuteTime | long | 最后执行时间戳 |
| executeAndResultHoldTime | long | 执行结果保持时间 |

**派生字段：**
```
平均执行时间 = executeTimeTotal / executeCount
平均返回行数 = fetchRowCount / executeCount
```

**排序规则：**
- 按执行次数降序
- 按总执行时间降序
- 按最大执行时间降序
- 按最后执行时间降序

---

### WallData（防火墙数据）

**说明：** SQL 防火墙监控数据。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| requestCount | long | 请求总数 |
| checkCount | long | 检查总数 |
| denyCount | long | 拦截总数 |
| hardCheckCount | long | 硬检查次数 |
| violationMessageList | List<ViolationMessage> | 违规消息列表 |
| whiteList | List<String> | 白名单列表 |
| blackList | List<String> | 黑名单列表 |

**违规类型：**
- `none`: 无违规
- `syntax-error`: 语法错误
- `statement-not-allowed`: 语句不允许
- `function-not-allowed`: 函数不允许
- `table-not-allowed`: 表不允许
- `column-not-allowed`: 列不允许
- `variant-not-allowed`: 变量不允许
- `condition-not-allowed`: 条件不允许
- `insert-not-allowed`: 插入不允许
- `update-not-allowed`: 更新不允许
- `delete-not-allowed`: 删除不允许
- `truncate-not-allowed`: 截断不允许
- `drop-not-allowed`: 删除表不允许
- `alter-not-allowed`: 修改不允许
- `merge-not-allowed`: 合并不允许
- `multi-statement-not-allowed`: 多语句不允许
- `hint-not-allowed`: 提示不允许
- `call-not-allowed`: 调用不允许
- `dbms-not-allowed`: 数据库操作不允许
- `user-not-allowed`: 用户不允许
- `role-not-allowed`: 角色不允许
- `procedure-not-allowed`: 存储过程不允许
- `cursor-not-allowed`: 游标不允许

---

### SpringData（Spring 监控数据）

**说明：** Spring Bean 监控数据。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| beanName | String | Bean 名称 |
| beanClass | String | Bean 类名 |
| executeCount | long | 执行次数 |
| executeTimeTotal | long | 总执行时间 (ms) |
| executeTimeMax | long | 最大执行时间 (ms) |
| methodList | List<MethodStat> | 方法统计列表 |

**MethodStat（方法统计）：**
| 字段名 | 类型 | 说明 |
|--------|------|------|
| methodName | String | 方法名 |
| executeCount | long | 执行次数 |
| executeTimeTotal | long | 总执行时间 |
| executeTimeMax | long | 最大执行时间 |

---

## 数据采集流程

### 数据源监控数据采集

```
DruidDataSource
    ↓
DataSourceStat
    ↓
ConnectionPoolStat
    ↓
┌────────────────────────────────┐
│ - activeCount                  │
│ - poolingCount                 │
│ - createCount                  │
│ - destroyCount                 │
│ - connectCount                 │
│ - closeCount                   │
└────────────────────────────────┘
```

### SQL 监控数据采集

```
SQL 执行
    ↓
StatFilter
    ↓
StatementProxy
    ↓
ResultSetProxy
    ↓
SqlStat
    ↓
┌────────────────────────────────┐
│ - sql                          │
│ - executeCount                 │
│ - fetchRowCount                │
│ - executeTimeTotal             │
│ - executeTimeMax               │
└────────────────────────────────┘
```

### 防火墙数据采集

```
SQL 请求
    ↓
WallFilter
    ↓
WallProvider
    ↓
WallStat
    ↓
┌────────────────────────────────┐
│ - requestCount                 │
│ - checkCount                   │
│ - denyCount                    │
│ - violationMessageList         │
└────────────────────────────────┘
```

## 数据存储策略

### 存储位置
- **内存存储**: 所有统计数据存储在内存中
- **JMX 导出**: 支持通过 JMX 导出监控数据
- **HTTP 接口**: 提供 JSON 格式的监控数据接口

### 数据保留
- **SQL 统计**: 默认保留所有历史数据
- **慢查询**: 默认保留 1000 条记录
- **防火墙**: 默认保留 1000 条违规记录
- **可配置**: 通过配置项调整保留数量

### 内存管理
```java
// 最大 SQL 统计数量
druid.stat.maxSqlCount=1000

// 最大慢查询数量
druid.stat.slowSqlCount=1000

// 最大违规记录数量
druid.stat.wall.denyCount=1000
```

## 数据脱敏规则

### SQL 脱敏
```java
// 密码脱敏
SELECT * FROM user WHERE password = '******'

// 身份证号脱敏
SELECT * FROM user WHERE id_card = '110101********1234'

// 手机号脱敏
SELECT * FROM user WHERE phone = '138****1234'
```

### 用户名脱敏
```java
// 显示部分字符
username: r**t
```

## 数据转换规则

### 时间格式转换
```java
// 毫秒转人类可读
executeTimeTotal: 1234567 → "1 分 23 秒 456 毫秒"

// 时间戳转日期时间
lastExecuteTime: 1704067200000 → "2024-01-01 00:00:00"
```

### 字节转换
```java
// 字节转人类可读
readBytesLength: 1048576 → "1.00 MB"
```

## 数据验证规则

### 连接池验证
```
activeCount >= 0
poolingCount >= 0
activeCount + poolingCount <= maxActive
createCount >= connectCount
destroyCount >= closeCount
```

### SQL 统计验证
```
executeCount >= 0
fetchRowCount >= 0
executeTimeTotal >= 0
executeTimeMax >= 0
executeTimeTotal / executeCount >= 0
```

### 防火墙验证
```
requestCount >= checkCount
checkCount >= denyCount
denyCount >= 0
```
