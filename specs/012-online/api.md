# 在线用户 API 接口 (012-online)

**模块编号：** 012  
**最后更新：** 2026-03-12

---

## 一、接口概述

### 1.1 基础信息

| 项目 | 说明 |
|------|------|
| 基础路径 | `/monitor/online` |
| 认证方式 | JWT Token |
| 数据格式 | JSON |
| 字符编码 | UTF-8 |

### 1.2 公共响应格式

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {}
}
```

### 1.3 列表响应格式

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [],
  "total": 100
}
```

---

## 二、接口详情

### 2.1 查询在线用户列表

**接口描述：** 查询当前所有在线用户列表，支持条件筛选

**请求定义：**
```
GET /monitor/online/list
```

**权限标识：** `monitor:online:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| ipaddr | String | 否 | 登录地址（模糊） | 192.168.1 |
| userName | String | 否 | 用户名称（模糊） | admin |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码（200 成功） |
| msg | String | 提示信息 |
| rows | Array | 在线用户列表 |
| rows[].tokenId | String | 会话编号 |
| rows[].userName | String | 用户名称 |
| rows[].deptName | String | 部门名称 |
| rows[].ipaddr | String | 登录 IP |
| rows[].loginLocation | String | 登录地点 |
| rows[].browser | String | 浏览器 |
| rows[].os | String | 操作系统 |
| rows[].loginTime | Long | 登录时间戳 |
| total | Integer | 总记录数 |

**请求示例：**
```bash
GET /monitor/online/list?ipaddr=192.168
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "tokenId": "eyJhbGciOiJIUzUxMiJ9...",
      "userName": "admin",
      "deptName": "研发部门",
      "ipaddr": "192.168.1.100",
      "loginLocation": "XX 省 XX 市",
      "browser": "Chrome",
      "os": "Windows 10",
      "loginTime": 1710234567000
    }
  ],
  "total": 10
}
```

**实现逻辑：**
1. 从 Redis 获取所有 `login_tokens:*` 的 key
2. 遍历 key 获取 LoginUser 对象
3. 根据条件筛选（ipaddr/userName）
4. 转换为 SysUserOnline 对象
5. 返回分页列表

---

### 2.2 强制退出用户

**接口描述：** 强制退出指定的在线用户

**请求定义：**
```
DELETE /monitor/online/{tokenId}
```

**权限标识：** `monitor:online:forceLogout`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| tokenId | String | 是 | 会话编号（路径参数） | eyJhbGciOiJIUzUxMiJ9... |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
DELETE /monitor/online/eyJhbGciOiJIUzUxMiJ9...
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**实现逻辑：**
1. 删除 Redis 中的 Token：`login_tokens:{tokenId}`
2. 用户后续请求因 Token 失效被拦截
3. 前端收到 401 后跳转登录页

---

## 三、错误码说明

### 3.1 通用错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 200 | 成功 | - |
| 401 | 未授权 | 检查 Token 是否有效 |
| 403 | 无权限 | 检查用户权限配置 |
| 500 | 服务器错误 | 联系管理员 |

### 3.2 业务错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 500 | 用户已离线 | Token 已不存在，无需操作 |

---

## 四、前端 API 封装

### 4.1 API 文件路径

`ruoyi-ui/src/api/monitor/online.js`

### 4.2 封装方法

```javascript
import request from '@/utils/request'

// 查询在线用户列表
export function list(query) {
  return request({
    url: '/monitor/online/list',
    method: 'get',
    params: query
  })
}

// 强退用户
export function forceLogout(tokenId) {
  return request({
    url: '/monitor/online/' + tokenId,
    method: 'delete'
  })
}
```

### 4.3 使用示例

```javascript
import { list, forceLogout } from "@/api/monitor/online"

// 查询列表
list({ ipaddr: '192.168' }).then(response => {
  this.list = response.rows
  this.total = response.total
})

// 强退用户
forceLogout(row.tokenId).then(() => {
  this.$modal.msgSuccess("强退成功")
  this.getList()
})
```

---

## 五、安全说明

### 5.1 认证要求
- 所有接口必须携带有效的 JWT Token
- Token 过期需重新登录

### 5.2 权限控制
- 所有接口均需通过 `@PreAuthorize` 权限校验
- 前端按钮根据权限动态显示

### 5.3 会话安全
- 强制退出操作需二次确认
- 不能强制退出自己（建议）
- 管理员可强制退出任意用户

---

## 六、性能优化

### 6.1 查询优化
- Redis keys 操作可能较慢，大数据量时注意性能
- 支持按条件筛选减少数据传输
- 前端分页展示，避免一次性加载过多数据

### 6.2 缓存优化
- Token 自动续期，减少重复登录
- 合理设置 Token 过期时间
- 定期清理过期 Token

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
