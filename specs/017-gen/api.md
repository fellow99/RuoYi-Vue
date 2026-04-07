# 017-代码生成 - API 接口

**模块编号：** 017  
**模块名称：** 代码生成  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**基础路径：** `/tool/gen`  
**认证方式：** JWT Token  
**数据格式：** JSON

---

## 二、接口清单

| 接口名称 | 请求方式 | 接口路径 | 权限标识 | 说明 |
|---------|---------|---------|---------|------|
| 代码生成列表 | GET | `/tool/gen/list` | `tool:gen:list` | 分页查询已导入的代码生成配置 |
| 数据库表列表 | GET | `/tool/gen/db/list` | `tool:gen:list` | 查询数据库表列表 |
| 代码生成详情 | GET | `/tool/gen/{tableId}` | `tool:gen:query` | 获取代码生成配置详情 |
| 表字段列表 | GET | `/tool/gen/column/{tableId}` | `tool:gen:list` | 获取表的字段配置列表 |
| 导入表结构 | POST | `/tool/gen/importTable` | `tool:gen:import` | 从数据库导入表结构 |
| 创建表结构 | POST | `/tool/gen/createTable` | admin 角色 | 通过 SQL 创建表并导入 |
| 修改配置 | PUT | `/tool/gen` | `tool:gen:edit` | 修改代码生成配置 |
| 删除配置 | DELETE | `/tool/gen/{tableIds}` | `tool:gen:remove` | 删除代码生成配置 |
| 预览代码 | GET | `/tool/gen/preview/{tableId}` | `tool:gen:preview` | 预览生成的代码 |
| 下载代码 | GET | `/tool/gen/download/{tableName}` | `tool:gen:code` | 下载生成的 ZIP 包 |
| 本地生成 | GET | `/tool/gen/genCode/{tableName}` | `tool:gen:code` | 生成代码到本地路径 |
| 同步数据库 | GET | `/tool/gen/synchDb/{tableName}` | `tool:gen:edit` | 同步数据库表结构 |
| 批量生成 | GET | `/tool/gen/batchGenCode` | `tool:gen:code` | 批量生成代码并下载 |

---

## 三、接口详细定义

### 3.1 代码生成列表

**接口：** `GET /tool/gen/list`

**权限：** `tool:gen:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableName | String | 否 | 表名称（模糊匹配） |
| tableComment | String | 否 | 表描述（模糊匹配） |
| pageNum | Integer | 否 | 页码（默认 1） |
| pageSize | Integer | 否 | 每页数量（默认 10） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "tableId": 1,
      "tableName": "sys_user",
      "tableComment": "用户信息表",
      "className": "SysUser",
      "tplCategory": "crud",
      "tplWebType": "element-ui",
      "packageName": "com.ruoyi.system",
      "moduleName": "system",
      "businessName": "user",
      "functionName": "用户管理",
      "functionAuthor": "admin",
      "createTime": "2026-03-12 10:00:00"
    }
  ],
  "total": 1
}
```

---

### 3.2 数据库表列表

**接口：** `GET /tool/gen/db/list`

**权限：** `tool:gen:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableName | String | 否 | 表名称（模糊匹配） |
| tableComment | String | 否 | 表描述（模糊匹配） |
| pageNum | Integer | 否 | 页码（默认 1） |
| pageSize | Integer | 否 | 每页数量（默认 10） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "tableName": "test_order",
      "tableComment": "订单表",
      "engine": "InnoDB",
      "charset": "utf8mb4",
      "createTime": "2026-03-12 10:00:00"
    }
  ],
  "total": 1
}
```

---

### 3.3 代码生成详情

**接口：** `GET /tool/gen/{tableId}`

**权限：** `tool:gen:query`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableId | Long | 是 | 表 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "info": {
    "tableId": 1,
    "tableName": "sys_user",
    "tableComment": "用户信息表",
    "className": "SysUser",
    "tplCategory": "crud",
    "tplWebType": "element-ui",
    "packageName": "com.ruoyi.system",
    "moduleName": "system",
    "businessName": "user",
    "functionName": "用户管理",
    "functionAuthor": "admin",
    "genType": "0",
    "options": "{\"treeCode\":\"\",\"treeName\":\"\",\"treeParentCode\":\"\"}"
  },
  "rows": [
    {
      "columnId": 1,
      "tableId": 1,
      "columnName": "user_id",
      "columnComment": "用户 ID",
      "columnType": "bigint(20)",
      "javaType": "Long",
      "javaField": "userId",
      "isPk": "1",
      "isIncrement": "1",
      "isRequired": "0",
      "isInsert": "0",
      "isEdit": "0",
      "isList": "0",
      "isQuery": "0",
      "queryType": "EQ",
      "htmlType": "input",
      "dictType": "",
      "sort": 1
    }
  ],
  "tables": []
}
```

---

### 3.4 表字段列表

**接口：** `GET /tool/gen/column/{tableId}`

**权限：** `tool:gen:list`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableId | Long | 是 | 表 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "查询成功",
  "rows": [
    {
      "columnId": 1,
      "tableId": 1,
      "columnName": "user_id",
      "columnComment": "用户 ID",
      "columnType": "bigint(20)",
      "javaType": "Long",
      "javaField": "userId",
      "isPk": "1",
      "isIncrement": "1",
      "sort": 1
    }
  ],
  "total": 10
}
```

---

### 3.5 导入表结构

**接口：** `POST /tool/gen/importTable`

**权限：** `tool:gen:import`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tables | String | 是 | 表名列表（逗号分隔） |
| tplWebType | String | 是 | 前端模板类型 |

**请求示例：**

```
tables=sys_dept,sys_user
tplWebType=element-ui
```

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.6 创建表结构

**接口：** `POST /tool/gen/createTable`

**权限：** admin 角色

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| sql | String | 是 | CREATE TABLE SQL 语句 |
| tplWebType | String | 是 | 前端模板类型 |

**请求示例：**

```
sql=CREATE TABLE `test_user` (`id` bigint NOT NULL AUTO_INCREMENT, `name` varchar(50) DEFAULT NULL, PRIMARY KEY (`id`));
tplWebType=element-ui
```

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.7 修改配置

**接口：** `PUT /tool/gen`

**权限：** `tool:gen:edit`

**请求体：**

```json
{
  "tableId": 1,
  "tableName": "sys_user",
  "tableComment": "用户信息表",
  "className": "SysUser",
  "tplCategory": "crud",
  "tplWebType": "element-ui",
  "packageName": "com.ruoyi.system",
  "moduleName": "system",
  "businessName": "user",
  "functionName": "用户管理",
  "functionAuthor": "admin",
  "genType": "0",
  "columns": [
    {
      "columnId": 1,
      "columnName": "user_id",
      "columnComment": "用户 ID",
      "javaType": "Long",
      "javaField": "userId",
      "isPk": "1",
      "isIncrement": "1",
      "isRequired": "0",
      "isInsert": "0",
      "isEdit": "0",
      "isList": "0",
      "isQuery": "0",
      "queryType": "EQ",
      "htmlType": "input",
      "dictType": "",
      "sort": 1
    }
  ]
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

### 3.8 删除配置

**接口：** `DELETE /tool/gen/{tableIds}`

**权限：** `tool:gen:remove`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableIds | Long[] | 是 | 表 ID 数组（逗号分隔） |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.9 预览代码

**接口：** `GET /tool/gen/preview/{tableId}`

**权限：** `tool:gen:preview`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableId | Long | 是 | 表 ID |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "template/java/domain.java.vm": "package com.ruoyi.system.domain;\n...",
    "template/java/mapper.java.vm": "package com.ruoyi.system.mapper;\n...",
    "template/vue/api.js.vm": "import request from '@/utils/request'\n...",
    "template/vue/index.vue.vm": "<template>\n..."
  }
}
```

---

### 3.10 下载代码

**接口：** `GET /tool/gen/download/{tableName}`

**权限：** `tool:gen:code`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableName | String | 是 | 表名称 |

**响应：** ZIP 文件下载

---

### 3.11 本地生成

**接口：** `GET /tool/gen/genCode/{tableName}`

**权限：** `tool:gen:code`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableName | String | 是 | 表名称 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**注意：** 需要系统配置 `gen.allowOverwrite=true` 才允许执行

---

### 3.12 同步数据库

**接口：** `GET /tool/gen/synchDb/{tableName}`

**权限：** `tool:gen:edit`

**路径参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tableName | String | 是 | 表名称 |

**响应示例：**

```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 3.13 批量生成

**接口：** `GET /tool/gen/batchGenCode`

**权限：** `tool:gen:code`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 |
|-------|------|------|------|
| tables | String | 是 | 表名列表（逗号分隔） |

**响应：** ZIP 文件下载
