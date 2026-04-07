# 操作日志 API 接口 (010-oper-log)

**模块编号：** 010  
**最后更新：** 2026-03-12

---

## 一、接口概述

### 1.1 基础信息

| 项目 | 说明 |
|------|------|
| 基础路径 | `/monitor/operlog` |
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

### 2.1 查询操作日志列表

**接口描述：** 分页查询操作日志列表，支持多条件筛选

**请求定义：**
```
GET /monitor/operlog/list
```

**权限标识：** `monitor:operlog:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| pageNum | Integer | 否 | 页码，默认 1 | 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 | 10 |
| operIp | String | 否 | 操作地址（模糊） | 192.168.1 |
| title | String | 否 | 系统模块（模糊） | 用户管理 |
| operName | String | 否 | 操作人员（模糊） | 张三 |
| businessType | Integer | 否 | 业务类型 | 1 |
| status | Integer | 否 | 操作状态 | 0 |
| beginTime | String | 否 | 开始时间 | 2026-01-01 00:00:00 |
| endTime | String | 否 | 结束时间 | 2026-12-31 23:59:59 |
| orderByColumn | String | 否 | 排序字段 | operTime |
| isAsc | String | 否 | 排序方式 | descending |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码（200 成功） |
| msg | String | 提示信息 |
| rows | Array | 日志列表 |
| rows[].operId | Long | 日志编号 |
| rows[].title | String | 操作模块 |
| rows[].businessType | Integer | 业务类型 |
| rows[].operName | String | 操作人员 |
| rows[].operIp | String | 操作地址 |
| rows[].operLocation | String | 操作地点 |
| rows[].status | Integer | 操作状态 |
| rows[].operTime | DateTime | 操作时间 |
| rows[].costTime | Long | 消耗时间（毫秒） |
| total | Integer | 总记录数 |

**请求示例：**
```bash
GET /monitor/operlog/list?pageNum=1&pageSize=10&businessType=1&status=0
Authorization: Bearer {token}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "operId": 1001,
      "title": "用户管理",
      "businessType": 1,
      "operName": "张三",
      "operIp": "192.168.1.100",
      "operLocation": "XX 省 XX 市",
      "status": 0,
      "operTime": "2026-03-12 10:30:00",
      "costTime": 150
    }
  ],
  "total": 100
}
```

---

### 2.2 删除操作日志

**接口描述：** 批量删除操作日志

**请求定义：**
```
DELETE /monitor/operlog/{operIds}
```

**权限标识：** `monitor:operlog:remove`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| operIds | Long[] | 是 | 日志 ID 数组（路径参数） | 1001,1002,1003 |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
DELETE /monitor/operlog/1001,1002,1003
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

### 2.3 清空操作日志

**接口描述：** 清空所有操作日志数据（TRUNCATE）

**请求定义：**
```
DELETE /monitor/operlog/clean
```

**权限标识：** `monitor:operlog:remove`

**请求参数：** 无

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

**请求示例：**
```bash
DELETE /monitor/operlog/clean
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

### 2.4 导出操作日志

**接口描述：** 导出操作日志为 Excel 文件

**请求定义：**
```
POST /monitor/operlog/export
```

**权限标识：** `monitor:operlog:export`

**请求参数：** 同查询列表参数（通过 Query String 传递）

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| operIp | String | 否 | 操作地址 |
| title | String | 否 | 系统模块 |
| operName | String | 否 | 操作人员 |
| businessType | Integer | 否 | 业务类型 |
| status | Integer | 否 | 操作状态 |
| beginTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |

**响应格式：** Excel 文件下载

**文件名格式：** `operlog_{timestamp}.xlsx`

**请求示例：**
```bash
POST /monitor/operlog/export?businessType=1&status=0
Authorization: Bearer {token}
Accept: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
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

### 3.2 业务错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 500 | 删除失败 | 检查日志 ID 是否存在 |
| 500 | 导出失败 | 检查数据是否为空 |

---

## 四、前端 API 封装

### 4.1 API 文件路径

`ruoyi-ui/src/api/monitor/operlog.js`

### 4.2 封装方法

```javascript
import request from '@/utils/request'

// 查询操作日志列表
export function list(query) {
  return request({
    url: '/monitor/operlog/list',
    method: 'get',
    params: query
  })
}

// 删除操作日志
export function delOperlog(operId) {
  return request({
    url: '/monitor/operlog/' + operId,
    method: 'delete'
  })
}

// 清空操作日志
export function cleanOperlog() {
  return request({
    url: '/monitor/operlog/clean',
    method: 'delete'
  })
}
```

### 4.3 使用示例

```javascript
import { list, delOperlog, cleanOperlog } from "@/api/monitor/operlog"

// 查询列表
list({ pageNum: 1, pageSize: 10, businessType: 1 }).then(response => {
  this.list = response.rows
  this.total = response.total
})

// 删除日志
delOperlog('1001,1002').then(() => {
  this.$modal.msgSuccess("删除成功")
})

// 清空日志
cleanOperlog().then(() => {
  this.$modal.msgSuccess("清空成功")
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

### 5.3 数据安全
- 清空操作需二次确认
- 批量删除需二次确认
- 日志中的敏感信息应脱敏处理

---

## 六、性能优化

### 6.1 查询优化
- 支持按时间范围索引查询
- 大数据量时建议限制最大查询范围
- 避免无条件全表查询

### 6.2 导出优化
- 导出前限制最大数据量（建议 1 万条）
- 大数据量导出采用异步方式

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
