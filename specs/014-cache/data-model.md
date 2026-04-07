# 014-cache - 数据模型

## 实体关系图

```
┌─────────────────┐
│   SysCache      │
├─────────────────┤
│ - cacheName     │
│ - cacheKey      │
│ - cacheValue    │
│ - remark        │
└─────────────────┘
```

## 数据表/集合定义

### SysCache（缓存信息）

**说明：** 缓存信息传输对象，用于在前后端之间传递缓存数据。

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| cacheName | String | 否 | "" | 缓存名称（不含冒号前缀） |
| cacheKey | String | 否 | "" | 缓存键名（不含命名空间前缀） |
| cacheValue | String | 否 | "" | 缓存内容（字符串形式） |
| remark | String | 否 | "" | 缓存备注说明 |

**构造函数：**

1. `SysCache()` - 无参构造函数
2. `SysCache(cacheName, remark)` - 创建缓存命名空间信息
3. `SysCache(cacheName, cacheKey, cacheValue)` - 创建完整缓存信息

**业务规则：**
- cacheName 在构造时会自动去除冒号后缀
- cacheKey 在构造时会自动去除命名空间前缀
- cacheValue 保持原始字符串格式

## Redis 数据结构

### Key 命名规范

所有缓存键遵循以下命名规范：
```
{namespace}:{business_key}
```

**预定义命名空间：**

| 命名空间 | 完整前缀 | 用途 |
|---------|---------|------|
| login_tokens | login_tokens: | 用户登录令牌 |
| sys_config | sys_config: | 系统配置参数 |
| sys_dict | sys_dict: | 数据字典 |
| captcha_codes | captcha_codes: | 验证码 |
| repeat_submit | repeat_submit: | 防重提交令牌 |
| rate_limit | rate_limit: | 限流计数器 |
| pwd_err_cnt | pwd_err_cnt: | 密码错误计数 |

### Value 类型

| 命名空间 | 值类型 | 序列化方式 |
|---------|-------|-----------|
| login_tokens | String | JSON 字符串 |
| sys_config | String | JSON 字符串 |
| sys_dict | List | JSON 数组 |
| captcha_codes | String | 纯文本 |
| repeat_submit | String | JSON 字符串 |
| rate_limit | Long | 数字字符串 |
| pwd_err_cnt | Integer | 数字字符串 |

## Redis INFO 字段映射

### Server 信息
- `redis_version` → Redis 版本
- `redis_mode` → 运行模式
- `tcp_port` → 端口号
- `uptime_in_days` → 运行天数

### Clients 信息
- `connected_clients` → 客户端连接数

### Memory 信息
- `used_memory_human` → 使用内存
- `maxmemory_human` → 最大内存配置

### CPU 信息
- `used_cpu_user_children` → CPU 使用率

### Persistence 信息
- `aof_enabled` → AOF 状态
- `rdb_last_bgsave_status` → RDB 备份状态

### Stats 信息
- `instantaneous_input_kbps` → 网络入口速率
- `instantaneous_output_kbps` → 网络出口速率

## 命令统计数据结构

```javascript
{
  name: String,    // 命令名称（如：get, set, del）
  value: String    // 调用次数
}
```

## 数据流转

### 缓存监控数据获取流程

```
前端请求
    ↓
CacheController.getInfo()
    ↓
RedisTemplate.execute()
    ↓
Redis INFO 命令
    ↓
Properties 对象
    ↓
Map<String, Object> 结果
    ↓
前端展示
```

### 缓存列表获取流程

```
前端请求
    ↓
CacheController.cache()
    ↓
预定义 caches 列表
    ↓
List<SysCache>
    ↓
前端展示
```

### 缓存键名查询流程

```
前端请求（cacheName）
    ↓
CacheController.getCacheKeys()
    ↓
RedisTemplate.keys()
    ↓
Set<String>
    ↓
TreeSet（排序）
    ↓
前端展示
```

### 缓存内容查询流程

```
前端请求（cacheName, cacheKey）
    ↓
CacheController.getCacheValue()
    ↓
RedisTemplate.opsForValue().get()
    ↓
String value
    ↓
SysCache 对象
    ↓
前端展示
```

## 数据验证规则

1. **cacheName 验证**
   - 不能为空
   - 必须是预定义的命名空间之一

2. **cacheKey 验证**
   - 不能为空
   - 必须符合 Redis key 命名规范

3. **操作权限验证**
   - 所有操作需要 `monitor:cache:list` 权限

## 数据转换规则

### 字节转换

Redis 内存信息使用人类可读格式：
- B → KB → MB → GB
- 保留 1 位小数

### 时间转换

运行时间转换：
- 秒 → 天（uptime_in_days）

### 百分比转换

CPU 使用率计算：
- 原始值 × 100
- 保留 2 位小数
