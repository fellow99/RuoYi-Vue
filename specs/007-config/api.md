# 007-Config 参数管理模块 API 接口

## 1. 参数配置 API

### 1.1 查询参数列表

**接口路径：** `GET /system/config/list`

**权限标识：** `system:config:list`

**请求参数：**
| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| configName | String | 否 | 参数名称（模糊查询） |
| configKey | String | 否 | 参数键名（模糊查询） |
| configType | String | 否 | 系统内置（Y 是 N 否） |
| pageNum | Integer | 否 | 页码，默认 1 |
| pageSize | Integer | 否 | 每页数量，默认 10 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "rows": [
    {
      "configId": 1,
      "configName": "主框架页 - 默认皮肤样式名称",
      "configKey": "sys.index.skinName",
      "configValue": "skin-blue",
      "configType": "Y",
      "remark": "蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow",
      "createTime": "2024-01-01 00:00:00"
    }
  ],
  "total": 8
}
```

### 1.2 查询参数详情

**接口路径：** `GET /system/config/{configId}`

**权限标识：** `system:config:query`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| configId | Long | 参数配置 ID |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "configId": 1,
    "configName": "主框架页 - 默认皮肤样式名称",
    "configKey": "sys.index.skinName",
    "configValue": "skin-blue",
    "configType": "Y",
    "remark": "蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow"
  }
}
```

### 1.3 新增参数配置

**接口路径：** `POST /system/config`

**权限标识：** `system:config:add`

**请求体：**
```json
{
  "configName": "测试参数",
  "configKey": "test.param.key",
  "configValue": "test_value",
  "configType": "N",
  "remark": "测试参数配置"
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
  "msg": "新增参数'测试参数'失败，参数键名已存在"
}
```

### 1.4 修改参数配置

**接口路径：** `PUT /system/config`

**权限标识：** `system:config:edit`

**请求体：**
```json
{
  "configId": 1,
  "configName": "主框架页 - 默认皮肤样式名称",
  "configKey": "sys.index.skinName",
  "configValue": "skin-green",
  "configType": "Y",
  "remark": "蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow"
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
  "msg": "修改参数'测试参数'失败，参数键名已存在"
}
```

### 1.5 删除参数配置

**接口路径：** `DELETE /system/config/{configIds}`

**权限标识：** `system:config:remove`

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| configIds | Long[] | 参数配置 ID 数组（支持批量删除） |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功"
}
```

**错误响应（删除内置参数）：**
```json
{
  "code": 500,
  "msg": "内置参数【sys.account.captchaEnabled】不能删除 "
}
```

### 1.6 导出参数数据

**接口路径：** `POST /system/config/export`

**权限标识：** `system:config:export`

**请求参数：** 同查询列表参数

**响应：** Excel 文件下载

### 1.7 根据参数键名查询参数值

**接口路径：** `GET /system/config/configKey/{configKey}`

**权限标识：** 无限制

**路径参数：**
| 参数名 | 类型 | 说明 |
|--------|------|------|
| configKey | String | 参数键名 |

**响应示例：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": "true"
}
```

### 1.8 刷新参数缓存

**接口路径：** `DELETE /system/config/refreshCache`

**权限标识：** `system:config:remove`

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

## 3. 业务错误信息

| 错误信息 | 说明 |
|----------|------|
| 新增参数'xxx'失败，参数键名已存在 | 参数键名重复 |
| 修改参数'xxx'失败，参数键名已存在 | 参数键名重复 |
| 内置参数【xxx】不能删除 | 尝试删除系统内置参数 |

## 4. 使用示例

### 4.1 前端获取验证码开关
```javascript
// 调用接口
getConfigKey('sys.account.captchaEnabled').then(response => {
  const captchaEnabled = response.data === 'true';
  // 根据返回值决定是否显示验证码输入框
});
```

### 4.2 后端获取参数值
```java
// 通过服务层获取
String captchaEnabled = configService.selectConfigByKey("sys.account.captchaEnabled");
boolean enabled = Convert.toBool(captchaEnabled);
```
