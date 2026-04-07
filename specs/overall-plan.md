# 整体技术方案 (overall-plan.md)

**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、技术方案概述

### 1.1 架构选型

RuoYi-Vue 采用**前后端分离架构**，后端基于 Spring Boot，前端基于 Vue.js，通过 RESTful API 进行通信。

```
┌─────────────────────────────────────────────────────────────┐
│                         用户层                               │
│                    (浏览器/移动端)                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       接入层                                 │
│                   (Nginx 反向代理)                            │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────┐            ┌─────────────────────┐
│     前端应用         │            │     后端应用         │
│   (Vue 2.x SPA)     │            │  (Spring Boot 4.x)  │
│   静态资源服务       │            │   RESTful API 服务   │
└─────────────────────┘            └──────────┬──────────┘
                                              │
                              ┌───────────────┼───────────────┐
                              │               │               │
                              ▼               ▼               ▼
                        ┌─────────┐    ┌─────────┐    ┌─────────┐
                        │  MySQL  │    │  Redis  │    │  文件   │
                        │ 数据库   │    │  缓存   │    │  存储   │
                        └─────────┘    └─────────┘    └─────────┘
```

### 1.2 技术栈选择

| 层次 | 技术选型 | 版本 | 说明 |
|------|----------|------|------|
| 前端框架 | Vue.js | 2.7.x | 响应式前端框架 |
| UI 组件库 | Element UI | 2.15.x | 桌面端组件库 |
| 状态管理 | Vuex | 3.6.x | 全局状态管理 |
| 路由管理 | Vue Router | 3.6.x | 单页应用路由 |
| HTTP 客户端 | Axios | 0.27.x | HTTP 请求封装 |
| 后端框架 | Spring Boot | 4.x | 应用框架 |
| 安全框架 | Spring Security | 6.x | 认证授权 |
| ORM 框架 | MyBatis-Plus | 3.5.x | 数据持久化 |
| 数据库 | MySQL | 8.0+ | 关系数据库 |
| 缓存 | Redis | 5.0+ | 内存数据库 |
| 认证 | JWT | 0.12.x | 无状态认证 |

### 1.3 架构优势

1. **前后端分离**
   - 前端专注于 UI 和交互
   - 后端专注于业务逻辑和数据
   - 并行开发，提高效率

2. **RESTful API**
   - 标准化接口设计
   - 易于理解和维护
   - 支持多端调用

3. **无状态认证**
   - JWT Token 认证
   - 服务端不存储会话
   - 支持水平扩展

4. **模块化设计**
   - 多模块 Maven 项目
   - 职责清晰，易于维护
   - 支持功能扩展

---

## 二、系统部署架构

### 2.1 开发环境部署

```
┌─────────────────────────────────────────────────────────────┐
│                    开发机器                                  │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │   前端开发       │              │   后端开发       │       │
│  │   npm run serve │              │   Spring Boot   │       │
│  │   localhost:80  │              │   localhost:8080│       │
│  └─────────────────┘              └─────────────────┘       │
│                                                              │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │     MySQL       │              │      Redis      │       │
│  │   localhost:3306│              │  localhost:6379 │       │
│  └─────────────────┘              └─────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 测试环境部署

```
┌─────────────────────────────────────────────────────────────┐
│                      测试服务器                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                      Nginx                          │    │
│  │                  反向代理/负载均衡                   │    │
│  └─────────────────────┬───────────────────────────────┘    │
│                        │                                     │
│        ┌───────────────┴───────────────┐                    │
│        │                               │                    │
│        ▼                               ▼                    │
│  ┌─────────────┐               ┌─────────────┐              │
│  │  前端静态    │               │  后端服务    │              │
│  │  (dist/)    │               │   (JAR)     │              │
│  └─────────────┘               └──────┬──────┘              │
│                                       │                      │
│                        ┌──────────────┼──────────────┐      │
│                        │              │              │      │
│                        ▼              ▼              ▼      │
│                  ┌─────────┐   ┌─────────┐   ┌─────────┐   │
│                  │  MySQL  │   │  Redis  │   │  文件   │   │
│                  │  主从   │   │  单节点  │   │  存储   │   │
│                  └─────────┘   └─────────┘   └─────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 生产环境部署

```
┌─────────────────────────────────────────────────────────────┐
│                      负载均衡层                              │
│                   (Nginx / SLB)                             │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────────┐      ┌─────────────────────────┐
│      应用服务器 1        │      │      应用服务器 2        │
│  ┌─────────────────┐    │      │  ┌─────────────────┐    │
│  │  前端静态资源    │    │      │  │  前端静态资源    │    │
│  │  (Nginx)        │    │      │  │  (Nginx)        │    │
│  └─────────────────┘    │      │  └─────────────────┘    │
│  ┌─────────────────┐    │      │  ┌─────────────────┐    │
│  │  后端服务        │    │      │  │  后端服务        │    │
│  │  (Spring Boot)  │    │      │  │  (Spring Boot)  │    │
│  └─────────────────┘    │      │  └─────────────────┘    │
└─────────────────────────┘      └─────────────────────────┘
              │                               │
              └───────────────┬───────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
              ▼               ▼               ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│    MySQL 集群    │  │   Redis 集群     │  │  分布式文件存储  │
│   (主从复制)     │  │  (哨兵模式)      │  │   (OSS/NAS)    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

### 2.4 部署配置

#### 后端部署

```yaml
# application.yml 生产环境配置
server:
  port: 8080
  
spring:
  datasource:
    url: jdbc:mysql://mysql-host:3306/ruoyi?useUnicode=true&characterEncoding=utf8
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  redis:
    host: ${REDIS_HOST}
    port: 6379
    password: ${REDIS_PASSWORD}

# JWT 配置
ruoyi:
  jwt:
    secret: ${JWT_SECRET}
    expiration: 86400000  # 24 小时
```

#### 前端部署

```javascript
// vue.config.js 生产环境配置
module.exports = {
  publicPath: '/',
  outputDir: 'dist',
  productionSourceMap: false,
  devServer: {
    proxy: {
      '/prod-api': {
        target: 'http://backend-host:8080',
        changeOrigin: true,
        pathRewrite: {
          '^/prod-api': ''
        }
      }
    }
  }
}
```

### 2.5 Docker 部署

```dockerfile
# 后端 Dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY ruoyi-admin/target/ruoyi-admin.jar ./
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "ruoyi-admin.jar"]
```

```dockerfile
# 前端 Dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
```

```yaml
# docker-compose.yml
version: '3'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ruoyi
    volumes:
      - mysql-data:/var/lib/mysql
  
  redis:
    image: redis:alpine
    volumes:
      - redis-data:/data
  
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    depends_on:
      - mysql
      - redis
  
  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

volumes:
  mysql-data:
  redis-data:
```

---

## 三、数据库设计原则

### 3.1 命名规范

#### 表命名

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 系统表 | `sys_模块_功能` | `sys_user` |
| 业务表 | `biz_模块_功能` | `biz_order` |
| 关联表 | `rel_表 1_表 2` | `rel_user_role` |
| 日志表 | `log_功能` | `log_login` |
| 临时表 | `tmp_功能` | `tmp_import` |

#### 字段命名

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 主键 | `表名_id` | `user_id` |
| 外键 | `关联表名_id` | `dept_id` |
| 创建时间 | `create_time` | `create_time` |
| 更新时间 | `update_time` | `update_time` |
| 创建人 | `create_by` | `create_by` |
| 更新人 | `update_by` | `update_by` |
| 删除标志 | `del_flag` | `del_flag` |

### 3.2 字段类型规范

| 数据类型 | MySQL 类型 | 说明 |
|----------|------------|------|
| 主键 | BIGINT | 自增主键 |
| 状态 | TINYINT | 0/1 或枚举值 |
| 布尔 | TINYINT(1) | 0=false, 1=true |
| 短文本 | VARCHAR(255) | 名称、标题等 |
| 长文本 | TEXT | 描述、内容等 |
| 金额 | DECIMAL(10,2) | 精确小数 |
| 数量 | INT | 整数数量 |
| 时间 | DATETIME | 日期时间 |
| 大文本 | LONGTEXT | 超长文本 |

### 3.3 索引设计原则

1. **主键索引**
   - 每张表必须有主键
   - 推荐使用自增 BIGINT

2. **唯一索引**
   - 业务唯一字段（如用户名、手机号）
   - 避免重复数据

3. **普通索引**
   - 高频查询字段
   - 外键字段
   - 排序字段

4. **组合索引**
   - 遵循最左前缀原则
   - 高频组合查询字段

5. **索引禁忌**
   - 避免在低基数字段建索引
   - 避免在长文本字段建索引
   - 避免过多索引（单表不超过 5 个）

### 3.4 表设计规范

1. **必备字段**
   ```sql
   create_time DATETIME COMMENT '创建时间',
   update_time DATETIME COMMENT '更新时间',
   create_by VARCHAR(64) COMMENT '创建人',
   update_by VARCHAR(64) COMMENT '更新人',
   del_flag TINYINT(1) DEFAULT 0 COMMENT '删除标志'
   ```

2. **注释规范**
   - 表必须有注释
   - 字段必须有注释
   - 注释清晰准确

3. **范式规范**
   - 遵循第三范式
   - 适度反范式优化性能
   - 冗余数据需有同步机制

### 3.5 核心表结构

#### 用户表 (sys_user)

```sql
CREATE TABLE sys_user (
  user_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户 ID',
  dept_id BIGINT COMMENT '部门 ID',
  user_name VARCHAR(30) NOT NULL COMMENT '用户账号',
  nick_name VARCHAR(30) NOT NULL COMMENT '用户昵称',
  user_type VARCHAR(2) DEFAULT '00' COMMENT '用户类型',
  email VARCHAR(50) COMMENT '用户邮箱',
  phonenumber VARCHAR(11) COMMENT '手机号码',
  sex CHAR(1) DEFAULT '0' COMMENT '用户性别',
  avatar VARCHAR(100) COMMENT '头像地址',
  password VARCHAR(100) COMMENT '密码',
  status CHAR(1) DEFAULT '0' COMMENT '帐号状态',
  del_flag TINYINT(1) DEFAULT 0 COMMENT '删除标志',
  login_ip VARCHAR(128) COMMENT '最后登录 IP',
  login_date DATETIME COMMENT '最后登录时间',
  create_by VARCHAR(64) COMMENT '创建者',
  create_time DATETIME COMMENT '创建时间',
  update_by VARCHAR(64) COMMENT '更新者',
  update_time DATETIME COMMENT '更新时间',
  remark VARCHAR(500) COMMENT '备注',
  UNIQUE KEY uk_user_name (user_name),
  KEY idx_dept_id (dept_id),
  KEY idx_status (status),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';
```

#### 角色表 (sys_role)

```sql
CREATE TABLE sys_role (
  role_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色 ID',
  role_name VARCHAR(30) NOT NULL COMMENT '角色名称',
  role_key VARCHAR(100) NOT NULL COMMENT '角色权限字符串',
  role_sort INT NOT NULL COMMENT '显示顺序',
  data_scope CHAR(1) DEFAULT '1' COMMENT '数据范围',
  menu_check_strictly TINYINT(1) DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  dept_check_strictly TINYINT(1) DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  status CHAR(1) NOT NULL COMMENT '角色状态',
  del_flag TINYINT(1) DEFAULT 0 COMMENT '删除标志',
  create_by VARCHAR(64) COMMENT '创建者',
  create_time DATETIME COMMENT '创建时间',
  update_by VARCHAR(64) COMMENT '更新者',
  update_time DATETIME COMMENT '更新时间',
  remark VARCHAR(500) COMMENT '备注',
  UNIQUE KEY uk_role_key (role_key),
  KEY idx_status (status),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';
```

#### 菜单表 (sys_menu)

```sql
CREATE TABLE sys_menu (
  menu_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '菜单 ID',
  menu_name VARCHAR(50) NOT NULL COMMENT '菜单名称',
  parent_id BIGINT DEFAULT 0 COMMENT '父菜单 ID',
  order_num INT DEFAULT 0 COMMENT '显示顺序',
  path VARCHAR(200) DEFAULT '' COMMENT '路由地址',
  component VARCHAR(255) DEFAULT NULL COMMENT '组件路径',
  query VARCHAR(255) DEFAULT NULL COMMENT '路由参数',
  is_frame INT DEFAULT 1 COMMENT '是否为外链',
  is_cache INT DEFAULT 0 COMMENT '是否缓存',
  menu_type CHAR(1) DEFAULT '' COMMENT '菜单类型',
  visible CHAR(1) DEFAULT 0 COMMENT '菜单状态',
  status CHAR(1) DEFAULT 0 COMMENT '菜单状态',
  perms VARCHAR(100) DEFAULT NULL COMMENT '权限标识',
  icon VARCHAR(100) DEFAULT '#' COMMENT '菜单图标',
  create_by VARCHAR(64) COMMENT '创建者',
  create_time DATETIME COMMENT '创建时间',
  update_by VARCHAR(64) COMMENT '更新者',
  update_time DATETIME COMMENT '更新时间',
  remark VARCHAR(500) COMMENT '备注',
  KEY idx_parent_id (parent_id),
  KEY idx_status (status),
  KEY idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜单权限表';
```

---

## 四、接口设计规范

### 4.1 RESTful 规范

#### URL 设计规范

```
GET    /api/resource          # 获取资源列表
GET    /api/resource/{id}     # 获取单个资源
POST   /api/resource          # 创建资源
PUT    /api/resource/{id}     # 更新资源（全量）
PATCH  /api/resource/{id}     # 更新资源（部分）
DELETE /api/resource/{id}     # 删除资源
```

#### 实际示例

```
# 用户管理
GET    /system/user/list          # 获取用户列表
GET    /system/user/{userId}      # 获取用户详情
POST   /system/user               # 新增用户
PUT    /system/user               # 修改用户
DELETE /system/user/{userIds}     # 删除用户

# 角色管理
GET    /system/role/list          # 获取角色列表
POST   /system/role               # 新增角色
PUT    /system/role               # 修改角色
DELETE /system/role/{roleIds}     # 删除角色
```

### 4.2 请求规范

#### 请求头

```http
Content-Type: application/json
Authorization: Bearer {token}
X-Request-Id: {uuid}
```

#### 查询参数

```http
GET /system/user/list?pageNum=1&pageSize=10&userName=admin&status=0
```

#### 请求体

```json
{
  "userName": "admin",
  "nickName": "管理员",
  "password": "admin123",
  "email": "admin@ruoyi.com",
  "phonenumber": "13800138000",
  "sex": "0",
  "status": "0",
  "deptId": 100,
  "roleIds": [1]
}
```

### 4.3 响应规范

#### 统一响应格式

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

#### 响应码定义

| 响应码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权，需要登录 |
| 403 | 拒绝访问，权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

#### 分页响应格式

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [],
  "total": 100
}
```

#### 错误响应格式

```json
{
  "code": 500,
  "msg": "系统内部错误",
  "data": null
}
```

### 4.4 版本控制

#### URL 版本控制

```
/api/v1/users
/api/v2/users
```

#### 请求头版本控制

```http
Accept: application/vnd.ruoyi.v1+json
```

---

## 五、安全机制

### 5.1 认证机制 (JWT)

#### JWT 结构

```
Header.Payload.Signature
```

#### JWT 内容

```json
// Header
{
  "alg": "HS256",
  "typ": "JWT"
}

// Payload
{
  "sub": "admin",
  "userId": 1,
  "iat": 1678617600,
  "exp": 1678704000
}
```

#### Token 生成

```java
// 登录成功后生成 Token
String token = jwtUtil.createToken(loginUser);
```

#### Token 验证

```java
// 请求拦截器中验证 Token
JwtAuthenticationToken authentication = jwtUtil.validateToken(token);
SecurityContextHolder.getContext().setAuthentication(authentication);
```

#### Token 刷新

```java
// Token 过期前自动刷新
if (jwtUtil.isTokenExpiringSoon(token)) {
    String newToken = jwtUtil.refreshToken(token);
    response.setHeader("Authorization", "Bearer " + newToken);
}
```

### 5.2 授权机制 (Spring Security)

#### 安全配置

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 禁用 CSRF
            .csrf().disable()
            // 禁用 Session
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            // 配置请求授权
            .authorizeRequests()
            .antMatchers("/login", "/register", "/captchaImage").permitAll()
            .antMatchers("/tool/**", "/gen/**").hasAuthority("tool:gen:list")
            .anyRequest().authenticated()
            .and()
            // 添加 JWT 过滤器
            .addFilterBefore(jwtAuthenticationTokenFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

#### 方法级权限控制

```java
@RestController
@RequestMapping("/system/user")
public class SysUserController {
    
    @PreAuthorize("@ss.hasPermi('system:user:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user) {
        // 用户列表
    }
    
    @PreAuthorize("@ss.hasPermi('system:user:add')")
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysUser user) {
        // 新增用户
    }
}
```

### 5.3 数据权限

#### 数据范围注解

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface DataScope {
    String deptAlias() default "";
    String userAlias() default "";
}
```

#### 数据范围类型

```java
public enum DataScopeType {
    DATA_SCOPE_ALL("1", "全部数据权限"),
    DATA_SCOPE_CUSTOM("2", "自定数据权限"),
    DATA_SCOPE_DEPT("3", "本部门数据权限"),
    DATA_SCOPE_DEPT_AND_CHILD("4", "本部门及以下数据权限"),
    DATA_SCOPE_SELF("5", "仅本人数据权限");
}
```

#### 数据权限实现

```java
// Service 层使用
@DataScope(deptAlias = "d", userAlias = "u")
public List<SysUser> selectUserList(SysUser user);
```

```xml
<!-- Mapper XML -->
<select id="selectUserList" resultMap="SysUserResult">
    select u.user_id, u.user_name, d.dept_name
    from sys_user u
    left join sys_dept d on u.dept_id = d.dept_id
    where u.del_flag = '0'
    ${params.dataScope}  <!-- 数据权限过滤 -->
</select>
```

### 5.4 密码安全

#### 密码加密

```java
// BCrypt 加密
String encodedPassword = passwordEncoder.encode(rawPassword);

// 密码验证
boolean matches = passwordEncoder.matches(rawPassword, encodedPassword);
```

#### 密码策略

```java
// 密码复杂度校验
public void validatePassword(String password) {
    if (password.length() < 8) {
        throw new ServiceException("密码长度至少 8 位");
    }
    if (!password.matches(".*[A-Z].*")) {
        throw new ServiceException("密码必须包含大写字母");
    }
    if (!password.matches(".*[a-z].*")) {
        throw new ServiceException("密码必须包含小写字母");
    }
    if (!password.matches(".*\\d.*")) {
        throw new ServiceException("密码必须包含数字");
    }
}
```

### 5.5 XSS 防护

#### 输入过滤

```java
// XSS 过滤器
public class XssFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) {
        XssHttpServletRequestWrapper xssRequest = new XssHttpServletRequestWrapper((HttpServletRequest) request);
        chain.doFilter(xssRequest, response);
    }
}
```

#### 输出编码

```java
// HTML 编码
String safeOutput = EscapeUtil.escapeHtml(userInput);
```

### 5.6 SQL 注入防护

#### 参数化查询

```java
// ✅ 正确 - 使用 #{}
@Select("SELECT * FROM sys_user WHERE user_name = #{userName}")
SysUser selectByUserName(String userName);

// ❌ 错误 - 使用 ${}
@Select("SELECT * FROM sys_user WHERE user_name = '${userName}'")
SysUser selectByUserName(String userName);
```

---

## 六、性能优化方案

### 6.1 数据库优化

1. **索引优化**
   - 高频查询字段建立索引
   - 避免索引失效
   - 定期分析慢查询

2. **SQL 优化**
   - 避免 SELECT *
   - 避免 N+1 查询
   - 使用批量操作

3. **分页优化**
   - 深度分页使用子查询
   - 限制最大页数

### 6.2 缓存优化

1. **热点数据缓存**
   - 字典数据
   - 配置信息
   - 用户信息

2. **缓存策略**
   - 合理设置 TTL
   - 缓存预热
   - 缓存穿透防护

### 6.3 接口优化

1. **减少请求次数**
   - 接口合并
   - 批量查询

2. **减少响应数据**
   - 字段裁剪
   - 数据压缩

3. **异步处理**
   - 耗时操作异步
   - 消息队列

---

**文档版本：** 1.0  
**维护者：** 开发团队  
**最后更新：** 2026-03-12
