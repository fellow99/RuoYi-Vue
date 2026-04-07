# 015-server - API 接口

## 基础信息

- **基础路径**: `/monitor/server`
- **权限标识**: `monitor:server:list`
- **数据格式**: JSON
- **请求方法**: GET

## 接口列表

### 1. 获取服务器信息

获取服务器的完整监控信息，包括 CPU、内存、JVM、系统和磁盘信息。

**请求：**
```http
GET /monitor/server
```

**权限：** `monitor:server:list`

**请求参数：** 无

**响应：**
```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "cpu": {
      "cpuNum": 8,
      "total": 100.0,
      "sys": 15.5,
      "used": 25.3,
      "wait": 2.1,
      "free": 57.1
    },
    "mem": {
      "total": 16.0,
      "used": 8.5,
      "free": 7.5,
      "usage": 53.13
    },
    "jvm": {
      "total": 2048.0,
      "max": 4096.0,
      "free": 1024.0,
      "used": 1024.0,
      "usage": 50.0,
      "version": "1.8.0_291",
      "home": "/usr/lib/jvm/java-8-openjdk",
      "name": "OpenJDK 64-Bit Server VM",
      "startTime": "2024-01-15 08:30:00",
      "runTime": "15 天 10 小时 30 分钟",
      "inputArgs": "[-Xms512m, -Xmx4096m]"
    },
    "sys": {
      "computerName": "server-01",
      "computerIp": "192.168.1.100",
      "osName": "Linux",
      "osArch": "amd64",
      "userDir": "/opt/ruoyi"
    },
    "sysFiles": [
      {
        "dirName": "/",
        "sysTypeName": "ext4",
        "typeName": "ext4",
        "total": "500.0 GB",
        "free": "200.0 GB",
        "used": "300.0 GB",
        "usage": 60.0
      },
      {
        "dirName": "/data",
        "sysTypeName": "ext4",
        "typeName": "ext4",
        "total": "1000.0 GB",
        "free": "500.0 GB",
        "used": "500.0 GB",
        "usage": 50.0
      }
    ]
  }
}
```

**字段说明：**

#### CPU 信息 (cpu)

| 字段 | 类型 | 说明 |
|------|------|------|
| cpuNum | int | CPU 核心数（逻辑处理器） |
| total | double | CPU 总使用率 (%) |
| sys | double | CPU 系统使用率 (%) |
| used | double | CPU 用户使用率 (%) |
| wait | double | CPU 等待率 (%) |
| free | double | CPU 空闲率 (%) |

#### 内存信息 (mem)

| 字段 | 类型 | 单位 | 说明 |
|------|------|------|------|
| total | double | GB | 内存总量 |
| used | double | GB | 已用内存 |
| free | double | GB | 剩余内存 |
| usage | double | % | 使用率 |

#### JVM 信息 (jvm)

| 字段 | 类型 | 单位 | 说明 |
|------|------|------|------|
| total | double | MB | JVM 总内存 |
| max | double | MB | JVM 最大可用内存 |
| free | double | MB | JVM 空闲内存 |
| used | double | MB | JVM 已用内存 |
| usage | double | % | JVM 使用率 |
| version | String | - | JDK 版本 |
| home | String | - | JDK 安装路径 |
| name | String | - | JVM 名称 |
| startTime | String | - | 启动时间 |
| runTime | String | - | 运行时长 |
| inputArgs | String | - | 运行参数 |

#### 系统信息 (sys)

| 字段 | 类型 | 说明 |
|------|------|------|
| computerName | String | 服务器名称 |
| computerIp | String | 服务器 IP 地址 |
| osName | String | 操作系统名称 |
| osArch | String | 系统架构 |
| userDir | String | 项目路径 |

#### 磁盘信息 (sysFiles)

| 字段 | 类型 | 说明 |
|------|------|------|
| dirName | String | 盘符路径（挂载点） |
| sysTypeName | String | 文件系统类型 |
| typeName | String | 盘符类型 |
| total | String | 总大小（人类可读） |
| free | String | 剩余大小（人类可读） |
| used | String | 已用大小（人类可读） |
| usage | double | 使用率 (%) |

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

### 500 系统信息采集失败

```json
{
  "code": 500,
  "msg": "获取服务器信息失败",
  "error": "OSHI 初始化失败"
}
```

## 前端 API 封装

### 文件位置
`ruoyi-ui/src/api/monitor/server.js`

### 导出函数

```javascript
import request from '@/utils/request'

// 获取服务信息
export function getServer() {
  return request({
    url: '/monitor/server',
    method: 'get'
  })
}
```

## 使用示例

### Vue 组件调用

```javascript
import { getServer } from "@/api/monitor/server"

export default {
  name: "Server",
  data() {
    return {
      server: []
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询服务器信息 */
    getList() {
      getServer().then(response => {
        this.server = response.data
        this.$modal.closeLoading()
      })
    }
  }
}
```

### 模板渲染

```vue
<template>
  <div class="app-container">
    <!-- CPU 信息 -->
    <el-card>
      <div slot="header"><span><i class="el-icon-cpu"></i> CPU</span></div>
      <table>
        <tr>
          <td>核心数</td>
          <td v-if="server.cpu">{{ server.cpu.cpuNum }}</td>
        </tr>
        <tr>
          <td>用户使用率</td>
          <td v-if="server.cpu">{{ server.cpu.used }}%</td>
        </tr>
      </table>
    </el-card>

    <!-- 内存信息 -->
    <el-card>
      <div slot="header"><span><i class="el-icon-tickets"></i> 内存</span></div>
      <table>
        <tr>
          <td>总内存</td>
          <td v-if="server.mem">{{ server.mem.total }}G</td>
        </tr>
        <tr>
          <td>使用率</td>
          <td v-if="server.mem" 
              :class="{'text-danger': server.mem.usage > 80}">
            {{ server.mem.usage }}%
          </td>
        </tr>
      </table>
    </el-card>

    <!-- 磁盘信息 -->
    <el-card>
      <div slot="header">
        <span><i class="el-icon-receiving"></i> 磁盘状态</span>
      </div>
      <table>
        <thead>
          <tr>
            <th>盘符路径</th>
            <th>总大小</th>
            <th>已用大小</th>
            <th>已用百分比</th>
          </tr>
        </thead>
        <tbody v-if="server.sysFiles">
          <tr v-for="(sysFile, index) in server.sysFiles" :key="index">
            <td>{{ sysFile.dirName }}</td>
            <td>{{ sysFile.total }}</td>
            <td>{{ sysFile.used }}</td>
            <td :class="{'text-danger': sysFile.usage > 80}">
              {{ sysFile.usage }}%
            </td>
          </tr>
        </tbody>
      </table>
    </el-card>
  </div>
</template>
```

## 性能优化建议

### 1. 请求频率控制
- 建议刷新间隔 ≥ 5 秒
- 避免频繁请求影响系统性能

### 2. 数据采集优化
- CPU 采集需要等待 1 秒，可考虑异步处理
- 磁盘信息可缓存，变化频率低

### 3. 响应大小优化
- 仅返回必要字段
- 大数值使用人类可读格式

## 安全考虑

1. **权限验证**: 所有请求必须通过权限验证
2. **信息脱敏**: 敏感信息（如运行参数）可配置脱敏
3. **访问控制**: 限制访问 IP 范围
4. **日志记录**: 记录所有访问日志
