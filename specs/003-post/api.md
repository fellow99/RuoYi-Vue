# 003-岗位管理 - API 接口

**模块编号：** 003  
**模块名称：** 岗位管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/system/post`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 岗位列表 | GET | `/system/post/list` | `system:post:list` | 分页查询岗位列表 |
| 岗位详情 | GET | `/system/post/{postId}` | `system:post:query` | 获取岗位详细信息 |
| 新增岗位 | POST | `/system/post` | `system:post:add` | 创建新岗位 |
| 修改岗位 | PUT | `/system/post` | `system:post:edit` | 修改岗位信息 |
| 删除岗位 | DELETE | `/system/post/{postIds}` | `system:post:remove` | 删除岗位（支持批量） |
| 导出岗位 | POST | `/system/post/export` | `system:post:export` | 导出岗位数据 |
| 岗位选项 | GET | `/system/post/optionselect` | - | 获取岗位选择框列表 |

---

## 三、接口详细定义

### 3.1 岗位列表

**接口：** `GET /system/post/list`

**权限：** `system:post:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| postCode | String | 否 | 岗位编码（模糊匹配） |
| postName | String | 否 | 岗位名称（模糊匹配） |
| status | String | 否 | 岗位状态（0 正常/1 停用） |
| pageNum | Integer | 否 | 页码（默认 1） |
| pageSize | Integer | 否 | 每页数量（默认 10） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "postId": 1,
      "postCode": "ceo",
      "postName": "董事长",
      "postSort": 1,
      "status": "0",
      "createTime": "2026-01-01 00:00:00"
    }
  ],
  "total": 5
}
```

---

### 3.2 岗位详情

**接口：** `GET /system/post/{postId}`

**权限：** `system:post:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| postId | Long | 是 | 岗位 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "postId": 1,
    "postCode": "ceo",
    "postName": "董事长",
    "postSort": 1,
    "status": "0",
    "remark": "备注信息"
  }
}
```

---

### 3.3 新增岗位

**接口：** `POST /system/post`

**权限：** `system:post:add`

**请求体：**

```json
{
  "postCode": "manager",
  "postName": "部门经理",
  "postSort": 2,
  "status": "0",
  "remark": "备注"
}
```

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**错误响应：**

```json
{
  "code": 500,
  "msg": "新增岗位'部门经理'失败，岗位编码已存在"
}
```

---

### 3.4 修改岗位

**接口：** `PUT /system/post`

**权限：** `system:post:edit`

**请求体：**

```json
{
  "postId": 2,
  "postCode": "manager",
  "postName": "部门经理",
  "postSort": 2,
  "status": "0",
  "remark": "修改备注"
}
```

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.5 删除岗位

**接口：** `DELETE /system/post/{postIds}`

**权限：** `system:post:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| postIds | Long[] | 是 | 岗位 ID 数组 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.6 导出岗位

**接口：** `POST /system/post/export`

**权限：** `system:post:export`

**请求参数：** 同岗位列表查询参数

**响应：** Excel 文件下载

---

### 3.7 岗位选项列表

**接口：** `GET /system/post/optionselect`

**权限：** 无（登录即可）

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "postId": 1,
      "postCode": "ceo",
      "postName": "董事长"
    },
    {
      "postId": 2,
      "postCode": "manager",
      "postName": "部门经理"
    }
  ]
}
```

---

## 四、错误码说明

| 错误码 | 说明 |
|-------|------|
| 200 | 操作成功 |
| 401 | 认证失败 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

**常见错误信息：**

| 错误信息 | 说明 |
|---------|------|
| 新增岗位'xxx'失败，岗位编码已存在 | 岗位编码重复 |
| 新增岗位'xxx'失败，岗位名称已存在 | 岗位名称重复 |
