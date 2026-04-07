# 登录日志 API 接口 (011-login-log)

**模块编号：** 011  
**最后更新：** 2026-03-12

---

## 一、接口概述

### 1.1 基础信息

| 项目 | 说明 |
|------|------|
| 基础路径 | `/monitor/logininfor` |
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

### 2.1 查询登录日志列表

**接口描述：** 分页查询登录日志列表，支持多条件筛选

**请求定义：**
```
GET /monitor/logininfor/list
```

**权限标识：** `monitor:logininfor:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| pageNum | Integer | 否 | 页码，默认 1 | 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 | 10 |
| ipaddr | String | 否 | 登录地址（模糊） | 192.168.1 |
| userName | String | 否 | 用户名称（模糊） | admin |
| status | String | 否 | 登录状态 | 0 |
| beginTime | String | 否 | 开始时间 | 2026-01-01 00:00:00 |
| endTime | String | 否 | 结束时间 | 2026-12-31 23:59:59 |
| orderByColumn | String | 否 | 排序字段 | loginTime |
| isAsc | String | 否 | 排序方式 | descending |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码（200 成功） |
| msg | String | 提示信息 |
| rows | Array | 日志列表 |
| rows[].infoId | Long | 访问编号 |
| rows[].userName | String | 用户名称 |
| rows[].status | String | 登录状态 |
| rows[].ipaddr | String | 登录地址 |
| rows[].loginLocation | String | 登录地点 |
| rows[].browser | String | 浏览器 |
| rows[].os | String | 操作系统 |
| rows[].msg | String | 提示消息 |
| rows[].loginTime | DateTime | 登录时间 |
| total | Integer | 总记录数 |

**请求示例：**
```bash
GET /monitor/logininfor/list?pageNum=1&pageSize=10&status=0
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "infoId": 1001,
      "userName": "admin",
      "status": "0",
      "ipaddr": "192.168.1.100",
      "loginLocation": "XX 省 XX 市",
      "browser": "Chrome",
      "os": "Windows 10",
      "msg": "登录成功",
      "loginTime": "2026-03-12 10:30:00"
    }
  ],
  "total": 100
}
```

---

### 2.2 删除登录日志

**接口描述：** 批量删除登录日志

**请求定义：**
```
DELETE /monitor/logininfor/{infoIds}
```

**权限标识：** `monitor:logininfor:remove`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| infoIds | Long[] | 是 | 访问 ID 数组（路径参数） | 1001,1002,1003 |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
DELETE /monitor/logininfor/1001,1002,1003
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 2.3 清空登录日志

**接口描述：** 清空所有登录日志数据（TRUNCATE）

**请求定义：**
```
DELETE /monitor/logininfor/clean
```

**权限标识：** `monitor:logininfor:remove`

**请求参数：** 无

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
DELETE /monitor/logininfor/clean
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 2.4 导出登录日志

**接口描述：** 导出登录日志为 Excel 文件

**请求定义：**
```
POST /monitor/logininfor/export
```

**权限标识：** `monitor:logininfor:export`

**请求参数：** 同查询列表参数（通过 Query String 传递）

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| ipaddr | String | 否 | 登录地址 |
| userName | String | 否 | 用户名称 |
| status | String | 否 | 登录状态 |
| beginTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |

**响应格式：** Excel 文件下载

**文件名格式：** `logininfor_{timestamp}.xlsx`

**请求示例：**
```bash
POST /monitor/logininfor/export?status=0
Authorization: Bearer {token}
Accept: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
```

---

### 2.5 解锁用户

**接口描述：** 解锁被锁定的用户账户

**请求定义：**
```
GET /monitor/logininfor/unlock/{userName}
```

**权限标识：** `monitor:logininfor:unlock`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| userName | String | 是 | 用户账号（路径参数） | admin |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
GET /monitor/logininfor/unlock/admin
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

## 三、错误码说明

### 3.1 通用错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 200 | 成功 | - |
| 401 | 未授权 | 检查 Token 是否有效 |
| 403 | 无权限 | 检查用户权限配置 |
| 500 | 服务器错误 | 联系管理员 |

---

## 四、前端 API 封装

### 4.1 API 文件路径

`ruoyi-ui/src/api/monitor/logininfor.js`

### 4.2 封装方法

```javascript
import request from '@/utils/request'

// 查询登录日志列表
export function list(query) {
  return request({
    url: '/monitor/logininfor/list',
    method: 'get',
    params: query
  })
}

// 删除登录日志
export function delLogininfor(infoId) {
  return request({
    url: '/monitor/logininfor/' + infoId,
    method: 'delete'
  })
}

// 解锁用户登录状态
export function unlockLogininfor(userName) {
  return request({
    url: '/monitor/logininfor/unlock/' + userName,
    method: 'get'
  })
}

// 清空登录日志
export function cleanLogininfor() {
  return request({
    url: '/monitor/logininfor/clean',
    method: 'delete'
  })
}
```

---

## 五、安全说明

### 5.1 认证要求
- 所有接口必须携带有效的 JWT Token
- Token 过期需重新登录

### 5.2 权限控制
- 所有接口均需通过 `@PreAuthorize` 权限校验
- 前端按钮根据权限动态显示

### 5.3 数据安全
- 清空操作需二次确认
- 批量删除需二次确认
- 解锁操作需二次确认

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
