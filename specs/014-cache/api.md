# 014-cache - API 接口

## 基础信息

- **基础路径**: `/monitor/cache`
- **权限标识**: `monitor:cache:list`
- **数据格式**: JSON

## 接口列表

### 1. 获取缓存监控信息

获取 Redis 缓存的详细运行信息，包括服务器信息、内存使用、命令统计等。

**请求：**
```http
GET /monitor/cache
```

**权限：** `monitor:cache:list`

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "info": {
      "redis_version": "6.2.6",
      "redis_mode": "standalone",
      "tcp_port": "6379",
      "connected_clients": "10",
      "uptime_in_days": "15",
      "used_memory_human": "1.5G",
      "used_cpu_user_children": "0.25",
      "maxmemory_human": "2.0G",
      "aof_enabled": "0",
      "rdb_last_bgsave_status": "ok",
      "instantaneous_input_kbps": "128.5",
      "instantaneous_output_kbps": "256.3"
    },
    "dbSize": 1024,
    "commandStats": [
      { "name": "get", "value": "10000" },
      { "name": "set", "value": "5000" },
      { "name": "del", "value": "100" }
    ]
  }
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| info | Object | Redis 服务器信息 |
| info.redis_version | String | Redis 版本 |
| info.redis_mode | String | 运行模式（standalone/cluster） |
| info.tcp_port | String | 端口号 |
| info.connected_clients | String | 客户端连接数 |
| info.uptime_in_days | String | 运行天数 |
| info.used_memory_human | String | 使用内存 |
| info.used_cpu_user_children | String | CPU 使用率 |
| info.maxmemory_human | String | 最大内存配置 |
| info.aof_enabled | String | AOF 状态（0/1） |
| info.rdb_last_bgsave_status | String | RDB 备份状态 |
| info.instantaneous_input_kbps | String | 网络入口速率 |
| info.instantaneous_output_kbps | String | 网络出口速率 |
| dbSize | Object | 数据库键数量 |
| commandStats | Array | 命令统计列表 |

---

### 2. 获取缓存名称列表

获取所有预定义的缓存命名空间列表。

**请求：**
```http
GET /monitor/cache/getNames
```

**权限：** `monitor:cache:list`

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": [
    {
      "cacheName": "login_tokens:",
      "remark": "用户信息"
    },
    {
      "cacheName": "sys_config:",
      "remark": "配置信息"
    },
    {
      "cacheName": "sys_dict:",
      "remark": "数据字典"
    },
    {
      "cacheName": "captcha_codes:",
      "remark": "验证码"
    },
    {
      "cacheName": "repeat_submit:",
      "remark": "防重提交"
    },
    {
      "cacheName": "rate_limit:",
      "remark": "限流处理"
    },
    {
      "cacheName": "pwd_err_cnt:",
      "remark": "密码错误次数"
    }
  ]
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| cacheName | String | 缓存名称（含冒号后缀） |
| remark | String | 缓存备注说明 |

---

### 3. 获取缓存键名列表

根据缓存名称查询所有匹配的键名。

**请求：**
```http
GET /monitor/cache/getKeys/{cacheName}
```

**权限：** `monitor:cache:list`

**路径参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cacheName | String | 是 | 缓存名称（如：login_tokens:） |

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": [
    "login_tokens:abc123",
    "login_tokens:def456",
    "login_tokens:ghi789"
  ]
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| data | Array<String> | 缓存键名列表（已排序） |

**注意：** 返回结果按字母顺序排序（TreeSet）

---

### 4. 获取缓存内容

根据缓存名称和键名查询具体的缓存值。

**请求：**
```http
GET /monitor/cache/getValue/{cacheName}/{cacheKey}
```

**权限：** `monitor:cache:list`

**路径参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cacheName | String | 是 | 缓存名称 |
| cacheKey | String | 是 | 缓存键名 |

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "cacheName": "login_tokens",
    "cacheKey": "abc123",
    "cacheValue": "{\"userId\":1,\"username\":\"admin\"}"
  }
}
```

**字段说明：**

| 字段 | 类型 | 说明 |
|------|------|------|
| cacheName | String | 缓存名称（不含冒号） |
| cacheKey | String | 缓存键名（不含前缀） |
| cacheValue | String | 缓存内容 |

---

### 5. 清理指定名称的缓存

删除指定命名空间下的所有缓存键。

**请求：**
```http
DELETE /monitor/cache/clearCacheName/{cacheName}
```

**权限：** `monitor:cache:list`

**路径参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cacheName | String | 是 | 缓存名称 |

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**影响范围：** 删除所有匹配 `{cacheName}*` 模式的键

---

### 6. 清理指定键名的缓存

删除指定的单个缓存键。

**请求：**
```http
DELETE /monitor/cache/clearCacheKey/{cacheKey}
```

**权限：** `monitor:cache:list`

**路径参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| cacheKey | String | 是 | 缓存键名（完整键名） |

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

---

### 7. 清理全部缓存

删除所有缓存键。

**请求：**
```http
DELETE /monitor/cache/clearCacheAll
```

**权限：** `monitor:cache:list`

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**警告：** 此操作会删除所有缓存数据，请谨慎使用！

## 错误响应

### 403 权限不足

```json
{
  "code": 403,
  "msg": "没有操作权限"
}
```

### 500 服务器错误

```json
{
  "code": 500,
  "msg": "系统错误",
  "error": "详细错误信息"
}
```

## 前端 API 封装

### 文件位置
`ruoyi-ui/src/api/monitor/cache.js`

### 导出函数

```javascript
// 查询缓存详细
export function getCache()

// 查询缓存名称列表
export function listCacheName()

// 查询缓存键名列表
export function listCacheKey(cacheName)

// 查询缓存内容
export function getCacheValue(cacheName, cacheKey)

// 清理指定名称缓存
export function clearCacheName(cacheName)

// 清理指定键名缓存
export function clearCacheKey(cacheKey)

// 清理全部缓存
export function clearCacheAll()
```

## 使用示例

### Vue 组件调用

```javascript
import { getCache, listCacheName, clearCacheKey } from "@/api/monitor/cache"

// 获取缓存监控信息
getCache().then(response => {
  this.cache = response.data
})

// 获取缓存名称列表
listCacheName().then(response => {
  this.cacheNames = response.data
})

// 清理缓存
clearCacheKey('login_tokens:abc123').then(response => {
  this.$modal.msgSuccess("清理成功")
})
```
