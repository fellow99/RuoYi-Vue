# 006-Dict 字典管理模块 API 接口

## 1. 字典类型 API

### 1.1 查询字典类型列表

**接口路径：** `GET /system/dict/type/list`

**权限标识：** `system:dict:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dictName | String | 否 | 字典名称（模糊查询） |
| dictType | String | 否 | 字典类型（模糊查询） |
| status | String | 否 | 状态（0 正常 1 停用） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "dictId": 1,
      "dictName": "用户性别",
      "dictType": "sys_user_sex",
      "status": "0",
      "remark": "用户性别列表",
      "createTime": "2024-01-01 00:00:00"
    }
  ],
  "total": 10
}
```

### 1.2 查询字典类型详情

**接口路径：** `GET /system/dict/type/{dictId}`

**权限标识：** `system:dict:query`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| dictId | Long | 字典类型 ID |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "dictId": 1,
    "dictName": "用户性别",
    "dictType": "sys_user_sex",
    "status": "0",
    "remark": "用户性别列表"
  }
}
```

### 1.3 新增字典类型

**接口路径：** `POST /system/dict/type`

**权限标识：** `system:dict:add`

**请求体：**
```json
{
  "dictName": "测试字典",
  "dictType": "test_dict_type",
  "status": "0",
  "remark": "测试字典类型"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.4 修改字典类型

**接口路径：** `PUT /system/dict/type`

**权限标识：** `system:dict:edit`

**请求体：**
```json
{
  "dictId": 1,
  "dictName": "用户性别（修改）",
  "dictType": "sys_user_sex",
  "status": "0",
  "remark": "用户性别列表"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.5 删除字典类型

**接口路径：** `DELETE /system/dict/type/{dictIds}`

**权限标识：** `system:dict:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| dictIds | Long[] | 字典类型 ID 数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.6 导出字典类型

**接口路径：** `POST /system/dict/type/export`

**权限标识：** `system:dict:export`

**请求参数：** 同查询列表参数

**响应：** Excel 文件下载

### 1.7 刷新字典缓存

**接口路径：** `DELETE /system/dict/type/refreshCache`

**权限标识：** `system:dict:remove`

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.8 获取字典选择框列表

**接口路径：** `GET /system/dict/type/optionselect`

**权限标识：** 无限制

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": [
    {
      "dictId": 1,
      "dictName": "用户性别",
      "dictType": "sys_user_sex",
      "status": "0"
    }
  ]
}
```

## 2. 字典数据 API

### 2.1 查询字典数据列表

**接口路径：** `GET /system/dict/data/list`

**权限标识：** `system:dict:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dictType | String | 否 | 字典类型 |
| dictLabel | String | 否 | 字典标签（模糊查询） |
| status | String | 否 | 状态（0 正常 1 停用） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "dictCode": 1,
      "dictSort": 1,
      "dictLabel": "男",
      "dictValue": "1",
      "dictType": "sys_user_sex",
      "isDefault": "Y",
      "status": "0"
    }
  ],
  "total": 3
}
```

### 2.2 查询字典数据详情

**接口路径：** `GET /system/dict/data/{dictCode}`

**权限标识：** `system:dict:query`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| dictCode | Long | 字典数据编码 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "dictCode": 1,
    "dictSort": 1,
    "dictLabel": "男",
    "dictValue": "1",
    "dictType": "sys_user_sex",
    "isDefault": "Y",
    "status": "0"
  }
}
```

### 2.3 新增字典数据

**接口路径：** `POST /system/dict/data`

**权限标识：** `system:dict:add`

**请求体：**
```json
{
  "dictType": "sys_user_sex",
  "dictLabel": "未知",
  "dictValue": "3",
  "dictSort": 3,
  "isDefault": "N",
  "status": "0",
  "remark": "性别未知"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 2.4 修改字典数据

**接口路径：** `PUT /system/dict/data`

**权限标识：** `system:dict:edit`

**请求体：**
```json
{
  "dictCode": 1,
  "dictType": "sys_user_sex",
  "dictLabel": "男",
  "dictValue": "1",
  "dictSort": 1,
  "isDefault": "Y",
  "status": "0",
  "remark": "性别男"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 2.5 删除字典数据

**接口路径：** `DELETE /system/dict/data/{dictCodes}`

**权限标识：** `system:dict:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| dictCodes | Long[] | 字典数据编码数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 2.6 导出字典数据

**接口路径：** `POST /system/dict/data/export`

**权限标识：** `system:dict:export`

**请求参数：** 同查询列表参数

**响应：** Excel 文件下载

### 2.7 根据字典类型查询字典数据

**接口路径：** `GET /system/dict/data/type/{dictType}`

**权限标识：** 无限制

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| dictType | String | 字典类型标识 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": [
    {
      "dictCode": 1,
      "dictLabel": "男",
      "dictValue": "1",
      "dictSort": 1
    },
    {
      "dictCode": 2,
      "dictLabel": "女",
      "dictValue": "2",
      "dictSort": 2
    }
  ]
}
```

## 3. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 操作成功 |
| 401 | 认证失败，未登录 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

## 4. 业务错误信息

| 错误信息 | 说明 |
|----------|------|
| 新增字典'xxx'失败，字典类型已存在 | 字典类型标识重复 |
| 修改字典'xxx'失败，字典类型已存在 | 字典类型标识重复 |
