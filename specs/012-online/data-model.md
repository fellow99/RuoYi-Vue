# 在线用户数据模型 (012-online)

**模块编号：** 012  
**最后更新：** 2026-03-12

---

## 一、数据存储概述

### 1.1 存储方式

在线用户数据存储在 **Redis** 缓存中，不使用数据库表。

### 1.2 存储结构

| 项目 | 说明 |
|------|------|
| 存储介质 | Redis |
| Key 格式 | `login_tokens:{token}` |
| Value 类型 | LoginUser 对象（序列化） |
| 过期时间 | 30 分钟（可配置） |
| 过期策略 | 自动删除 |

---

## 二、Java 实体类

### 2.1 在线用户类：`SysUserOnline`

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

### 2.2 登录用户类：`LoginUser`

**包路径：** `com.ruoyi.common.core.domain.model`

```java
public class LoginUser {
    /** 会话令牌 */
    private String token;
    
    /** 用户账号 */
    private String username;
    
    /** 用户密码 */
    private String password;
    
    /** 系统用户 */
    private SysUser user;
    
    /** 登录 IP 地址 */
    private String ipaddr;
    
    /** 登录地点 */
    private String loginLocation;
    
    /** 浏览器 */
    private String browser;
    
    /** 操作系统 */
    private String os;
    
    /** 登录时间 */
    private Long loginTime;
    
    /** 过期时间 */
    private Long expireTime;
    
    // getter/setter 方法...
}
```

---

## 三、Redis 缓存设计

### 3.1 Key 命名规范

```
login_tokens:{token}
```

**示例：**
```
login_tokens:eyJhbGciOiJIUzUxMiJ9...
```

### 3.2 Value 结构

存储 `LoginUser` 对象的序列化数据（JSON 格式）

```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9...",
  "username": "admin",
  "user": {
    "userId": 1,
    "userName": "admin",
    "nickName": "管理员",
    "dept": {
      "deptId": 103,
      "deptName": "研发部门"
    }
  },
  "ipaddr": "192.168.1.100",
  "loginLocation": "XX 省 XX 市",
  "browser": "Chrome",
  "os": "Windows 10",
  "loginTime": 1710234567000,
  "expireTime": 1710236367000
}
```

### 3.3 过期策略

- 默认过期时间：30 分钟
- 每次请求自动续期
- 过期后自动删除

---

## 四、服务层接口

### 4.1 Service 接口

**接口路径：** `com.ruoyi.system.service.ISysUserOnlineService`

```java
public interface ISysUserOnlineService {
    /**
     * 通过登录地址查询信息
     */
    SysUserOnline selectOnlineByIpaddr(String ipaddr, LoginUser user);
    
    /**
     * 通过用户名称查询信息
     */
    SysUserOnline selectOnlineByUserName(String userName, LoginUser user);
    
    /**
     * 通过登录地址/用户名称查询信息
     */
    SysUserOnline selectOnlineByInfo(String ipaddr, String userName, LoginUser user);
    
    /**
     * 设置在线用户信息
     */
    SysUserOnline loginUserToUserOnline(LoginUser user);
}
```

### 4.2 Service 实现

**实现路径：** `com.ruoyi.system.service.impl.SysUserOnlineServiceImpl`

主要方法：
- `selectOnlineByIpaddr` - 按 IP 筛选
- `selectOnlineByUserName` - 按用户名筛选
- `selectOnlineByInfo` - 组合条件筛选
- `loginUserToUserOnline` - LoginUser 转 SysUserOnline

---

## 五、Redis 工具类

### 5.1 RedisCache

**类路径：** `com.ruoyi.common.core.redis.RedisCache`

主要方法：
- `keys(String pattern)` - 获取匹配 key 的集合
- `getCacheObject(String key)` - 获取对象
- `deleteObject(String key)` - 删除对象

### 5.2 使用示例

```java
@Autowired
private RedisCache redisCache;

// 获取所有在线用户 Token
Collection<String> keys = redisCache.keys(CacheConstants.LOGIN_TOKEN_KEY + "*");

// 获取用户信息
LoginUser user = redisCache.getCacheObject(key);

// 删除 Token（强制退出）
redisCache.deleteObject(CacheConstants.LOGIN_TOKEN_KEY + tokenId);
```

---

## 六、常量定义

### 6.1 缓存常量

**类路径：** `com.ruoyi.common.constant.CacheConstants`

```java
public class CacheConstants {
    /**
     * 登录令牌前缀
     */
    public static final String LOGIN_TOKEN_KEY = "login_tokens:";
}
```

---

## 七、数据转换

### 7.1 LoginUser → SysUserOnline

```java
public SysUserOnline loginUserToUserOnline(LoginUser user) {
    if (user == null || user.getUser() == null) {
        return null;
    }
    SysUserOnline sysUserOnline = new SysUserOnline();
    sysUserOnline.setTokenId(user.getToken());
    sysUserOnline.setUserName(user.getUsername());
    sysUserOnline.setIpaddr(user.getIpaddr());
    sysUserOnline.setLoginLocation(user.getLoginLocation());
    sysUserOnline.setBrowser(user.getBrowser());
    sysUserOnline.setOs(user.getOs());
    sysUserOnline.setLoginTime(user.getLoginTime());
    if (user.getUser().getDept() != null) {
        sysUserOnline.setDeptName(user.getUser().getDept().getDeptName());
    }
    return sysUserOnline;
}
```

---

## 八、数据约束

### 8.1 字段约束

| 字段 | 约束 | 说明 |
|------|------|------|
| tokenId | 必填，UUID | 会话编号 |
| userName | 必填 | 用户账号 |
| loginTime | 必填，时间戳 | 登录时间 |
| expireTime | 必填，时间戳 | 过期时间 |

### 8.2 时间约束

- 登录时间：Unix 时间戳（毫秒）
- 过期时间：登录时间 + 30 分钟
- 续期：每次请求刷新过期时间

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
