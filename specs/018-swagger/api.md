# 018-系统接口 - API 接口

**模块编号：** 018  
**模块名称：** 系统接口 (System API / Swagger)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**模块说明：** 系统接口模块（Swagger）本身**不提供业务 API 接口**，它是一个 API 文档展示和测试工具，用于展示系统中所有其他模块的 API 接口。

### 1.1 访问地址

| 环境 | 地址 | 说明 |
|------|------|------|
| 本地开发 | http://localhost:8080/swagger-ui/index.html | 默认端口 8080 |
| API 文档 JSON | http://localhost:8080/v3/api-docs | OpenAPI 3.0 JSON 格式 |

### 1.2 认证方式

**JWT Token 认证**

| 参数名 | 位置 | 格式 | 说明 |
|-------|------|------|------|
| Authorization | Header | Bearer {token} | JWT 令牌 |

**获取 Token：**
1. 调用登录接口 `/login` 获取 token
2. 在 Swagger UI 中点击"Authorize"按钮
3. 输入 `Bearer {token}`

---

## 二、Swagger 内置接口

### 2.1 API 文档 JSON 接口

**接口：** `GET /v3/api-docs`

**说明：** 获取 OpenAPI 3.0 格式的 API 文档 JSON

**请求参数：** 无

**响应格式：** OpenAPI 3.0 JSON

**响应示例（简化）：**
```json
{
  "openapi": "3.0.1",
  "info": {
    "title": "标题：若依管理系统_接口文档",
    "description": "描述：用于管理集团旗下公司的人员信息...",
    "contact": {
      "name": "ruoyi"
    },
    "version": "版本号:3.9.1"
  },
  "components": {
    "securitySchemes": {
      "apikey": {
        "type": "apiKey",
        "name": "Authorization",
        "in": "header",
        "scheme": "Bearer"
      }
    }
  },
  "security": [
    {
      "apikey": []
    }
  ],
  "paths": {
    "/system/user/list": {
      "get": {
        "tags": ["用户管理"],
        "summary": "获取用户列表",
        "description": "分页查询用户信息",
        "parameters": [...],
        "responses": {
          "200": {
            "description": "成功",
            "content": {...}
          }
        }
      }
    }
  }
}
```

### 2.2 Swagger UI 静态资源接口

**接口：** `GET /swagger-ui/**`

**说明：** 获取 Swagger UI 的静态资源文件（HTML、CSS、JS）

**资源列表：**
- `/swagger-ui/index.html` - 主页面
- `/swagger-ui/swagger-ui.css` - 样式文件
- `/swagger-ui/swagger-ui-bundle.js` - JS 库
- `/swagger-ui/swagger-initializer.js` - 初始化脚本

---

## 三、系统 API 接口分组

Swagger 将系统所有 API 接口按模块分组展示：

### 3.1 系统管理接口 (/system)

| 模块 | 路径前缀 | 说明 |
|------|---------|------|
| 用户管理 | /system/user | 用户 CRUD、角色分配、密码重置 |
| 角色管理 | /system/role | 角色 CRUD、权限分配 |
| 菜单管理 | /system/menu | 菜单树、权限配置 |
| 部门管理 | /system/dept | 部门树、层级管理 |
| 岗位管理 | /system/post | 岗位 CRUD |
| 字典管理 | /system/dict | 字典类型/数据管理 |
| 配置管理 | /system/config | 系统参数配置 |
| 通知公告 | /system/notice | 公告 CRUD |

### 3.2 系统监控接口 (/monitor)

| 模块 | 路径前缀 | 说明 |
|------|---------|------|
| 在线用户 | /monitor/online | 在线用户列表、强退 |
| 定时任务 | /monitor/job | 任务 CRUD、执行 |
| 数据监控 | /monitor/druid | Druid 监控面板 |
| 服务监控 | /monitor/server | 服务器信息 |
| 缓存监控 | /monitor/cache | 缓存信息、监控 |
| 缓存操作 | /cache | 缓存键操作 |
| 连接池 | /monitor/pool | 连接池监控 |

### 3.3 系统工具接口 (/tool)

| 模块 | 路径前缀 | 说明 |
|------|---------|------|
| 代码生成 | /tool/gen | 代码生成、预览、下载 |
| 表单构建 | - | 前端表单设计器（无后端接口） |
| 系统接口 | - | Swagger UI 展示（本模块） |

### 3.4 认证接口

| 接口 | 路径 | 说明 |
|------|------|------|
| 登录 | /login | 用户登录，返回 token |
| 注册 | /register | 用户注册 |
| 验证码 | /captchaImage | 获取验证码 |
| 登出 | /logout | 用户登出 |

---

## 四、通用接口响应格式

### 4.1 成功响应

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

### 4.2 错误响应

```json
{
  "code": 400,
  "msg": "错误信息",
  "data": null
}
```

### 4.3 分页响应

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [],
  "total": 100
}
```

### 4.4 未授权响应

```json
{
  "code": 401,
  "msg": "登录状态已过期，请重新登录",
  "data": null
}
```

---

## 五、接口测试说明

### 5.1 在 Swagger UI 中测试接口

**步骤：**

1. **访问 Swagger UI**
   - 打开 http://localhost:8080/swagger-ui/index.html

2. **授权认证**
   - 点击右上角"Authorize"按钮
   - 输入 `Bearer {token}`（token 通过登录接口获取）
   - 点击"Authorize"确认

3. **选择接口**
   - 展开对应的模块分组
   - 点击要测试的接口

4. **填写参数**
   - 填写请求参数（Query/Path/Header）
   - 填写请求体（Request Body，如果是 POST/PUT）

5. **执行请求**
   - 点击"Execute"按钮
   - 查看响应结果

### 5.2 常见问题

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 401 未授权 | 未登录或 token 过期 | 重新登录获取 token |
| 403 禁止访问 | 无权限 | 分配对应权限 |
| 404 未找到 | 接口路径错误 | 检查接口路径 |
| 500 服务器错误 | 服务端异常 | 查看服务器日志 |

---

## 六、接口文档导出

### 6.1 导出 OpenAPI JSON

**方式一：直接访问**
```
GET http://localhost:8080/v3/api-docs
```

**方式二：使用 curl**
```bash
curl http://localhost:8080/v3/api-docs -o openapi.json
```

### 6.2 导出为其他格式

使用 swagger-cli 等工具可以转换为其他格式：
```bash
# 转换为 YAML
swagger-cli bundle openapi.json -o openapi.yaml

# 转换为 PDF（需要额外工具）
```

---

## 七、接口注解规范

### 7.1 Controller 注解规范

```java
@RestController
@RequestMapping("/system/user")
@Tag(name = "用户管理", description = "用户 CRUD 操作")
public class SysUserController {
    // ...
}
```

### 7.2 接口方法注解规范

```java
@Operation(summary = "获取用户列表", description = "分页查询用户信息")
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "成功", 
                 content = @Content(schema = @Schema(implementation = TableDataInfo.class))),
    @ApiResponse(responseCode = "401", description = "未授权"),
    @ApiResponse(responseCode = "500", description = "服务器错误")
})
@GetMapping("/list")
public TableDataInfo list(SysUser user) {
    // ...
}
```

### 7.3 参数注解规范

```java
@Operation(summary = "获取用户详情")
@GetMapping("/{userId}")
public AjaxResult getInfo(
    @Parameter(description = "用户 ID", required = true)
    @PathVariable Long userId
) {
    // ...
}
```

---

## 八、安全说明

### 8.1 生产环境禁用

**配置方式：**
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

### 8.2 安全风险

| 风险 | 说明 | 防范措施 |
|------|------|---------|
| 接口暴露 | 暴露所有 API 信息 | 生产环境禁用 |
| 接口测试 | 可能被恶意利用 | 权限控制 + 禁用 |
| 数据泄露 | 敏感接口被调用 | 严格的权限验证 |

### 8.3 最佳实践

1. **开发/测试环境**：启用 Swagger，方便调试
2. **生产环境**：必须禁用 Swagger
3. **权限控制**：所有接口必须有权限验证
4. **敏感接口**：额外增加安全验证
