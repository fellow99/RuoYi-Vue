# 对外接口模型 (overall-api.md)

**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、API 概述

### 1.1 接口分类

系统对外提供的接口分为三大类：

| 分类 | 说明 | 接口数量 |
|------|------|----------|
| 系统管理 | 用户、角色、菜单、部门等基础管理 | ~80 个 |
| 系统监控 | 日志、任务、缓存、服务器等监控 | ~30 个 |
| 系统工具 | 代码生成、接口文档等工具 | ~15 个 |

### 1.2 接口规范

#### 基础 URL

```
开发环境：http://localhost:8080
生产环境：https://api.example.com
```

#### 接口路径前缀

| 模块 | 前缀 | 说明 |
|------|------|------|
| 公共接口 | `/` | 登录、注册、验证码 |
| 系统管理 | `/system` | 用户、角色、菜单等 |
| 系统监控 | `/monitor` | 日志、任务、缓存等 |
| 系统工具 | `/tool` | 代码生成、Swagger 等 |

#### 认证方式

- **认证类型：** JWT Bearer Token
- **请求头：** `Authorization: Bearer {token}`
- **Token 有效期：** 24 小时（可配置）

---

## 二、公共接口

### 2.1 认证相关

#### 获取验证码

```http
GET /captchaImage
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "uuid": "xxx-xxx-xxx",
  "img": "base64 编码的图片"
}
```

#### 用户登录

```http
POST /login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123",
  "code": "1234",
  "uuid": "xxx-xxx-xxx"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 用户登出

```http
POST /logout
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 获取用户信息

```http
GET /getInfo
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "user": {
    "userId": 1,
    "userName": "admin",
    "nickName": "管理员",
    "dept": {
      "deptId": 100,
      "deptName": "研发部"
    },
    "roles": ["admin"]
  },
  "roles": ["admin"],
  "permissions": ["*:*:*"]
}
```

### 2.2 注册相关

#### 用户注册

```http
POST /register
Content-Type: application/json

{
  "username": "test",
  "password": "test123",
  "code": "1234",
  "uuid": "xxx-xxx-xxx"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "注册成功"
}
```

---

## 三、系统管理接口

### 3.1 用户管理

**基础路径：** `/system/user`

#### 获取用户列表

```http
GET /system/user/list?pageNum=1&pageSize=10&userName=&status=
Authorization: Bearer {token}
```

**请求参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pageNum | int | 否 | 页码，默认 1 |
| pageSize | int | 否 | 每页数量，默认 10 |
| userName | string | 否 | 用户账号 |
| phonenumber | string | 否 | 手机号码 |
| status | string | 否 | 用户状态 |
| deptId | long | 否 | 部门 ID |

**响应：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "userId": 1,
      "userName": "admin",
      "nickName": "管理员",
      "email": "admin@ruoyi.com",
      "phonenumber": "13800138000",
      "sex": "0",
      "avatar": "",
      "status": "0",
      "deptId": 100,
      "dept": {
        "deptId": 100,
        "deptName": "研发部"
      },
      "createTime": "2024-01-01 00:00:00"
    }
  ],
  "total": 1
}
```

#### 获取用户详情

```http
GET /system/user/{userId}
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "data": {
    "userId": 1,
    "userName": "admin",
    "nickName": "管理员",
    "email": "admin@ruoyi.com",
    "phonenumber": "13800138000",
    "sex": "0",
    "avatar": "",
    "status": "0",
    "deptId": 100,
    "roleIds": [1],
    "postIds": [1]
  }
}
```

#### 新增用户

```http
POST /system/user
Content-Type: application/json
Authorization: Bearer {token}

{
  "userName": "test",
  "nickName": "测试用户",
  "password": "test123",
  "email": "test@ruoyi.com",
  "phonenumber": "13900139000",
  "sex": "0",
  "status": "0",
  "deptId": 100,
  "roleIds": [2],
  "postIds": [1]
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 修改用户

```http
PUT /system/user
Content-Type: application/json
Authorization: Bearer {token}

{
  "userId": 2,
  "userName": "test",
  "nickName": "测试用户修改",
  "email": "test@ruoyi.com",
  "phonenumber": "13900139000",
  "sex": "0",
  "status": "0",
  "deptId": 100,
  "roleIds": [2],
  "postIds": [1]
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 删除用户

```http
DELETE /system/user/{userIds}
Authorization: Bearer {token}
```

**路径参数：**
- `userIds`: 用户 ID，多个用逗号分隔

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 重置密码

```http
PUT /system/user/resetPwd
Content-Type: application/json
Authorization: Bearer {token}

{
  "userId": 2,
  "password": "new123456"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 修改用户状态

```http
PUT /system/user/changeStatus
Content-Type: application/json
Authorization: Bearer {token}

{
  "userId": 2,
  "status": "1"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 分配角色

```http
POST /system/user/{userId}/authRole
Content-Type: application/json
Authorization: Bearer {token}

{
  "userId": 2,
  "roleIds": [1, 2]
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

#### 导出用户

```http
POST /system/user/export
Content-Type: application/json
Authorization: Bearer {token}

{
  "userName": "",
  "phonenumber": "",
  "status": ""
}
```

**响应：** 文件下载

### 3.2 角色管理

**基础路径：** `/system/role`

#### 获取角色列表

```http
GET /system/role/list?pageNum=1&pageSize=10&roleName=&status=
Authorization: Bearer {token}
```

**响应：**
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
      "createTime": "2024-01-01 00:00:00"
    }
  ],
  "total": 1
}
```

#### 获取角色详情

```http
GET /system/role/{roleId}
Authorization: Bearer {token}
```

#### 新增角色

```http
POST /system/role
Content-Type: application/json
Authorization: Bearer {token}

{
  "roleName": "测试角色",
  "roleKey": "test",
  "roleSort": 2,
  "dataScope": "1",
  "status": "0",
  "menuIds": [1, 2, 3]
}
```

#### 修改角色

```http
PUT /system/role
Content-Type: application/json
Authorization: Bearer {token}

{
  "roleId": 2,
  "roleName": "测试角色修改",
  "roleKey": "test",
  "roleSort": 2,
  "dataScope": "1",
  "status": "0",
  "menuIds": [1, 2, 3]
}
```

#### 删除角色

```http
DELETE /system/role/{roleIds}
Authorization: Bearer {token}
```

#### 修改角色状态

```http
PUT /system/role/changeStatus
Content-Type: application/json
Authorization: Bearer {token}

{
  "roleId": 2,
  "status": "1"
}
```

#### 获取已分配用户列表

```http
GET /system/role/authUser/allocatedList?pageNum=1&pageSize=10&roleId=2&userName=
Authorization: Bearer {token}
```

#### 批量授权用户

```http
PUT /system/role/authUser/selectAll
Content-Type: application/json
Authorization: Bearer {token}

{
  "roleId": 2,
  "userIds": "1,2,3"
}
```

#### 取消授权用户

```http
PUT /system/role/authUser/cancel
Content-Type: application/json
Authorization: Bearer {token}

{
  "roleId": 2,
  "userId": 1
}
```

### 3.3 菜单管理

**基础路径：** `/system/menu`

#### 获取菜单列表

```http
GET /system/menu/list?menuName=&status=
Authorization: Bearer {token}
```

**响应：**
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
      "component": "Layout",
      "menuType": "M",
      "visible": "0",
      "status": "0",
      "perms": "system",
      "icon": "system",
      "children": []
    }
  ]
}
```

#### 获取菜单详情

```http
GET /system/menu/{menuId}
Authorization: Bearer {token}
```

#### 获取菜单树

```http
GET /system/menu/treeselect
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "menus": [
    {
      "menuId": 1,
      "menuName": "系统管理",
      "parentId": 0,
      "children": [
        {
          "menuId": 2,
          "menuName": "用户管理",
          "parentId": 1,
          "children": []
        }
      ]
    }
  ]
}
```

#### 新增菜单

```http
POST /system/menu
Content-Type: application/json
Authorization: Bearer {token}

{
  "menuName": "测试菜单",
  "parentId": 1,
  "orderNum": 1,
  "path": "test",
  "component": "system/test/index",
  "menuType": "C",
  "visible": "0",
  "status": "0",
  "perms": "system:test:list",
  "icon": "test"
}
```

#### 修改菜单

```http
PUT /system/menu
Content-Type: application/json
Authorization: Bearer {token}

{
  "menuId": 100,
  "menuName": "测试菜单修改",
  "parentId": 1,
  "orderNum": 1,
  "path": "test",
  "component": "system/test/index",
  "menuType": "C",
  "visible": "0",
  "status": "0",
  "perms": "system:test:list",
  "icon": "test"
}
```

#### 删除菜单

```http
DELETE /system/menu/{menuIds}
Authorization: Bearer {token}
```

### 3.4 部门管理

**基础路径：** `/system/dept`

#### 获取部门列表

```http
GET /system/dept/list?deptName=&status=
Authorization: Bearer {token}
```

#### 获取部门树

```http
GET /system/dept/treeselect
Authorization: Bearer {token}
```

#### 新增部门

```http
POST /system/dept
Content-Type: application/json
Authorization: Bearer {token}

{
  "parentId": 100,
  "deptName": "测试部门",
  "orderNum": 1,
  "leader": "张三",
  "phone": "13800138000",
  "email": "test@ruoyi.com",
  "status": "0"
}
```

#### 修改部门

```http
PUT /system/dept
Content-Type: application/json
Authorization: Bearer {token}

{
  "deptId": 200,
  "parentId": 100,
  "deptName": "测试部门修改",
  "orderNum": 1,
  "leader": "李四",
  "phone": "13900139000",
  "email": "test2@ruoyi.com",
  "status": "0"
}
```

#### 删除部门

```http
DELETE /system/dept/{deptIds}
Authorization: Bearer {token}
```

### 3.5 岗位管理

**基础路径：** `/system/post`

#### 获取岗位列表

```http
GET /system/post/list?pageNum=1&pageSize=10&postCode=&status=
Authorization: Bearer {token}
```

#### 新增岗位

```http
POST /system/post
Content-Type: application/json
Authorization: Bearer {token}

{
  "postCode": "test",
  "postName": "测试岗位",
  "postSort": 1,
  "status": "0"
}
```

#### 修改岗位

```http
PUT /system/post
Content-Type: application/json
Authorization: Bearer {token}

{
  "postId": 1,
  "postCode": "test",
  "postName": "测试岗位修改",
  "postSort": 1,
  "status": "0"
}
```

#### 删除岗位

```http
DELETE /system/post/{postIds}
Authorization: Bearer {token}
```

### 3.6 字典管理

**基础路径：** `/system/dict`

#### 获取字典类型列表

```http
GET /system/dict/type/list?pageNum=1&pageSize=10&dictName=&dictType=&status=
Authorization: Bearer {token}
```

#### 获取字典数据列表

```http
GET /system/dict/data/list?pageNum=1&pageSize=10&dictType=&dictLabel=&status=
Authorization: Bearer {token}
```

#### 新增字典类型

```http
POST /system/dict/type
Content-Type: application/json
Authorization: Bearer {token}

{
  "dictName": "测试字典",
  "dictType": "test_type",
  "status": "0"
}
```

#### 新增字典数据

```http
POST /system/dict/data
Content-Type: application/json
Authorization: Bearer {token}

{
  "dictType": "test_type",
  "dictLabel": "测试标签",
  "dictValue": "test",
  "dictSort": 1,
  "status": "0"
}
```

### 3.7 参数配置

**基础路径：** `/system/config`

#### 获取参数列表

```http
GET /system/config/list?pageNum=1&pageSize=10&configName=&configKey=&status=
Authorization: Bearer {token}
```

#### 根据 Key 查询参数

```http
GET /system/config/configKey/{configKey}
Authorization: Bearer {token}
```

#### 新增参数

```http
POST /system/config
Content-Type: application/json
Authorization: Bearer {token}

{
  "configName": "测试参数",
  "configKey": "test.key",
  "configValue": "test",
  "configType": "N",
  "status": "0"
}
```

### 3.8 通知公告

**基础路径：** `/system/notice`

#### 获取公告列表

```http
GET /system/notice/list?pageNum=1&pageSize=10&noticeTitle=&noticeType=&status=
Authorization: Bearer {token}
```

#### 新增公告

```http
POST /system/notice
Content-Type: application/json
Authorization: Bearer {token}

{
  "noticeTitle": "测试公告",
  "noticeType": "1",
  "noticeContent": "<p>公告内容</p>",
  "status": "0"
}
```

### 3.9 个人中心

**基础路径：** `/system/user/profile`

#### 获取个人信息

```http
GET /system/user/profile
Authorization: Bearer {token}
```

#### 修改个人信息

```http
PUT /system/user/profile
Content-Type: application/json
Authorization: Bearer {token}

{
  "nickName": "新昵称",
  "email": "new@ruoyi.com",
  "phonenumber": "13800138000",
  "sex": "0"
}
```

#### 修改密码

```http
PUT /system/user/profile/updatePwd
Content-Type: application/json
Authorization: Bearer {token}

{
  "oldPassword": "old123",
  "newPassword": "new123"
}
```

#### 上传头像

```http
POST /system/user/profile/avatar
Content-Type: multipart/form-data
Authorization: Bearer {token}

file: [头像文件]
```

---

## 四、系统监控接口

### 4.1 登录日志

**基础路径：** `/monitor/logininfor`

#### 获取登录日志列表

```http
GET /monitor/logininfor/list?pageNum=1&pageSize=10&ipaddr=&userName=&status=
Authorization: Bearer {token}
```

#### 删除登录日志

```http
DELETE /monitor/logininfor/{infoIds}
Authorization: Bearer {token}
```

#### 清空登录日志

```http
DELETE /monitor/logininfor/clean
Authorization: Bearer {token}
```

#### 解锁账户

```http
POST /monitor/logininfor/unlock
Content-Type: application/json
Authorization: Bearer {token}

{
  "userName": "admin"
}
```

### 4.2 操作日志

**基础路径：** `/monitor/operlog`

#### 获取操作日志列表

```http
GET /monitor/operlog/list?pageNum=1&pageSize=10&title=&businessType=&status=
Authorization: Bearer {token}
```

#### 获取操作日志详情

```http
GET /monitor/operlog/{operId}
Authorization: Bearer {token}
```

#### 删除操作日志

```http
DELETE /monitor/operlog/{operIds}
Authorization: Bearer {token}
```

#### 清空操作日志

```http
DELETE /monitor/operlog/clean
Authorization: Bearer {token}
```

### 4.3 在线用户

**基础路径：** `/monitor/online`

#### 获取在线用户列表

```http
GET /monitor/online/list?ipaddr=&userName=
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "tokenId": "xxx-xxx-xxx",
      "userName": "admin",
      "ipaddr": "192.168.1.1",
      "loginLocation": "本地",
      "browser": "Chrome",
      "os": "Windows",
      "status": "online",
      "loginTime": "2024-01-01 00:00:00"
    }
  ]
}
```

#### 强退用户

```http
DELETE /monitor/online/{tokenId}
Authorization: Bearer {token}
```

### 4.4 定时任务

**基础路径：** `/monitor/job`

#### 获取任务列表

```http
GET /monitor/job/list?pageNum=1&pageSize=10&jobName=&jobGroup=&status=
Authorization: Bearer {token}
```

#### 获取任务详情

```http
GET /monitor/job/{jobId}
Authorization: Bearer {token}
```

#### 新增任务

```http
POST /monitor/job
Content-Type: application/json
Authorization: Bearer {token}

{
  "jobName": "测试任务",
  "jobGroup": "default",
  "invokeTarget": "com.ruoyi.quartz.task.TestTask.test()",
  "cronExpression": "0/5 * * * * ?",
  "misfirePolicy": "3",
  "concurrent": "1",
  "status": "0"
}
```

#### 修改任务

```http
PUT /monitor/job
Content-Type: application/json
Authorization: Bearer {token}

{
  "jobId": 1,
  "jobName": "测试任务修改",
  "jobGroup": "default",
  "invokeTarget": "com.ruoyi.quartz.task.TestTask.test()",
  "cronExpression": "0/10 * * * * ?",
  "misfirePolicy": "3",
  "concurrent": "1",
  "status": "0"
}
```

#### 删除任务

```http
DELETE /monitor/job/{jobIds}
Authorization: Bearer {token}
```

#### 修改任务状态

```http
PUT /monitor/job/changeStatus
Content-Type: application/json
Authorization: Bearer {token}

{
  "jobId": 1,
  "status": "1"
}
```

#### 执行任务

```http
PUT /monitor/job/{jobIds}/run
Authorization: Bearer {token}
```

#### 获取任务执行日志

```http
GET /monitor/job/log/list?pageNum=1&pageSize=10&jobName=&jobGroup=&status=
Authorization: Bearer {token}
```

### 4.5 缓存监控

**基础路径：** `/monitor/cache`

#### 获取缓存信息

```http
GET /monitor/cache
Authorization: Bearer {token}
```

#### 获取缓存名称列表

```http
GET /monitor/cache/getNames
Authorization: Bearer {token}
```

#### 获取键名列表

```http
GET /monitor/cache/getKeys/{cacheName}
Authorization: Bearer {token}
```

#### 获取缓存值

```http
GET /monitor/cache/getValue/{cacheName}/{cacheKey}
Authorization: Bearer {token}
```

#### 清理缓存

```http
DELETE /monitor/cache/clearCacheName/{cacheName}
Authorization: Bearer {token}
```

#### 清理全部缓存

```http
DELETE /monitor/cache/clearCacheAll
Authorization: Bearer {token}
```

### 4.6 服务器监控

**基础路径：** `/monitor/server`

#### 获取服务器信息

```http
GET /monitor/server
Authorization: Bearer {token}
```

**响应：**
```json
{
  "code": 200,
  "msg": "查询成功",
  "cpu": {
    "cpuNum": 4,
    "used": 50.0,
    "sys": 20.0,
    "wait": 5.0
  },
  "mem": {
    "total": "16GB",
    "used": "8GB",
    "free": "8GB",
    "usage": 50.0
  },
  "sys": {
    "osName": "Linux",
    "osArch": "x86_64",
    "userDir": "/app"
  },
  "jvm": {
    "total": "4GB",
    "max": "8GB",
    "used": "2GB",
    "free": "2GB"
  },
  "sysFiles": [
    {
      "dirName": "/",
      "sysTypeName": "ext4",
      "typeName": "root",
      "total": "100GB",
      "used": "50GB",
      "free": "50GB",
      "usage": 50.0
    }
  ]
}
```

---

## 五、系统工具接口

### 5.1 代码生成

**基础路径：** `/tool/gen`

#### 获取生成表列表

```http
GET /tool/gen/list?pageNum=1&pageSize=10&tableName=&tableComment=
Authorization: Bearer {token}
```

#### 获取生成表详情

```http
GET /tool/gen/{tableId}
Authorization: Bearer {token}
```

#### 导入表结构

```http
POST /tool/gen/importTable
Content-Type: application/json
Authorization: Bearer {token}

{
  "tables": "sys_user,sys_role",
  "dbType": "mysql"
}
```

#### 修改生成配置

```http
PUT /tool/gen/editTable
Content-Type: application/json
Authorization: Bearer {token}

{
  "tableId": 1,
  "tableName": "sys_test",
  "tableComment": "测试表",
  "className": "SysTest",
  "functionAuthor": "ruoyi",
  "columns": [
    {
      "columnId": 1,
      "columnName": "test_id",
      "columnComment": "测试 ID",
      "columnType": "bigint",
      "javaType": "Long",
      "javaField": "testId",
      "isPk": "1",
      "isIncrement": "1"
    }
  ]
}
```

#### 删除生成表

```http
DELETE /tool/gen/{tableIds}
Authorization: Bearer {token}
```

#### 预览生成代码

```http
GET /tool/gen/preview?tableId=1
Authorization: Bearer {token}
```

#### 生成代码下载

```http
GET /tool/gen/download/{tableName}
Authorization: Bearer {token}
```

**响应：** 文件下载（zip 格式）

#### 批量生成代码

```http
GET /tool/gen/batchGenCode?tables=sys_user,sys_role
Authorization: Bearer {token}
```

**响应：** 文件下载（zip 格式）

### 5.2 Swagger 接口

**基础路径：** `/tool/swagger`

#### 访问 Swagger 文档

```http
GET /tool/swagger
```

**响应：** Swagger UI 页面

---

## 六、错误码说明

### 6.1 通用错误码

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权，需要登录 |
| 403 | 拒绝访问，权限不足 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |

### 6.2 业务错误码

| 错误码 | 说明 |
|--------|------|
| 400001 | 用户名已存在 |
| 400002 | 密码错误 |
| 400003 | 验证码错误 |
| 400004 | 验证码过期 |
| 400005 | 用户已被锁定 |
| 400006 | 用户已被禁用 |

---

## 七、接口调用示例

### 7.1 cURL 示例

#### 登录

```bash
curl -X POST http://localhost:8080/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "code": "1234",
    "uuid": "xxx-xxx-xxx"
  }'
```

#### 获取用户列表

```bash
curl -X GET "http://localhost:8080/system/user/list?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 7.2 JavaScript 示例

```javascript
// 登录
const login = async () => {
  const response = await fetch('/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      username: 'admin',
      password: 'admin123',
      code: '1234',
      uuid: 'xxx-xxx-xxx'
    })
  });
  const data = await response.json();
  localStorage.setItem('token', data.token);
};

// 获取用户列表
const getUserList = async () => {
  const token = localStorage.getItem('token');
  const response = await fetch('/system/user/list?pageNum=1&pageSize=10', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  const data = await response.json();
  return data;
};
```

---

**文档版本：** 1.0  
**维护者：** 开发团队  
**最后更新：** 2026-03-12
