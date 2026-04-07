# 001-用户管理 - API 接口

**模块编号：** 001  
**模块名称：** 用户管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/system/user`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 用户列表 | GET | `/system/user/list` | `system:user:list` | 分页查询用户列表 |
| 用户详情 | GET | `/system/user/{userId}` | `system:user:query` | 获取用户详细信息 |
| 新增用户 | POST | `/system/user` | `system:user:add` | 创建新用户 |
| 修改用户 | PUT | `/system/user` | `system:user:edit` | 修改用户信息 |
| 删除用户 | DELETE | `/system/user/{userIds}` | `system:user:remove` | 删除用户（支持批量） |
| 重置密码 | PUT | `/system/user/resetPwd` | `system:user:resetPwd` | 重置用户密码 |
| 状态修改 | PUT | `/system/user/changeStatus` | `system:user:edit` | 启用/停用用户 |
| 获取授权角色 | GET | `/system/user/authRole/{userId}` | `system:user:query` | 获取用户可分配角色 |
| 分配角色 | PUT | `/system/user/authRole` | `system:user:edit` | 为用户分配角色 |
| 导出用户 | POST | `/system/user/export` | `system:user:export` | 导出用户数据 |
| 导入用户 | POST | `/system/user/importData` | `system:user:import` | 批量导入用户 |
| 下载模板 | POST | `/system/user/importTemplate` | - | 下载导入模板 |
| 部门树列表 | GET | `/system/user/deptTree` | `system:user:list` | 获取部门树列表 |

---

## 三、接口详细定义

### 3.1 用户列表

**接口：** `GET /system/user/list`

**权限：** `system:user:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userName | String | 否 | 用户账号（模糊匹配） |
| phonenumber | String | 否 | 手机号码（模糊匹配） |
| status | String | 否 | 用户状态（0 正常/1 停用） |
| deptId | Long | 否 | 部门 ID |
| pageNum | Integer | 否 | 页码（默认 1） |
| pageSize | Integer | 否 | 每页数量（默认 10） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "userId": 1,
      "userName": "admin",
      "nickName": "管理员",
      "deptId": 103,
      "dept": {
        "deptName": "研发部门"
      },
      "email": "admin@ruoyi.com",
      "phonenumber": "15888888888",
      "sex": "0",
      "status": "0",
      "loginDate": "2026-03-12 10:00:00",
      "createTime": "2026-01-01 00:00:00"
    }
  ],
  "total": 1
}
```

---

### 3.2 用户详情

**接口：** `GET /system/user/{userId}`

**权限：** `system:user:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userId | Long | 否 | 用户 ID（不传表示新增） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "userId": 1,
    "userName": "admin",
    "nickName": "管理员",
    "deptId": 103,
    "email": "admin@ruoyi.com",
    "phonenumber": "15888888888",
    "sex": "0",
    "status": "0",
    "postIds": [1],
    "roleIds": [1]
  },
  "roles": [
    {
      "roleId": 1,
      "roleName": "超级管理员",
      "roleKey": "admin"
    }
  ],
  "posts": [
    {
      "postId": 1,
      "postName": "董事长",
      "postCode": "ceo"
    }
  ]
}
```

---

### 3.3 新增用户

**接口：** `POST /system/user`

**权限：** `system:user:add`

**请求体：**

```json
{
  "userName": "test",
  "nickName": "测试用户",
  "password": "test123",
  "deptId": 103,
  "email": "test@ruoyi.com",
  "phonenumber": "13800138000",
  "sex": "0",
  "status": "0",
  "postIds": [1],
  "roleIds": [2],
  "remark": "备注信息"
}
```

**请求参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userName | String | 是 | 用户账号（2-30 字符） |
| nickName | String | 是 | 用户昵称（0-30 字符） |
| password | String | 是 | 密码（加密存储） |
| deptId | Long | 是 | 部门 ID |
| email | String | 否 | 邮箱（50 字符内） |
| phonenumber | String | 否 | 手机号码（11 位） |
| sex | String | 否 | 性别（0 男 1 女 2 未知） |
| status | String | 否 | 状态（0 正常 1 停用） |
| postIds | Long[] | 否 | 岗位 ID 数组 |
| roleIds | Long[] | 否 | 角色 ID 数组 |
| remark | String | 否 | 备注（500 字符内） |

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
  "msg": "新增用户'test'失败，登录账号已存在"
}
```

---

### 3.4 修改用户

**接口：** `PUT /system/user`

**权限：** `system:user:edit`

**请求体：**

```json
{
  "userId": 2,
  "userName": "test",
  "nickName": "测试用户修改",
  "deptId": 103,
  "email": "test@ruoyi.com",
  "phonenumber": "13800138000",
  "sex": "1",
  "status": "0",
  "postIds": [1],
  "roleIds": [2],
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

### 3.5 删除用户

**接口：** `DELETE /system/user/{userIds}`

**权限：** `system:user:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userIds | Long[] | 是 | 用户 ID 数组（支持批量） |

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
  "msg": "当前用户不能删除"
}
```

---

### 3.6 重置密码

**接口：** `PUT /system/user/resetPwd`

**权限：** `system:user:resetPwd`

**请求体：**

```json
{
  "userId": 2,
  "password": "new123"
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

### 3.7 状态修改

**接口：** `PUT /system/user/changeStatus`

**权限：** `system:user:edit`

**请求体：**

```json
{
  "userId": 2,
  "status": "1"
}
```

**参数说明：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userId | Long | 是 | 用户 ID |
| status | String | 是 | 状态（0 正常 1 停用） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.8 获取授权角色

**接口：** `GET /system/user/authRole/{userId}`

**权限：** `system:user:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userId | Long | 是 | 用户 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "user": {
    "userId": 2,
    "userName": "test",
    "nickName": "测试用户"
  },
  "roles": [
    {
      "roleId": 1,
      "roleName": "超级管理员",
      "roleKey": "admin"
    },
    {
      "roleId": 2,
      "roleName": "普通角色",
      "roleKey": "common"
    }
  ]
}
```

---

### 3.9 分配角色

**接口：** `PUT /system/user/authRole`

**权限：** `system:user:edit`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| userId | Long | 是 | 用户 ID |
| roleIds | Long[] | 是 | 角色 ID 数组 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.10 导出用户

**接口：** `POST /system/user/export`

**权限：** `system:user:export`

**请求参数：** 同用户列表查询参数

**响应：** Excel 文件下载

---

### 3.11 导入用户

**接口：** `POST /system/user/importData`

**权限：** `system:user:import`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| file | MultipartFile | 是 | Excel 文件 |
| updateSupport | boolean | 是 | 是否更新已存在用户 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "恭喜您，数据已全部导入成功！共 10 条，数据如下：..."
}
```

---

### 3.12 下载导入模板

**接口：** `POST /system/user/importTemplate`

**权限：** 无（登录即可）

**响应：** Excel 模板文件下载

---

### 3.13 获取部门树列表

**接口：** `GET /system/user/deptTree`

**权限：** `system:user:list`

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "depts": [
    {
      "id": 100,
      "label": "若依科技",
      "children": [
        {
          "id": 103,
          "label": "研发部门",
          "children": []
        }
      ]
    }
  ]
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
| 新增用户'xxx'失败，登录账号已存在 | 用户账号重复 |
| 新增用户'xxx'失败，手机号码已存在 | 手机号重复 |
| 新增用户'xxx'失败，邮箱账号已存在 | 邮箱重复 |
| 不允许操作超级管理员用户 | 尝试操作 admin 用户 |
| 没有权限访问用户数据 | 数据权限不足 |
| 当前用户不能删除 | 尝试删除自己 |

---

## 五、数据权限说明

用户管理接口支持数据权限过滤，通过 `@DataScope` 注解实现：

```java
@DataScope(deptAlias = "d", userAlias = "u")
public List<SysUser> selectUserList(SysUser user)
```

**数据范围：**

1. 全部数据权限：无过滤
2. 自定义数据权限：过滤指定部门
3. 本部门数据权限：`d.dept_id = #{deptId}`
4. 本部门及以下：`d.dept_id IN (...)`
5. 仅本人：`u.user_id = #{userId}`
