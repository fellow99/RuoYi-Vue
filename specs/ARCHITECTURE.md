# 整体架构文档 (ARCHITECTURE.md)

**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、系统架构概述

### 1.1 架构风格

RuoYi-Vue 采用**前后端分离的分层架构**：

```
┌─────────────────────────────────────────────────────────────┐
│                      用户浏览器                              │
│                    (Vue 2.x + Element UI)                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP/HTTPS + JSON
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      后端服务层                              │
│                  (Spring Boot 4.x + JWT)                     │
│  ┌─────────────┬─────────────┬─────────────┬─────────────┐  │
│  │  Controller │   Service   │   Mapper    │   Entity    │  │
│  │    层       │    层       │    层       │    层       │  │
│  └─────────────┴─────────────┴─────────────┴─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
         ┌─────────┐    ┌─────────┐    ┌─────────┐
         │  MySQL  │    │  Redis  │    │  文件   │
         │ 数据库   │    │  缓存   │    │  存储   │
         └─────────┘    └─────────┘    └─────────┘
```

### 1.2 架构特点

- **前后端分离：** 前端负责展示交互，后端负责业务逻辑和数据
- **RESTful API：** 标准化接口设计，易于维护和扩展
- **无状态认证：** JWT Token 认证，支持水平扩展
- **模块化设计：** 多模块 Maven 项目，职责清晰
- **AOP 切面：** 统一处理日志、权限、事务

---

## 二、系统分层架构

### 2.1 四层架构模型

```
┌────────────────────────────────────────────────────────────┐
│                    Controller 层                            │
│  • 接收 HTTP 请求                                            │
│  • 参数校验                                                 │
│  • 调用 Service 层                                          │
│  • 返回统一响应格式                                         │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│                     Service 层                              │
│  • 业务逻辑实现                                             │
│  • 事务控制                                                 │
│  • 调用 Mapper 层                                           │
│  • 数据组装                                                 │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│                     Mapper 层                               │
│  • 数据库访问                                               │
│  • SQL 执行                                                 │
│  • 结果集映射                                               │
└────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────┐
│                     Entity 层                               │
│  • 数据实体定义                                             │
│  • 数据库表映射                                             │
│  • 数据传输对象                                             │
└────────────────────────────────────────────────────────────┘
```

### 2.2 各层职责详解

#### Controller 层
- **位置：** `ruoyi-admin/src/main/java/com/ruoyi/web/controller/`
- **职责：**
  - 接收和解析 HTTP 请求
  - 参数验证（使用注解）
  - 调用 Service 层处理业务
  - 封装统一响应结果（AjaxResult）
  - 处理异常（全局异常处理器）

#### Service 层
- **位置：** `ruoyi-system/src/main/java/com/ruoyi/system/service/`
- **职责：**
  - 实现核心业务逻辑
  - 事务管理（@Transactional）
  - 数据校验和业务规则
  - 调用一个或多个 Mapper
  - 数据转换和组装

#### Mapper 层
- **位置：** `ruoyi-system/src/main/java/com/ruoyi/system/mapper/`
- **职责：**
  - 定义数据库访问接口
  - 执行 SQL 语句（XML 或注解）
  - 结果集映射到实体类
  - 支持动态 SQL（MyBatis）

#### Entity 层
- **位置：** `ruoyi-system/src/main/java/com/ruoyi/system/domain/`
- **职责：**
  - 定义数据实体类
  - 数据库表字段映射（@TableName）
  - 支持链式调用和 Builder 模式
  - 包含 DTO、VO、DO 等变体

---

## 三、模块依赖关系

### 3.1 模块结构

```
RuoYi-Vue/
├── ruoyi-admin/           # 主启动模块（入口）
├── ruoyi-common/          # 通用模块（公共代码）
├── ruoyi-system/          # 系统业务模块
├── ruoyi-framework/       # 框架模块（核心框架）
├── ruoyi-generator/       # 代码生成模块
├── ruoyi-quartz/          # 定时任务模块
└── ruoyi-ui/              # 前端项目（Vue）
```

### 3.2 依赖关系图

```
                    ┌─────────────────┐
                    │   ruoyi-admin   │
                    │   (主启动模块)   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ ruoyi-common │    │ruoyi-system  │    │ruoyi-framework│
│  (通用模块)   │    │ (系统模块)    │    │  (框架模块)   │
└──────────────┘    └──────────────┘    └──────────────┘
        ▲                    ▲                    ▲
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
              ▼                             ▼
     ┌──────────────┐              ┌──────────────┐
     │ruoyi-generator│              │ ruoyi-quartz │
     │ (代码生成)    │              │ (定时任务)    │
     └──────────────┘              └──────────────┘
```

### 3.3 模块职责

| 模块 | 职责 | 核心包路径 |
|------|------|------------|
| **ruoyi-admin** | 主启动模块、Controller 层、配置文件 | `com.ruoyi.web` |
| **ruoyi-common** | 通用工具、常量、注解、异常、核心类 | `com.ruoyi.common` |
| **ruoyi-system** | 系统业务逻辑、Service/Mapper/Entity | `com.ruoyi.system` |
| **ruoyi-framework** | 框架核心、安全配置、拦截器、AOP | `com.ruoyi.framework` |
| **ruoyi-generator** | 代码生成器、模板引擎 | `com.ruoyi.generator` |
| **ruoyi-quartz** | 定时任务调度、任务管理 | `com.ruoyi.quartz` |
| **ruoyi-ui** | 前端 Vue 项目 | - |

### 3.4 Maven 依赖配置

```xml
<!-- ruoyi-admin 依赖 -->
<dependencies>
    <dependency>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-common</artifactId>
    </dependency>
    <dependency>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-system</artifactId>
    </dependency>
    <dependency>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-framework</artifactId>
    </dependency>
    <dependency>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-generator</artifactId>
    </dependency>
    <dependency>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-quartz</artifactId>
    </dependency>
</dependencies>
```

---

## 四、数据流向

### 4.1 请求处理流程

```
用户请求
   │
   ▼
┌─────────────────┐
│  Nginx/网关     │ (可选，生产环境)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 安全过滤器链     │ (Spring Security + JWT)
│ - 认证检查       │
│ - 权限验证       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  拦截器          │ (重复提交、日志)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Controller     │ (接收请求)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Service       │ (业务逻辑)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Mapper        │ (数据库访问)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   MySQL/Redis   │ (数据存储)
└─────────────────┘
```

### 4.2 响应返回流程

```
数据库查询结果
   │
   ▼
┌─────────────────┐
│   Mapper        │ (结果集映射)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Service       │ (数据组装、业务处理)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Controller     │ (封装响应)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  统一响应格式    │ (AjaxResult)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  前端接收处理    │ (Axios 拦截器)
└─────────────────┘
```

### 4.3 统一响应格式

```java
{
    "code": 200,          // 状态码
    "msg": "操作成功",     // 提示信息
    "data": {}            // 返回数据
}
```

---

## 五、关键设计模式

### 5.1 单例模式 (Singleton)

**应用场景：** Spring Bean、工具类

```java
// Spring 默认单例
@Service
public class UserServiceImpl implements UserService {
    // Spring 容器管理单例
}

// 工具类单例
public class StringUtils {
    private StringUtils() {} // 私有构造
    public static boolean isEmpty(String str) { ... }
}
```

### 5.2 工厂模式 (Factory)

**应用场景：** SqlSessionFactory、Bean 创建

```java
// Spring 工厂
@Autowired
private UserService userService; // Spring 工厂注入
```

### 5.3 代理模式 (Proxy)

**应用场景：** AOP 切面、事务管理

```java
// AOP 代理 - 操作日志
@Aspect
@Component
public class LogAspect {
    @Around("execution(* com.ruoyi..*.*(..)) && @annotation(log)")
    public Object around(ProceedingJoinPoint point, Log log) {
        // 前置：记录操作信息
        Object result = point.proceed(); // 执行目标方法
        // 后置：记录执行结果
        return result;
    }
}

// 事务代理
@Transactional
public void insertUser(User user) {
    // 事务由代理管理
}
```

### 5.4 模板方法模式 (Template Method)

**应用场景：** BaseMapper、BaseService

```java
// MyBatis-Plus 基类
public interface BaseMapper<T> extends Mapper<T> {
    // 定义标准 CRUD 方法
    int insert(T entity);
    int deleteById(Serializable id);
    T selectById(Serializable id);
    // ...
}
```

### 5.5 策略模式 (Strategy)

**应用场景：** 登录策略、存储策略

```java
// 认证策略
public interface AuthenticationStrategy {
    boolean authenticate(String username, String password);
}

// 实现：密码认证
@Component("passwordAuth")
public class PasswordAuthentication implements AuthenticationStrategy {
    public boolean authenticate(String username, String password) {
        // 密码验证逻辑
    }
}

// 实现：短信认证
@Component("smsAuth")
public class SmsAuthentication implements AuthenticationStrategy {
    public boolean authenticate(String phone, String code) {
        // 短信验证逻辑
    }
}
```

### 5.6 观察者模式 (Observer)

**应用场景：** Spring 事件、异步通知

```java
// 定义事件
public class LoginEvent extends ApplicationEvent {
    private final User user;
    // 构造方法...
}

// 发布事件
@Autowired
private ApplicationEventPublisher eventPublisher;

public void login(User user) {
    // 登录逻辑...
    eventPublisher.publishEvent(new LoginEvent(this, user));
}

// 监听事件
@Component
public class LoginListener {
    @EventListener
    public void handleLogin(LoginEvent event) {
        // 记录登录日志
    }
}
```

### 5.7 责任链模式 (Chain of Responsibility)

**应用场景：** Spring Security 过滤器链

```
请求 → JwtAuthenticationFilter → UsernamePasswordAuthenticationFilter
     → ExceptionTranslationFilter → FilterSecurityInterceptor → 资源
```

### 5.8 构建器模式 (Builder)

**应用场景：** 实体类构建、查询条件构建

```java
// Lombok @Builder
@Data
@Builder
public class User {
    private Long userId;
    private String username;
    private String email;
}

// 使用
User user = User.builder()
    .userId(1L)
    .username("admin")
    .email("admin@ruoyi.com")
    .build();
```

---

## 六、核心组件设计

### 6.1 认证授权组件

```
┌─────────────────────────────────────────────────────────────┐
│                   JwtAuthenticationToken                    │
│                    (JWT 认证令牌)                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              JwtAuthenticationFilter                        │
│              (JWT 认证过滤器)                                │
│  • 解析 Token                                                │
│  • 验证签名                                                  │
│  • 设置 SecurityContext                                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              UserDetailsServiceImpl                         │
│              (用户详情服务)                                  │
│  • 加载用户信息                                              │
│  • 加载用户权限                                              │
│  • 返回 UserDetails                                          │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 权限控制组件

```
┌─────────────────────────────────────────────────────────────┐
│                   @PreAuthorize                             │
│              (方法级权限注解)                                │
│  @PreAuthorize("@ss.hasPermi('system:user:list')")          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              PermissionService                              │
│              (权限服务)                                      │
│  • hasPermi(): 检查权限标识                                  │
│  • hasRole(): 检查角色                                       │
│  • isPermitted(): 权限验证                                   │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 数据权限组件

```
┌─────────────────────────────────────────────────────────────┐
│              @DataScope                                     │
│              (数据范围注解)                                  │
│  @DataScope(deptAlias = "d", userAlias = "u")               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              DataScopeAspect                                │
│              (数据范围切面)                                  │
│  • 拦截注解                                                  │
│  • 根据角色数据范围生成 SQL 过滤                               │
│  • 注入到 SQL 参数                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.4 缓存组件

```
┌─────────────────────────────────────────────────────────────┐
│              @Cacheable / @CacheEvict                       │
│              (Spring Cache 注解)                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              RedisCacheManager                              │
│              (Redis 缓存管理器)                               │
│  • 配置缓存策略                                              │
│  • 序列化配置                                                │
│  • TTL 设置                                                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Redis                                      │
│              (缓存存储)                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 七、前端架构

### 7.1 前端目录结构

```
ruoyi-ui/
├── src/
│   ├── api/              # API 接口
│   │   ├── monitor/      # 监控模块 API
│   │   ├── system/       # 系统模块 API
│   │   └── tool/         # 工具模块 API
│   ├── assets/           # 静态资源
│   ├── components/       # 公共组件
│   ├── directive/        # 自定义指令
│   ├── layout/           # 布局组件
│   ├── plugins/          # 插件
│   ├── router/           # 路由配置
│   ├── store/            # Vuex 状态管理
│   ├── utils/            # 工具函数
│   └── views/            # 页面视图
├── public/               # 公共目录
├── build/                # 构建配置
└── package.json          # 依赖配置
```

### 7.2 前端架构分层

```
┌─────────────────────────────────────────────────────────────┐
│                     Views 层                                 │
│                  (页面视图组件)                               │
│  • views/system/user/index.vue                              │
│  • views/monitor/job/index.vue                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Components 层                               │
│                  (公共组件)                                  │
│  • components/Table/                                        │
│  • components/Form/                                         │
│  • components/Dialog/                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      API 层                                  │
│                  (接口封装)                                  │
│  • api/system/user.js                                       │
│  • api/monitor/job.js                                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Utils 层                                   │
│                  (工具函数)                                  │
│  • utils/request.js (Axios 封装)                             │
│  • utils/auth.js (Token 管理)                                │
│  • utils/dict.js (字典工具)                                  │
└─────────────────────────────────────────────────────────────┘
```

### 7.3 状态管理 (Vuex)

```
┌─────────────────────────────────────────────────────────────┐
│                      Store                                  │
│  ┌─────────────┬─────────────┬─────────────┬─────────────┐  │
│  │   User      │   TagsView  │   Permission│   Settings  │  │
│  │   用户状态   │  标签页状态  │  权限状态   │  设置状态   │  │
│  └─────────────┴─────────────┴─────────────┴─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 7.4 路由设计

```javascript
// 路由分类
const routes = [
  // 公共路由 (constantRoutes)
  { path: '/login', component: login, hidden: true },
  { path: '/404', component: error404, hidden: true },
  
  // 动态路由 (dynamicRoutes)
  // 根据用户权限动态生成
  {
    path: '/system',
    component: Layout,
    children: [
      { path: 'user', component: user, meta: { title: '用户管理' } }
    ]
  }
]
```

---

## 八、部署架构

### 8.1 开发环境

```
┌─────────────┐    ┌─────────────┐
│  前端开发    │    │  后端开发    │
│  (localhost)│    │ (localhost) │
│  :80        │    │ :8080       │
└─────────────┘    └─────────────┘
```

### 8.2 生产环境

```
┌─────────────────────────────────────────────────────────────┐
│                      Nginx                                  │
│                  (反向代理/负载均衡)                          │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
     ┌─────────────────┐             ┌─────────────────┐
     │   前端静态资源   │             │   后端服务       │
     │   (dist/)       │             │   (JAR)         │
     └─────────────────┘             └────────┬────────┘
                                              │
                              ┌───────────────┼───────────────┐
                              │               │               │
                              ▼               ▼               ▼
                        ┌─────────┐    ┌─────────┐    ┌─────────┐
                        │  MySQL  │    │  Redis  │    │  文件   │
                        │ 主从    │    │ 集群    │    │  存储   │
                        └─────────┘    └─────────┘    └─────────┘
```

---

**文档版本：** 1.0  
**维护者：** 开发团队  
**最后更新：** 2026-03-12
