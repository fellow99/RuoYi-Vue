# 009-Common 公共模块 API 接口

## 1. 操作日志 API

### 1.1 查询操作日志列表

**接口路径：** `GET /monitor/operlog/list`

**权限标识：** `monitor:operlog:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| title | String | 否 | 模块标题（模糊查询） |
| businessType | Integer | 否 | 业务类型 |
| businessTypes | Integer[] | 否 | 业务类型数组（多条） |
| status | Integer | 否 | 操作状态（0 正常 1 异常） |
| operName | String | 否 | 操作人员（模糊查询） |
| startTime | String | 否 | 开始时间（yyyy-MM-dd） |
| endTime | String | 否 | 结束时间（yyyy-MM-dd） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "operId": 1,
      "title": "用户管理",
      "businessType": 1,
      "method": "com.ruoyi.web.controller.system.SysUserController.add()",
      "requestMethod": "POST",
      "operName": "admin",
      "deptName": "研发部门",
      "operUrl": "/system/user",
      "operIp": "127.0.0.1",
      "operLocation": "内网 IP",
      "operParam": "{\"id\":1,\"name\":\"test\"}",
      "jsonResult": "{}",
      "status": 0,
      "errorMsg": "",
      "operTime": "2024-01-01 00:00:00",
      "costTime": 10
    }
  ],
  "total": 100
}
```

### 1.2 导出操作日志

**接口路径：** `POST /monitor/operlog/export`

**权限标识：** `monitor:operlog:export`

**请求参数：** 同查询列表参数

**响应：** Excel 文件下载

### 1.3 删除操作日志

**接口路径：** `DELETE /monitor/operlog/{operIds}`

**权限标识：** `monitor:operlog:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| operIds | Long[] | 操作日志 ID 数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.4 清空操作日志

**接口路径：** `DELETE /monitor/operlog/clean`

**权限标识：** `monitor:operlog:remove`

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

## 2. 登录日志 API

### 2.1 查询登录日志列表

**接口路径：** `GET /monitor/logininfor/list`

**权限标识：** `monitor:logininfor:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| userName | String | 否 | 用户账号（模糊查询） |
| ipaddr | String | 否 | 登录 IP 地址 |
| status | String | 否 | 登录状态（0 成功 1 失败） |
| startTime | String | 否 | 开始时间（yyyy-MM-dd） |
| endTime | String | 否 | 结束时间（yyyy-MM-dd） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "infoId": 1,
      "userName": "admin",
      "ipaddr": "127.0.0.1",
      "loginLocation": "内网 IP",
      "browser": "Chrome",
      "os": "Windows",
      "status": "0",
      "msg": "登录成功",
      "loginTime": "2024-01-01 00:00:00"
    }
  ],
  "total": 100
}
```

### 2.2 导出登录日志

**接口路径：** `POST /monitor/logininfor/export`

**权限标识：** `monitor:logininfor:export`

**请求参数：** 同查询列表参数

**响应：** Excel 文件下载

### 2.3 删除登录日志

**接口路径：** `DELETE /monitor/logininfor/{infoIds}`

**权限标识：** `monitor:logininfor:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| infoIds | Long[] | 登录日志 ID 数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 2.4 清空登录日志

**接口路径：** `DELETE /monitor/logininfor/clean`

**权限标识：** `monitor:logininfor:remove`

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 2.5 账户解锁

**接口路径：** `GET /monitor/logininfor/unlock/{userName}`

**权限标识：** `monitor:logininfor:unlock`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| userName | String | 用户账号 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

## 3. 在线用户 API

### 3.1 查询在线用户列表

**接口路径：** `GET /monitor/online/list`

**权限标识：** `monitor:online:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| ipaddr | String | 否 | 登录 IP 地址 |
| userName | String | 否 | 用户账号（模糊查询） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "tokenId": "uuid-string",
      "userName": "admin",
      "deptName": "研发部门",
      "ipaddr": "127.0.0.1",
      "loginLocation": "内网 IP",
      "browser": "Chrome",
      "os": "Windows",
      "loginTime": 1234567890000
    }
  ],
  "total": 10
}
```

### 3.2 用户强退

**接口路径：** `DELETE /monitor/online/{tokenIds}`

**权限标识：** `monitor:online:force`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| tokenIds | String[] | 用户 Token ID 数组（支持批量强退） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

## 4. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 操作成功 |
| 401 | 认证失败，未登录 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

## 5. 业务类型说明

### 5.1 操作日志业务类型
| 值 | 说明 |
|----|------|
| 0 | 其它 |
| 1 | 新增 |
| 2 | 修改 |
| 3 | 删除 |
| 4 | 授权 |
| 5 | 导出 |
| 6 | 导入 |
| 7 | 强退 |
| 8 | 生成代码 |
| 9 | 清空数据 |

### 5.2 登录日志状态
| 值 | 说明 |
|----|------|
| 0 | 成功 |
| 1 | 失败 |

## 6. 使用示例

### 6.1 查询失败登录日志
```javascript
// 查询所有失败的登录记录
listLogininfor({
  status: '1',
  pageNum: 1,
  pageSize: 50
}).then(response => {
  const failedLogins = response.rows
  // 分析失败原因
})
```

### 6.2 解锁账户
```javascript
// 解锁被锁定的账户
unlock('admin').then(() => {
  this.$modal.msgSuccess("账户已解锁")
})
```

### 6.3 强退在线用户
```javascript
// 强退指定用户
forceLogout([tokenId]).then(() => {
  this.$modal.msgSuccess("用户已强退")
})
```
