# 018-系统接口 - 数据模型

**模块编号：** 018  
**模块名称：** 系统接口 (System API / Swagger)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、数据模型概述

系统接口模块（Swagger）本身**不存储业务数据**，它是一个 API 文档展示和测试工具。该模块通过扫描系统中的 Controller 和模型类，动态生成 API 文档和数据模型展示。

### 1.1 数据模型来源

| 来源类型 | 说明 | 示例 |
|---------|------|------|
| Controller 注解 | 从 `@Tag`、`@Operation` 等注解提取接口信息 | `@Tag(name = "用户管理")` |
| 模型类注解 | 从 `@Schema` 注解提取字段信息 | `@Schema(description = "用户 ID")` |
| 请求/响应类 | 自动扫描所有请求和响应模型 | `SysUser`、`TableDataInfo` |
| 配置类 | Swagger 配置信息 | `SwaggerConfig` |

---

## 二、核心数据模型

### 2.1 OpenAPI 配置模型

**类名：** `OpenAPI` (io.swagger.v3.oas.models.OpenAPI)

**说明：** Swagger 配置的核心模型，由 `SwaggerConfig` 类创建

| 属性 | 类型 | 说明 |
|------|------|------|
| info | Info | API 基本信息（标题、描述、版本） |
| components | Components | 组件定义（安全方案等） |
| security | List<SecurityRequirement> | 安全要求列表 |
| paths | Paths | 接口路径定义（自动扫描） |

**配置方式：**
```java
@Bean
public OpenAPI customOpenApi() {
    return new OpenAPI()
        .components(new Components()
            .addSecuritySchemes("apikey", securityScheme()))
        .addSecurityItem(new SecurityRequirement().addList("apikey"))
        .info(getApiInfo());
}
```

### 2.2 安全方案模型

**类名：** `SecurityScheme` (io.swagger.v3.oas.models.security.SecurityScheme)

**说明：** 定义 API 的认证方式

| 属性 | 类型 | 值 | 说明 |
|------|------|-----|------|
| type | Type | APIKEY | 认证类型 |
| name | String | Authorization | 请求头名称 |
| in | In | HEADER | 参数位置 |
| scheme | String | Bearer | 认证方案 |

**配置代码：**
```java
@Bean
public SecurityScheme securityScheme() {
    return new SecurityScheme()
        .type(SecurityScheme.Type.APIKEY)
        .name("Authorization")
        .in(SecurityScheme.In.HEADER)
        .scheme("Bearer");
}
```

### 2.3 API 信息模型

**类名：** `Info` (io.swagger.v3.oas.models.info.Info)

**说明：** API 文档的基本信息

| 属性 | 类型 | 说明 | 示例值 |
|------|------|------|--------|
| title | String | API 标题 | "若依管理系统_接口文档" |
| description | String | API 描述 | "用于管理集团旗下公司的人员信息..." |
| contact | Contact | 联系信息 | 作者名称 |
| version | String | API 版本 | "版本号:3.9.1" |

---

## 三、注解模型

### 3.1 Controller 注解

**@Tag 注解**

| 属性 | 类型 | 说明 | 示例 |
|------|------|------|------|
| name | String | 分组名称 | "用户管理" |
| description | String | 分组描述 | "用户 CRUD 操作" |

**示例：**
```java
@RestController
@RequestMapping("/system/user")
@Tag(name = "用户管理", description = "用户 CRUD 操作")
public class SysUserController {
    // ...
}
```

### 3.2 接口注解

**@Operation 注解**

| 属性 | 类型 | 说明 | 示例 |
|------|------|------|------|
| summary | String | 接口摘要 | "获取用户列表" |
| description | String | 详细描述 | "分页查询用户信息" |

**@ApiResponses 注解**

| 属性 | 类型 | 说明 |
|------|------|------|
| value | ApiResponse[] | 响应码列表 |

**@ApiResponse 注解**

| 属性 | 类型 | 说明 | 示例 |
|------|------|------|------|
| responseCode | String | HTTP 状态码 | "200" |
| description | String | 响应描述 | "成功" |

**示例：**
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

### 3.3 参数注解

**@Parameter 注解**

| 属性 | 类型 | 说明 | 示例 |
|------|------|------|------|
| description | String | 参数描述 | "用户 ID" |
| required | boolean | 是否必填 | true |
| example | String | 示例值 | "1" |

**示例：**
```java
@Parameter(description = "用户 ID", required = true)
@PathVariable Long userId

@Parameter(description = "用户账号")
@RequestParam String userName

@Parameter(description = "用户信息")
@RequestBody SysUser user
```

### 3.4 模型注解

**@Schema 注解**

| 属性 | 类型 | 说明 | 示例 |
|------|------|------|------|
| description | String | 模型描述 | "用户信息" |
| example | String | 示例值 | "admin" |
| required | boolean | 是否必填 | true |
| readOnly | boolean | 只读 | false |

**示例：**
```java
@Schema(description = "用户信息")
public class SysUser {
    @Schema(description = "用户 ID", example = "1")
    private Long userId;
    
    @Schema(description = "用户账号", example = "admin")
    private String userName;
    
    @Schema(description = "用户昵称")
    private String nickName;
    
    // ...
}
```

---

## 四、通用响应模型

### 4.1 统一响应结构

**类名：** `AjaxResult`

**说明：** 所有 API 接口的统一响应格式

| 字段名 | 类型 | 说明 |
|-------|------|------|
| code | Integer | 状态码（200 成功） |
| msg | String | 响应消息 |
| data | Object | 响应数据 |

### 4.2 表格响应结构

**类名：** `TableDataInfo`

**说明：** 分页列表接口响应格式

| 字段名 | 类型 | 说明 |
|-------|------|------|
| code | Integer | 状态码 |
| msg | String | 响应消息 |
| rows | List<?> | 数据列表 |
| total | Long | 总记录数 |

### 4.3 单条记录响应

**类名：** `AjaxResult`

**说明：** 单条数据操作响应

| 字段名 | 类型 | 说明 |
|-------|------|------|
| code | Integer | 状态码 |
| msg | String | 响应消息 |
| data | Object | 返回数据 |

---

## 五、数据模型扫描规则

### 5.1 自动扫描范围

| 扫描目标 | 说明 |
|---------|------|
| @RestController | 所有 REST 控制器 |
| @RequestMapping 路径 | 接口路径前缀 |
| 请求参数类 | @RequestBody、@RequestParam |
| 响应返回类 | Controller 方法返回值 |
| 实体类 | 被请求/响应类引用的所有类 |

### 5.2 模型引用关系

```
Controller
    ├── @Tag (分组信息)
    ├── @Operation (接口信息)
    │   ├── @Parameter (请求参数)
    │   │   └── 参数类型 (Schema)
    │   └── @ApiResponse (响应信息)
    │       └── 响应类型 (Schema)
    └── 方法返回值
        └── 返回类型 (Schema)
```

---

## 六、配置数据模型

### 6.1 应用配置

**配置文件：** `application.yml`

```yaml
springdoc:
  api-docs:
    enabled: true  # 启用 API 文档
    path: /v3/api-docs  # API 文档 JSON 路径
  swagger-ui:
    enabled: true  # 启用 Swagger UI
    path: /swagger-ui/index.html  # Swagger UI 访问路径
    operations-sorter: alpha  # 接口排序方式
    tags-sorter: alpha  # 分组排序方式
```

### 6.2 配置属性说明

| 配置项 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| springdoc.api-docs.enabled | boolean | true | 是否启用 API 文档 |
| springdoc.api-docs.path | String | /v3/api-docs | API 文档 JSON 路径 |
| springdoc.swagger-ui.enabled | boolean | true | 是否启用 Swagger UI |
| springdoc.swagger-ui.path | String | /swagger-ui/index.html | Swagger UI 访问路径 |
| springdoc.swagger-ui.operations-sorter | String | alpha | 接口排序（alpha/method） |
| springdoc.swagger-ui.tags-sorter | String | alpha | 分组排序（alpha） |

---

## 七、无持久化数据

**重要说明：**

系统接口模块**不存储任何业务数据**，所有展示的信息均来自：

1. **代码注解**：Controller 和模型类上的 Swagger 注解
2. **运行时扫描**：Spring 启动时自动扫描并注册
3. **配置文件**：application.yml 中的配置项

因此，该模块**没有数据库表**，所有数据都是动态生成的。
