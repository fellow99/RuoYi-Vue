# 004-菜单管理 - API 接口

**模块编号：** 004  
**模块名称：** 菜单管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/system/menu`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 菜单列表 | GET | `/system/menu/list` | `system:menu:list` | 查询菜单列表 |
| 菜单详情 | GET | `/system/menu/{menuId}` | `system:menu:query` | 获取菜单详细信息 |
| 菜单树 | GET | `/system/menu/treeselect` | - | 获取菜单下拉树列表 |
| 角色菜单树 | GET | `/system/menu/roleMenuTreeselect/{roleId}` | - | 加载角色菜单树 |
| 新增菜单 | POST | `/system/menu` | `system:menu:add` | 创建新菜单 |
| 修改菜单 | PUT | `/system/menu` | `system:menu:edit` | 修改菜单信息 |
| 删除菜单 | DELETE | `/system/menu/{menuId}` | `system:menu:remove` | 删除菜单 |

---

## 三、接口详细定义

### 3.1 菜单列表

**接口：** `GET /system/menu/list`

**权限：** `system:menu:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| menuName | String | 否 | 菜单名称（模糊匹配） |
| status | String | 否 | 菜单状态（0 正常/1 停用） |
| menuType | String | 否 | 菜单类型（M/C/F） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "menuId": 1,
      "menuName": "系统管理",
      "parentId": 0,
      "orderNum": 1,
      "path": "system",
      "component": "layout",
      "menuType": "M",
      "visible": "0",
      "status": "0",
      "icon": "setting",
      "children": [
        {
          "menuId": 100,
          "menuName": "用户管理",
          "parentId": 1,
          "path": "user",
          "component": "system/user/index",
          "menuType": "C",
          "perms": "system:user:list"
        }
      ]
    }
  ]
}
```

---

### 3.2 菜单详情

**接口：** `GET /system/menu/{menuId}`

**权限：** `system:menu:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| menuId | Long | 是 | 菜单 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "menuId": 100,
    "menuName": "用户管理",
    "parentId": 1,
    "orderNum": 1,
    "path": "user",
    "component": "system/user/index",
    "menuType": "C",
    "visible": "0",
    "status": "0",
    "perms": "system:user:list",
    "icon": "user"
  }
}
```

---

### 3.3 菜单树

**接口：** `GET /system/menu/treeselect`

**权限：** 无（登录即可）

**用途：** 新增/修改菜单时选择上级菜单

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "menus": [
    {
      "id": 0,
      "label": "顶级菜单",
      "children": [
        {
          "id": 1,
          "label": "系统管理",
          "children": []
        }
      ]
    }
  ]
}
```

---

### 3.4 角色菜单树

**接口：** `GET /system/menu/roleMenuTreeselect/{roleId}`

**权限：** 无（登录即可）

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| roleId | Long | 是 | 角色 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "checkedKeys": [100, 101, 102],
  "menus": [
    {
      "id": 1,
      "label": "系统管理",
      "children": [
        {
          "id": 100,
          "label": "用户管理"
        }
      ]
    }
  ]
}
```

---

### 3.5 新增菜单

**接口：** `POST /system/menu`

**权限：** `system:menu:add`

**请求体：**

```json
{
  "parentId": 1,
  "menuType": "C",
  "menuName": "用户管理",
  "path": "user",
  "component": "system/user/index",
  "orderNum": 1,
  "visible": "0",
  "status": "0",
  "perms": "system:user:list",
  "icon": "user"
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
  "msg": "新增菜单'用户管理'失败，菜单名称已存在"
}
```

---

### 3.6 修改菜单

**接口：** `PUT /system/menu`

**权限：** `system:menu:edit`

**请求体：**

```json
{
  "menuId": 100,
  "parentId": 1,
  "menuType": "C",
  "menuName": "用户管理",
  "path": "user",
  "component": "system/user/index",
  "orderNum": 1,
  "visible": "0",
  "status": "0",
  "perms": "system:user:list",
  "icon": "user"
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

### 3.7 删除菜单

**接口：** `DELETE /system/menu/{menuId}`

**权限：** `system:menu:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| menuId | Long | 是 | 菜单 ID |

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
  "msg": "存在子菜单，不允许删除"
}
```

```json
{
  "code": 500,
  "msg": "菜单已分配，不允许删除"
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
| 新增菜单'xxx'失败，菜单名称已存在 | 同级菜单名称重复 |
| 修改菜单'xxx'失败，上级菜单不能选择自己 | 不能选择自己作为上级 |
| 存在子菜单，不允许删除 | 需先删除子菜单 |
| 菜单已分配，不允许删除 | 需先从角色移除 |
