# 002-部门管理 - API 接口

**模块编号：** 002  
**模块名称：** 部门管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/system/dept`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 部门列表 | GET | `/system/dept/list` | `system:dept:list` | 查询部门列表（树形） |
| 排除节点列表 | GET | `/system/dept/list/exclude/{deptId}` | `system:dept:list` | 查询部门列表（排除指定节点） |
| 部门详情 | GET | `/system/dept/{deptId}` | `system:dept:query` | 获取部门详细信息 |
| 新增部门 | POST | `/system/dept` | `system:dept:add` | 创建新部门 |
| 修改部门 | PUT | `/system/dept` | `system:dept:edit` | 修改部门信息 |
| 删除部门 | DELETE | `/system/dept/{deptId}` | `system:dept:remove` | 删除部门 |

---

## 三、接口详细定义

### 3.1 部门列表

**接口：** `GET /system/dept/list`

**权限：** `system:dept:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| deptName | String | 否 | 部门名称（模糊匹配） |
| status | String | 否 | 部门状态（0 正常/1 停用） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "deptId": 100,
      "parentId": 0,
      "ancestors": "100",
      "deptName": "若依科技",
      "orderNum": 0,
      "leader": "张三",
      "phone": "13800138000",
      "email": "admin@ruoyi.com",
      "status": "0",
      "children": [
        {
          "deptId": 101,
          "parentId": 100,
          "ancestors": "100,101",
          "deptName": "深圳分公司",
          "orderNum": 1,
          "status": "0",
          "children": []
        }
      ]
    }
  ]
}
```

---

### 3.2 排除节点列表

**接口：** `GET /system/dept/list/exclude/{deptId}`

**权限：** `system:dept:list`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| deptId | Long | 否 | 要排除的部门 ID |

**用途：** 修改部门时，排除当前部门及其子部门（避免选择自己作为上级）

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "deptId": 100,
      "deptName": "若依科技",
      "children": [
        {
          "deptId": 104,
          "deptName": "北京分公司",
          "children": []
        }
      ]
    }
  ]
}
```

---

### 3.3 部门详情

**接口：** `GET /system/dept/{deptId}`

**权限：** `system:dept:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| deptId | Long | 是 | 部门 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "deptId": 101,
    "parentId": 100,
    "ancestors": "100,101",
    "deptName": "深圳分公司",
    "orderNum": 1,
    "leader": "李四",
    "phone": "13800138001",
    "email": "sz@ruoyi.com",
    "status": "0"
  }
}
```

---

### 3.4 新增部门

**接口：** `POST /system/dept`

**权限：** `system:dept:add`

**请求体：**

```json
{
  "parentId": 100,
  "deptName": "新产品部",
  "orderNum": 2,
  "leader": "王五",
  "phone": "13800138002",
  "email": "product@ruoyi.com",
  "status": "0"
}
```

**请求参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| parentId | Long | 是 | 父部门 ID |
| deptName | String | 是 | 部门名称（30 字符内） |
| orderNum | Integer | 是 | 显示顺序 |
| leader | String | 否 | 负责人（50 字符内） |
| phone | String | 否 | 联系电话（11 位） |
| email | String | 否 | 邮箱（50 字符内） |
| status | String | 否 | 状态（0 正常 1 停用） |

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
  "msg": "新增部门'研发部'失败，部门名称已存在"
}
```

---

### 3.5 修改部门

**接口：** `PUT /system/dept`

**权限：** `system:dept:edit`

**请求体：**

```json
{
  "deptId": 101,
  "parentId": 100,
  "deptName": "深圳分公司",
  "orderNum": 1,
  "leader": "李四",
  "phone": "13800138001",
  "email": "sz@ruoyi.com",
  "status": "0"
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
  "msg": "修改部门'深圳分公司'失败，部门名称已存在"
}
```

```json
{
  "code": 500,
  "msg": "修改部门'深圳分公司'失败，上级部门不能是自己"
}
```

```json
{
  "code": 500,
  "msg": "该部门包含未停用的子部门！"
}
```

---

### 3.6 删除部门

**接口：** `DELETE /system/dept/{deptId}`

**权限：** `system:dept:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| deptId | Long | 是 | 部门 ID |

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
  "msg": "存在下级部门，不允许删除"
}
```

```json
{
  "code": 500,
  "msg": "部门存在用户，不允许删除"
}
```

---

## 四、错误码说明

| 错误码 | 说明 |
|-------|------|
| 200 | 操作成功 |
| 401 | 认证失败，未登录或 Token 过期 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

**常见错误信息：**

| 错误信息 | 说明 |
|---------|------|
| 新增部门'xxx'失败，部门名称已存在 | 同级部门名称重复 |
| 修改部门'xxx'失败，部门名称已存在 | 同级部门名称重复 |
| 修改部门'xxx'失败，上级部门不能是自己 | 不能选择自己作为上级 |
| 该部门包含未停用的子部门！ | 停用前需先停子部门 |
| 存在下级部门，不允许删除 | 需先删除子部门 |
| 部门存在用户，不允许删除 | 需先移除部门下用户 |

---

## 五、数据权限说明

部门管理接口一般不应用数据权限过滤（管理员需要看到完整组织架构），但为其他模块提供数据权限基础。

其他模块查询部门时，通过 `@DataScope` 注解实现数据权限过滤。
