# 016-pool - 连接池监视模块规格

## 概述

连接池监视模块提供对 Druid 数据库连接池的监控能力，通过内嵌的 Druid Monitor 页面，实时查看数据库连接池的运行状态、SQL 执行情况和性能指标。

## 用户故事

### US-001 查看连接池状态
**作为** 系统管理员  
**我想要** 查看数据库连接池的基本状态  
**以便于** 了解连接池的健康状况

**验收标准：**
- 能够访问 Druid 监控页面
- 显示连接池配置信息
- 显示当前活跃连接数
- 显示空闲连接数
- 显示连接池大小

### US-002 查看 SQL 监控
**作为** 开发人员  
**我想要** 查看 SQL 执行统计  
**以便于** 分析 SQL 性能和优化查询

**验收标准：**
- 显示所有执行的 SQL 语句
- 显示每条 SQL 的执行次数
- 显示每条 SQL 的执行时间
- 显示每条 SQL 的返回行数
- 支持按执行时间排序

### US-003 查看 SQL 慢查询
**作为** 开发人员  
**我想要** 查看慢查询 SQL  
**以便于** 定位和优化性能问题

**验收标准：**
- 显示执行时间超过阈值的 SQL
- 可配置慢查询阈值
- 显示慢查询的详细信息
- 支持导出慢查询列表

### US-004 查看数据源监控
**作为** 系统管理员  
**我想要** 查看数据源的详细信息  
**以便于** 监控数据库连接状态

**验收标准：**
- 显示数据源配置
- 显示连接使用情况
- 显示连接等待情况
- 显示连接泄漏检测

### US-005 查看 Wall 防火墙监控
**作为** 安全管理员  
**我想要** 查看 SQL 防火墙统计  
**以便于** 发现潜在的 SQL 注入攻击

**验收标准：**
- 显示被拦截的 SQL 请求
- 显示违规类型
- 显示拦截次数
- 提供白名单管理

### US-006 查看 Spring 监控
**作为** 开发人员  
**我想要** 查看 Spring Bean 的监控信息  
**以便于** 了解 Spring 组件的使用情况

**验收标准：**
- 显示 Spring Bean 列表
- 显示 Bean 的调用统计
- 显示 Bean 的执行时间
- 显示 Bean 的依赖关系

## 功能需求

### FR-001 Druid Monitor 集成
系统必须集成 Druid 自带的 Monitor 功能，提供完整的监控页面。

### FR-002 监控页面访问
系统必须提供安全的监控页面访问机制：
- 独立的登录页面
- 与主系统权限集成
- 支持会话管理

### FR-003 实时监控
系统必须提供实时的连接池监控：
- 连接数实时统计
- SQL 执行实时记录
- 性能指标实时更新

### FR-004 历史数据
系统必须保留一定时间的历史数据：
- SQL 执行历史
- 连接使用历史
- 性能趋势数据

### FR-005 告警功能
系统必须提供告警功能：
- 连接池耗尽告警
- 慢查询告警
- SQL 注入告警
- 连接泄漏告警

## 数据模型

### DruidStatData
Druid 监控统计数据。

**属性：**
- `dataSource`: 数据源信息
- `connections`: 连接池信息
- `sqlList`: SQL 执行列表
- `wallData`: 防火墙数据
- `springData`: Spring 监控数据

### DataSourceInfo
数据源配置信息。

**属性：**
- `name`: 数据源名称
- `url`: 数据库连接 URL
- `username`: 用户名
- `driverClassName`: 驱动类名
- `initialSize`: 初始连接数
- `minIdle`: 最小空闲连接数
- `maxActive`: 最大活跃连接数
- `maxWait`: 最大等待时间

### ConnectionInfo
连接池连接信息。

**属性：**
- `activeCount`: 活跃连接数
- `poolingCount`: 连接池中连接数
- `createCount`: 创建连接总数
- `destroyCount`: 销毁连接总数
- `connectCount`: 连接总数
- `closeCount`: 关闭连接总数

### SqlStat
SQL 执行统计信息。

**属性：**
- `sql`: SQL 语句
- `executeCount`: 执行次数
- `fetchRowCount`: 返回行数
- `executeTimeTotal`: 总执行时间
- `executeTimeMax`: 最大执行时间
- `effectedRowCount`: 影响行数
- `readStringLength`: 读取字符串长度
- `readBytesLength`: 读取字节长度
- `inputStreamOpenCount`: 输入流打开次数
- `readerOpenCount`: 读取器打开次数

## 关键实体

- **DruidDataSource**: Druid 数据源实现
- **StatFilter**: 统计过滤器
- **WallFilter**: SQL 防火墙过滤器
- **StatViewServlet**: 监控视图 Servlet

## 成功标准

### 性能指标
- 监控页面加载时间 < 3 秒
- SQL 统计更新延迟 < 1 秒
- 监控功能对性能影响 < 5%

### 可用性指标
- 监控页面可用性 ≥ 99%
- 支持并发访问
- 数据准确性 ≥ 99.9%

### 安全指标
- 监控页面访问受权限控制
- 敏感信息脱敏显示
- 支持访问 IP 白名单

## 假设

1. 项目使用 Druid 作为数据库连接池
2. Druid 版本支持 Monitor 功能
3. 监控页面通过内嵌方式集成
4. 用户具有访问监控页面的权限

## 依赖

- Alibaba Druid
- Spring Boot
- Servlet API
- Vue.js + Element UI（前端 iFrame 组件）

## 约束

1. 监控数据存储在内存中，重启后丢失
2. 大量 SQL 统计可能占用较多内存
3. 生产环境应限制监控页面访问
4. 某些敏感信息需要脱敏处理

## 配置说明

### application-druid.yml 配置项

```yaml
spring:
  datasource:
    druid:
      # 数据源配置
      url: jdbc:mysql://localhost:3306/ruoyi
      username: root
      password: password
      driver-class-name: com.mysql.cj.jdbc.Driver
      
      # 连接池配置
      initial-size: 5
      min-idle: 5
      max-active: 20
      max-wait: 60000
      
      # 监控配置
      stat-view-servlet:
        enabled: true
        url-pattern: /druid/*
        reset-enable: false
        login-username: admin
        login-password: admin
        allow: 127.0.0.1
        
      web-stat-filter:
        enabled: true
        url-pattern: /*
        exclusions: "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*"
```

## 监控页面功能

### 1. 数据源监控 (datasource.html)
- 查看数据源配置
- 查看连接池状态
- 查看连接使用情况
- 检测连接泄漏

### 2. SQL 监控 (sql.html)
- 查看所有 SQL 执行统计
- 按执行次数排序
- 按执行时间排序
- 查看 SQL 详情

### 3. SQL 慢查询 (slowsql.html)
- 查看慢查询列表
- 配置慢查询阈值
- 查看慢查询详情
- 导出慢查询记录

### 4. Wall 监控 (wall.html)
- 查看防火墙统计
- 查看被拦截的 SQL
- 查看违规类型
- 管理白名单

### 5. Spring 监控 (spring.html)
- 查看 Spring Bean 列表
- 查看 Bean 调用统计
- 查看方法执行时间
- 查看依赖关系

### 6. URI 监控 (uri.html)
- 查看 URI 访问统计
- 查看请求次数
- 查看响应时间
- 查看错误次数

### 7. JSON API 监控 (jsonapi.html)
- 查看 JSON API 调用
- 查看请求参数
- 查看响应结果
- 查看执行时间
