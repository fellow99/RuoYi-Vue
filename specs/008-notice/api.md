# 008-Notice 通知公告模块 API 接口

## 1. 通知公告 API

### 1.1 查询通知公告列表

**接口路径：** `GET /system/notice/list`

**权限标识：** `system:notice:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| noticeTitle | String | 否 | 公告标题（模糊查询） |
| noticeType | String | 否 | 公告类型（1 通知 2 公告） |
| status | String | 否 | 公告状态（0 正常 1 关闭） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "noticeId": 1,
      "noticeTitle": "温馨提醒：2018-07-01 若依新版本发布啦",
      "noticeType": "2",
      "noticeContent": "新版本内容...",
      "status": "0",
      "createBy": "admin",
      "createTime": "2024-01-01 00:00:00",
      "remark": "管理员"
    }
  ],
  "total": 2
}
```

### 1.2 查询通知公告详情

**接口路径：** `GET /system/notice/{noticeId}`

**权限标识：** `system:notice:query`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| noticeId | Long | 公告 ID |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "noticeId": 1,
    "noticeTitle": "温馨提醒：2018-07-01 若依新版本发布啦",
    "noticeType": "2",
    "noticeContent": "<p>新版本内容...</p>",
    "status": "0",
    "createBy": "admin",
    "createTime": "2024-01-01 00:00:00",
    "remark": "管理员"
  }
}
```

### 1.3 新增通知公告

**接口路径：** `POST /system/notice`

**权限标识：** `system:notice:add`

**请求体：**
```json
{
  "noticeTitle": "系统维护通知",
  "noticeType": "1",
  "noticeContent": "<p>尊敬的用户：</p><p>系统将于今晚 23:00 进行维护...</p>",
  "status": "0",
  "remark": "管理员"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.4 修改通知公告

**接口路径：** `PUT /system/notice`

**权限标识：** `system:notice:edit`

**请求体：**
```json
{
  "noticeId": 1,
  "noticeTitle": "温馨提醒：2018-07-01 若依新版本发布啦",
  "noticeType": "2",
  "noticeContent": "<p>新版本内容...</p>",
  "status": "0",
  "remark": "管理员"
}
```

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

### 1.5 删除通知公告

**接口路径：** `DELETE /system/notice/{noticeIds}`

**权限标识：** `system:notice:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| noticeIds | Long[] | 公告 ID 数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

## 2. 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 操作成功 |
| 401 | 认证失败，未登录 |
| 403 | 权限不足 |
| 500 | 服务器内部错误 |

## 3. 请求参数说明

### 3.1 公告类型
| 值 | 说明 |
|----|------|
| 1 | 通知 |
| 2 | 公告 |

### 3.2 公告状态
| 值 | 说明 |
|----|------|
| 0 | 正常 |
| 1 | 关闭 |

## 4. 使用示例

### 4.1 前端查询公告列表
```javascript
import { listNotice } from "@/api/system/notice"

// 查询公告列表
listNotice({
  pageNum: 1,
  pageSize: 10,
  noticeType: '1'  // 只查询通知
}).then(response => {
  const notices = response.rows
  const total = response.total
})
```

### 4.2 前端查询公告详情
```javascript
import { getNotice } from "@/api/system/notice"

// 查询公告详情
getNotice(noticeId).then(response => {
  const notice = response.data
  // 显示公告内容
})
```

### 4.3 前端新增公告
```javascript
import { addNotice } from "@/api/system/notice"

// 新增公告
addNotice({
  noticeTitle: '系统维护通知',
  noticeType: '1',
  noticeContent: '<p>系统将于今晚 23:00 进行维护...</p>',
  status: '0'
}).then(() => {
  this.$modal.msgSuccess("新增成功")
})
```

### 4.4 前端删除公告
```javascript
import { delNotice } from "@/api/system/notice"

// 删除公告
delNotice(noticeId).then(() => {
  this.$modal.msgSuccess("删除成功")
})
```

## 5. 注意事项

1. 公告内容支持 HTML 格式，需要注意 XSS 防护
2. 公告标题长度限制为 50 字符
3. 批量删除时传入公告 ID 数组
4. 公告类型和状态使用字典数据展示
