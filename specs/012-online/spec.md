# 在线用户功能规格 (012-online)

**模块编号：** 012  
**模块名称：** 在线用户 (Online)  
**最后更新：** 2026-03-12

---

## 一、功能概述

### 1.1 功能描述

在线用户模块用于实时监控当前系统中所有在线用户的会话状态。该模块帮助管理员了解系统当前活跃用户情况，支持强制退出异常或违规用户，保障系统安全。

### 1.2 核心价值

- **实时监控：** 查看当前所有在线用户及其会话信息
- **安全管理：** 强制退出异常或违规用户
- **会话追踪：** 了解用户登录时间、地点、设备等信息
- **资源管理：** 监控系统并发用户数，合理分配资源

### 1.3 用户角色

| 角色 | 权限说明 |
|------|----------|
| 系统管理员 | 查看在线用户列表、强制退出用户 |
| 普通用户 | 无权限访问 |

---

## 二、功能需求

### 2.1 在线用户监控

#### FR-012-001 实时列表
系统应提供在线用户实时列表：
- 显示所有当前在线用户
- 显示用户会话编号（Token ID）
- 显示用户基本信息（姓名、部门）
- 显示登录信息（IP、地点、时间）
- 显示设备信息（浏览器、操作系统）

#### FR-012-002 数据来源
- 从 Redis 缓存中读取在线用户信息
- 基于 JWT Token 管理会话
- 自动清理过期 Token

#### FR-012-003 刷新机制
- 支持手动刷新列表
- 列表数据实时性高
- 自动清理过期会话

### 2.2 查询筛选

#### FR-012-004 条件查询
系统应提供在线用户查询功能：
- 支持按登录地址模糊搜索
- 支持按用户名称模糊搜索
- 支持组合条件查询
- 查询结果实时更新

### 2.3 用户管理

#### FR-012-005 强制退出
- 支持强制退出单个在线用户
- 退出前需二次确认
- 退出后清除用户 Token
- 用户需重新登录才能访问系统

---

## 三、权限要求

### 3.1 权限标识

| 功能 | 权限标识 | 说明 |
|------|----------|------|
| 查看列表 | `monitor:online:list` | 查看在线用户列表 |
| 强制退出 | `monitor:online:forceLogout` | 强制退出用户 |

### 3.2 权限控制
- 所有接口均需通过 `@PreAuthorize` 注解进行权限校验
- 前端按钮根据权限动态显示/隐藏
- 无权限访问返回 403 错误

---

## 四、业务规则

### 4.1 会话管理

- 用户登录成功后生成 JWT Token
- Token 存储在 Redis 中，key 格式：`login_tokens:{token}`
- Token 默认有效期 30 分钟
- 每次请求自动续期 Token

### 4.2 在线状态

- 用户在线：Token 在 Redis 中存在且未过期
- 用户离线：Token 过期或被删除
- 支持同一用户多端登录

### 4.3 强制退出

- 删除 Redis 中的 Token
- 用户后续请求因 Token 失效被拦截
- 前端收到 401 错误后跳转登录页

---

## 五、数据模型

### 5.1 在线用户实体

**类名：** `SysUserOnline`

**包路径：** `com.ruoyi.system.domain`

```java
public class SysUserOnline {
    /** 会话编号 */
    private String tokenId;
    
    /** 部门名称 */
    private String deptName;
    
    /** 用户名称 */
    private String userName;
    
    /** 登录 IP 地址 */
    private String ipaddr;
    
    /** 登录地址 */
    private String loginLocation;
    
    /** 浏览器类型 */
    private String browser;
    
    /** 操作系统 */
    private String os;
    
    /** 登录时间 */
    private Long loginTime;
    
    // getter/setter 方法...
}
```

### 5.2 登录用户信息

**类名：** `LoginUser`

**包路径：** `com.ruoyi.common.core.domain.model`

```java
public class LoginUser {
    private String token;
    private String username;
    private String password;
    private SysUser user;
    private String ipaddr;
    private String loginLocation;
    private String browser;
    private String os;
    private Long loginTime;
    private Long expireTime;
    
    // getter/setter 方法...
}
```

---

## 六、数据结构

### 6.1 Redis 存储结构

**Key 格式：** `login_tokens:{token}`

**Value 类型：** `LoginUser` 对象（序列化）

**过期时间：** 30 分钟（自动续期）

### 6.2 数据字段说明

| 字段名 | 类型 | 说明 |
|--------|------|------|
| tokenId | String | 会话编号（UUID） |
| userName | String | 用户名称 |
| deptName | String | 部门名称 |
| ipaddr | String | 登录 IP 地址 |
| loginLocation | String | 登录地点 |
| browser | String | 浏览器类型 |
| os | String | 操作系统 |
| loginTime | Long | 登录时间戳 |

---

## 七、异常处理

### 7.1 查询异常
- Redis 连接失败时返回空列表
- 查询超时返回友好提示
- 数据解析异常记录日志

### 7.2 退出异常
- Token 不存在时提示"用户已离线"
- 退出失败记录日志
- 不影响其他用户会话

---

## 八、相关模块

| 模块 | 关系说明 |
|------|----------|
| 操作日志 (010) | 同为系统监控模块 |
| 登录日志 (011) | 同为系统监控模块 |
| 定时任务 (013) | 同为系统监控模块 |
| 用户管理 | 用户信息管理 |
| 登录认证 | Token 生成和验证 |

---

## 九、验收标准

### 9.1 功能验收
- [ ] 在线用户列表显示正确
- [ ] 用户信息完整准确
- [ ] 查询功能正常
- [ ] 强制退出功能正常
- [ ] 退出后用户需重新登录

### 9.2 性能验收
- [ ] 列表查询响应时间 < 1 秒
- [ ] 支持 1000+ 并发用户正常显示
- [ ] Redis 操作高效

### 9.3 安全验收
- [ ] 权限控制有效
- [ ] 强制退出有二次确认
- [ ] Token 管理安全可靠

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12  
**审核状态：** 待审核
