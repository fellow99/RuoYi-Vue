# 005-角色管理 - API 接口

**模块编号：** 005  
**模块名称：** 角色管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/system/role`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 角色列表 | GET | `/system/role/list` | `system:role:list` | 分页查询角色列表 |
| 角色详情 | GET | `/system/role/{roleId}` | `system:role:query` | 获取角色详细信息 |
| 新增角色 | POST | `/system/role` | `system:role:add` | 创建新角色 |
| 修改角色 | PUT | `/system/role` | `system:role:edit` | 修改角色信息 |
| 修改数据权限 | PUT | `/system/role/dataScope` | `system:role:edit` | 修改角色数据范围 |
| 状态修改 | PUT | `/system/role/changeStatus` | `system:role:edit` | 启用/停用角色 |
| 删除角色 | DELETE | `/system/role/{roleIds}` | `system:role:remove` | 删除角色（支持批量） |
| 导出角色 | POST | `/system/role/export` | `system:role:export` | 导出角色数据 |
| 角色选项 | GET | `/system/role/optionselect` | `system:role:query` | 获取角色选择框列表 |
| 已分配用户列表 | GET | `/system/role/authUser/allocatedList` | `system:role:list` | 查询已分配用户 |
| 未分配用户列表 | GET | `/system/role/authUser/unallocatedList` | `system:role:list` | 查询未分配用户 |
| 取消授权用户 | PUT | `/system/role/authUser/cancel` | `system:role:edit` | 取消用户角色 |
| 批量取消授权 | PUT | `/system/role/authUser/cancelAll` | `system:role:edit` | 批量取消用户角色 |
| 批量选择用户授权 | PUT | `/system/role/authUser/selectAll` | `system:role:edit` | 批量分配用户角色 |
| 角色部门树 | GET | `/system/role/deptTree/{roleId}` | `system:role:query` | 获取角色部门树 |

---

## 三、接口详细定义

### 3.1 角色列表

**接口：** `GET /system/role/list`

**权限：** `system:role:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleName | String | 否 | 角色名称（模糊匹配） |
| roleKey | String | 否 | 角色权限（模糊匹配） |
| status | String | 否 | 角色状态（0 正常/1 停用） |
| pageNum | Integer | 否 | 页码（默认 1） |
| pageSize | Integer | 否 | 每页数量（默认 10） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "roleId": 1,
      "roleName": "超级管理员",
      "roleKey": "admin",
      "roleSort": 1,
      "dataScope": "1",
      "status": "0",
      "createTime": "2026-01-01 00:00:00"
    }
  ],
  "total": 5
}
```

---

### 3.2 角色详情

**接口：** `GET /system/role/{roleId}`

**权限：** `system:role:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleId | Long | 是 | 角色 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "roleId": 2,
    "roleName": "普通角色",
    "roleKey": "common",
    "roleSort": 2,
    "dataScope": "3",
    "status": "0",
    "menuIds": [100, 101, 102],
    "deptIds": [103]
  }
}
```

---

### 3.3 新增角色

**接口：** `POST /system/role`

**权限：** `system:role:add`

**请求体：**

```json
{
  "roleName": "测试角色",
  "roleKey": "test",
  "roleSort": 3,
  "dataScope": "1",
  "status": "0",
  "menuIds": [100, 101],
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
  "msg": "新增角色'测试角色'失败，角色名称已存在"
}
```

---

### 3.4 修改角色

**接口：** `PUT /system/role`

**权限：** `system:role:edit`

**请求体：**

```json
{
  "roleId": 2,
  "roleName": "普通角色",
  "roleKey": "common",
  "roleSort": 2,
  "dataScope": "3",
  "status": "0",
  "menuIds": [100, 101, 102],
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

### 3.5 修改数据权限

**接口：** `PUT /system/role/dataScope`

**权限：** `system:role:edit`

**请求体：**

```json
{
  "roleId": 2,
  "dataScope": "2",
  "deptIds": [103, 104]
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

### 3.6 状态修改

**接口：** `PUT /system/role/changeStatus`

**权限：** `system:role:edit`

**请求体：**

```json
{
  "roleId": 2,
  "status": "1"
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

### 3.7 删除角色

**接口：** `DELETE /system/role/{roleIds}`

**权限：** `system:role:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleIds | Long[] | 是 | 角色 ID 数组 |

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
  "msg": "不允许操作超级管理员角色"
}
```

---

### 3.8 已分配用户列表

**接口：** `GET /system/role/authUser/allocatedList`

**权限：** `system:role:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleId | Long | 是 | 角色 ID |
| userName | String | 否 | 用户账号 |
| phonenumber | String | 否 | 手机号码 |
| pageNum | Integer | 否 | 页码 |
| pageSize | Integer | 否 | 每页数量 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "userId": 1,
      "userName": "admin",
      "nickName": "管理员"
    }
  ],
  "total": 1
}
```

---

### 3.9 取消授权用户

**接口：** `PUT /system/role/authUser/cancel`

**权限：** `system:role:edit`

**请求体：**

```json
{
  "userId": 2,
  "roleId": 2
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

### 3.10 批量分配用户

**接口：** `PUT /system/role/authUser/selectAll`

**权限：** `system:role:edit`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleId | Long | 是 | 角色 ID |
| userIds | Long[] | 是 | 用户 ID 数组 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
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
| 新增角色'xxx'失败，角色名称已存在 | 角色名称重复 |
| 新增角色'xxx'失败，角色权限已存在 | 角色权限字符重复 |
| 不允许操作超级管理员角色 | 尝试操作 admin 角色 |
| 没有权限访问角色数据 | 数据权限不足 |
