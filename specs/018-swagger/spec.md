# 018-系统接口 - 功能规格

**模块编号：** 018  
**模块名称：** 系统接口 (System API / Swagger)  
**所属模块：** 系统工具  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、功能概述

系统接口模块集成了 Swagger UI（OpenAPI 3.0），用于展示和管理系统的所有 REST API 接口文档。该模块为开发人员提供在线的 API 文档浏览、接口测试功能，支持 JWT 认证，方便前后端开发人员协作和接口调试。

### 1.1 核心功能

- **API 文档展示**：自动扫描并展示所有 Controller 接口
- **接口分组**：按 Controller 分组展示接口
- **在线测试**：支持在线调用 API 接口进行测试
- **JWT 认证**：集成 JWT Token 认证机制
- **参数说明**：显示接口参数、请求体、响应示例
- **模型展示**：展示数据模型（Schema）定义

### 1.2 技术栈

| 组件 | 版本 | 说明 |
|------|------|------|
| SpringDoc OpenAPI | 2.x | OpenAPI 3.0 实现 |
| Swagger UI | 5.x | API 文档界面 |
| JWT | - | 身份认证 |

### 1.3 业务规则

1. **环境限制**：生产环境默认禁用 Swagger
2. **认证要求**：所有接口需要 JWT Token 认证
3. **接口扫描**：自动扫描所有@RestController 注解的类
4. **分组规则**：按 Controller 的@RequestMapping 路径分组
5. **权限控制**：不影响原有接口的权限控制

---

## 二、功能详细设计

### 2.1 API 文档展示

**功能描述：** 展示系统所有 REST API 接口文档

**展示内容：**
- 接口分组（按模块）
- 接口路径和方法
- 接口描述
- 请求参数
- 响应模型

**分组规则：**
- 按 Controller 的 `@RequestMapping` 路径前缀分组
- 常见分组：system（系统管理）、tool（系统工具）、monitor（系统监控）等

### 2.2 接口测试

**功能描述：** 在线调用 API 接口进行测试

**支持操作：**
- 填写请求参数
- 设置请求体（JSON）
- 添加请求头（包括 JWT Token）
- 发送请求并查看响应

**认证方式：**
- 点击"Authorize"按钮
- 输入 JWT Token（格式：Bearer {token}）
- 或直接在 Authorization 头中添加

### 2.3 数据模型展示

**功能描述：** 展示接口使用的数据模型（Schema）

**展示内容：**
- 请求体模型（Request Body）
- 响应模型（Response）
- 模型属性及类型
- 模型间引用关系

### 2.4 接口分组

**分组列表：**

| 分组名称 | 路径前缀 | 说明 |
|---------|---------|------|
| 系统管理 | /system | 用户、部门、岗位、菜单、角色等 |
| 系统工具 | /tool | 代码生成、数据构建等 |
| 系统监控 | /monitor | 缓存、服务器、任务等 |
| 认证接口 | - | 登录、注册等 |

---

## 三、配置说明

### 3.1 Swagger 配置

**配置类：** `SwaggerConfig.java`

**配置内容：**
```java
@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI customOpenApi() {
        return new OpenAPI()
            .components(new Components()
                .addSecuritySchemes("apikey", securityScheme()))
            .addSecurityItem(new SecurityRequirement().addList("apikey"))
            .info(getApiInfo());
    }
    
    @Bean
    public SecurityScheme securityScheme() {
        return new SecurityScheme()
            .type(SecurityScheme.Type.APIKEY)
            .name("Authorization")
            .in(SecurityScheme.In.HEADER)
            .scheme("Bearer");
    }
}
```

### 3.2 应用配置

**配置文件：** `application.yml`

```yaml
springdoc:
  api-docs:
    enabled: true  # 启用 API 文档
  swagger-ui:
    enabled: true  # 启用 Swagger UI
    path: /swagger-ui.html  # Swagger UI 访问路径
```

### 3.3 环境配置

| 环境 | Swagger 状态 | 说明 |
|------|------------|------|
| 开发环境 | 启用 | 方便开发调试 |
| 测试环境 | 启用 | 方便接口测试 |
| 生产环境 | 禁用 | 安全性考虑 |

---

## 四、注解说明

### 4.1 Controller 注解

```java
@RestController
@RequestMapping("/system/user")
@Tag(name = "用户管理", description = "用户 CRUD 操作")
public class SysUserController {
    // ...
}
```

### 4.2 接口注解

```java
@Operation(summary = "获取用户列表", description = "分页查询用户信息")
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "成功"),
    @ApiResponse(responseCode = "401", description = "未授权"),
    @ApiResponse(responseCode = "500", description = "服务器错误")
})
@GetMapping("/list")
public TableDataInfo list(SysUser user) {
    // ...
}
```

### 4.3 参数注解

```java
@Parameter(description = "用户 ID", required = true)
@PathVariable Long userId

@Parameter(description = "用户账号")
@RequestParam String userName

@Parameter(description = "用户信息")
@RequestBody SysUser user
```

### 4.4 模型注解

```java
@Schema(description = "用户信息")
public class SysUser {
    @Schema(description = "用户 ID", example = "1")
    private Long userId;
    
    @Schema(description = "用户账号", example = "admin")
    private String userName;
    
    // ...
}
```

---

## 五、安全说明

### 5.1 JWT 认证

**认证头格式：**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**获取 Token：**
1. 通过登录接口获取 Token
2. 在 Swagger UI 中点击"Authorize"
3. 输入 `Bearer {token}`

### 5.2 生产环境安全

**禁用 Swagger：**
```yaml
# 生产环境配置
spring:
  profiles: prod
  
springdoc:
  api-docs:
    enabled: false
  swagger-ui:
    enabled: false
```

**注意事项：**
1. 生产环境必须禁用 Swagger
2. 避免暴露接口信息
3. 防止接口被恶意利用

---

## 六、使用场景

### 6.1 开发阶段

- 查看接口定义和参数
- 快速测试接口功能
- 调试接口问题

### 6.2 联调阶段

- 前端开发人员查看接口文档
- 测试接口响应格式
- 验证数据模型

### 6.3 维护阶段

- 查看系统接口全貌
- 分析接口依赖关系
- 文档归档

---

## 七、访问方式

### 7.1 访问地址

| 环境 | 地址 | 说明 |
|------|------|------|
| 本地开发 | http://localhost:8080/swagger-ui/index.html | 默认端口 8080 |
| 测试环境 | http://test-server/swagger-ui/index.html | 根据实际配置 |

### 7.2 前端入口

**菜单路径：** 系统工具 > 系统接口

**前端页面：** `ruoyi-ui/src/views/tool/swagger/index.vue`

**访问方式：** 通过 iframe 嵌入 Swagger UI
