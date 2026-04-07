# 定时任务 API 接口 (013-job)

**模块编号：** 013  
**最后更新：** 2026-03-12

---

## 一、接口概述

### 1.1 基础信息

| 项目 | 说明 |
|------|------|
| 基础路径 | `/monitor/job` |
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

### 2.1 查询定时任务列表

**接口描述：** 分页查询定时任务列表

**请求定义：**
```
GET /monitor/job/list
```

**权限标识：** `monitor:job:list`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| pageNum | Integer | 否 | 页码，默认 1 | 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 | 10 |
| jobName | String | 否 | 任务名称（模糊） | 测试任务 |
| jobGroup | String | 否 | 任务组名 | DEFAULT |
| status | String | 否 | 任务状态 | 0 |
| invokeTarget | String | 否 | 调用目标（模糊） | ryTask |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |
| rows | Array | 任务列表 |
| rows[].jobId | Long | 任务 ID |
| rows[].jobName | String | 任务名称 |
| rows[].jobGroup | String | 任务组名 |
| rows[].invokeTarget | String | 调用目标 |
| rows[].cronExpression | String | Cron 表达式 |
| rows[].status | String | 任务状态 |
| rows[].concurrent | String | 并发策略 |
| rows[].misfirePolicy | String | 错过策略 |
| total | Integer | 总记录数 |

---

### 2.2 查询任务详细

**接口描述：** 查询定时任务详细信息

**请求定义：**
```
GET /monitor/job/{jobId}
```

**权限标识：** `monitor:job:query`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| jobId | Long | 是 | 任务 ID（路径参数） | 1 |

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |
| data | Object | 任务详细信息 |

---

### 2.3 新增定时任务

**接口描述：** 新增定时任务

**请求定义：**
```
POST /monitor/job
```

**权限标识：** `monitor:job:add`

**请求体：**

```json
{
  "jobName": "测试任务",
  "jobGroup": "DEFAULT",
  "invokeTarget": "ryTask.ryParams('test')",
  "cronExpression": "0/5 * * * * ?",
  "misfirePolicy": "3",
  "concurrent": "1",
  "status": "1",
  "remark": "备注信息"
}
```

**响应参数：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |

---

### 2.4 修改定时任务

**接口描述：** 修改定时任务

**请求定义：**
```
PUT /monitor/job
```

**权限标识：** `monitor:job:edit`

**请求体：** 同新增任务（包含 jobId）

---

### 2.5 删除定时任务

**接口描述：** 批量删除定时任务

**请求定义：**
```
DELETE /monitor/job/{jobIds}
```

**权限标识：** `monitor:job:remove`

**请求参数：**

| 参数名 | 类型 | 必填 | 说明 | 示例 |
|--------|------|------|------|------|
| jobIds | Long[] | 是 | 任务 ID 数组 | 1,2,3 |

---

### 2.6 修改任务状态

**接口描述：** 修改定时任务状态（启动/暂停）

**请求定义：**
```
PUT /monitor/job/changeStatus
```

**权限标识：** `monitor:job:changeStatus`

**请求体：**

```json
{
  "jobId": 1,
  "status": "0"
}
```

---

### 2.7 立即执行任务

**接口描述：** 立即执行一次定时任务

**请求定义：**
```
PUT /monitor/job/run
```

**权限标识：** `monitor:job:changeStatus`

**请求体：**

```json
{
  "jobId": 1,
  "jobGroup": "DEFAULT"
}
```

**响应：**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| code | Integer | 状态码 |
| msg | String | 提示信息 |
| 200 | - | 执行成功 |
| 500 | - | 任务不存在或已过期 |

---

### 2.8 导出定时任务

**接口描述：** 导出定时任务为 Excel 文件

**请求定义：**
```
POST /monitor/job/export
```

**权限标识：** `monitor:job:export`

**请求参数：** 同查询列表参数

**响应格式：** Excel 文件下载

---

## 三、错误码说明

### 3.1 通用错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 200 | 成功 | - |
| 401 | 未授权 | 检查 Token |
| 403 | 无权限 | 检查权限 |
| 500 | 服务器错误 | 联系管理员 |

### 3.2 业务错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 500 | Cron 表达式不正确 | 检查表达式格式 |
| 500 | 目标字符串不允许 rmi 调用 | 移除 RMI 调用 |
| 500 | 目标字符串不允许 ldap(s) 调用 | 移除 LDAP 调用 |
| 500 | 目标字符串不允许 http(s) 调用 | 移除 HTTP 调用 |
| 500 | 目标字符串存在违规 | 检查调用目标 |
| 500 | 目标字符串不在白名单内 | 添加到白名单 |

---

## 四、前端 API 封装

### 4.1 API 文件路径

`ruoyi-ui/src/api/monitor/job.js`

### 4.2 封装方法

```javascript
import request from '@/utils/request'

// 查询定时任务列表
export function listJob(query) {
  return request({
    url: '/monitor/job/list',
    method: 'get',
    params: query
  })
}

// 查询定时任务详细
export function getJob(jobId) {
  return request({
    url: '/monitor/job/' + jobId,
    method: 'get'
  })
}

// 新增定时任务
export function addJob(data) {
  return request({
    url: '/monitor/job',
    method: 'post',
    data: data
  })
}

// 修改定时任务
export function updateJob(data) {
  return request({
    url: '/monitor/job',
    method: 'put',
    data: data
  })
}

// 删除定时任务
export function delJob(jobId) {
  return request({
    url: '/monitor/job/' + jobId,
    method: 'delete'
  })
}

// 任务状态修改
export function changeJobStatus(jobId, status) {
  return request({
    url: '/monitor/job/changeStatus',
    method: 'put',
    data: { jobId, status }
  })
}

// 定时任务立即执行一次
export function runJob(jobId, jobGroup) {
  return request({
    url: '/monitor/job/run',
    method: 'put',
    data: { jobId, jobGroup }
  })
}
```

---

## 五、安全说明

### 5.1 调用目标安全
- 禁止 RMI、LDAP、HTTP(S) 调用
- 调用目标必须在白名单内
- 防止任意代码执行

### 5.2 Cron 表达式校验
- 保存前校验表达式有效性
- 无效表达式拒绝保存

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
