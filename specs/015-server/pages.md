# 015-server - 前端页面

## 页面概述

**页面名称**: 服务器监控  
**路由路径**: `/monitor/server`  
**文件路径**: `ruoyi-ui/src/views/monitor/server/index.vue`  
**权限要求**: `monitor:server:list`

## 页面布局

```
┌──────────────────────────────────────────────────────────┐
│  CPU 卡片 (12 列)          │  内存卡片 (12 列)             │
│  ┌────────────────────┐   │  ┌────────────────────┐     │
│  │ 核心数    │ 值      │   │  │ 属性    │ 内存 │ JVM │     │
│  │ 用户使用率│ 值      │   │  │ 总内存  │     │     │     │
│  │ 系统使用率│ 值      │   │  │ 已用内存│     │     │     │
│  │ 当前空闲率│ 值      │   │  │ 剩余内存│     │     │     │
│  └────────────────────┘   │  │ 使用率   │     │     │     │
│                           │  └────────────────────┘     │
├──────────────────────────────────────────────────────────┤
│  服务器信息卡片 (24 列)                                     │
│  ┌──────────────────────────────────────────────────┐   │
│  │ 服务器名称 │            │ 操作系统 │            │   │
│  │ 服务器 IP  │            │ 系统架构 │            │   │
│  └──────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────┤
│  Java 虚拟机信息卡片 (24 列)                                 │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Java 名称   │            │ Java 版本 │            │   │
│  │ 启动时间   │            │ 运行时长 │            │   │
│  │ 安装路径   │                                    │   │
│  │ 项目路径   │                                    │   │
│  │ 运行参数   │                                    │   │
│  └──────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────┤
│  磁盘状态卡片 (24 列)                                       │
│  ┌──────────────────────────────────────────────────┐   │
│  │ 盘符路径 │ 文件系统 │ 类型 │ 总大小 │ 可用 │ 已用 │% │   │
│  │ /        │ ext4     │ ext4 │ 500GB  │ 200  │ 300  │60│   │
│  │ /data    │ ext4     │ ext4 │ 1000GB │ 500  │ 500  │50│   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

## 组件结构

### 卡片列表

1. **CPU 卡片** (12 列)
   - 图标：`el-icon-cpu`
   - 标题：CPU
   - 内容：4 行表格（核心数、用户使用率、系统使用率、当前空闲率）

2. **内存卡片** (12 列)
   - 图标：`el-icon-tickets`
   - 标题：内存
   - 内容：4 行 3 列表格（属性、内存值、JVM 值）
   - 警告样式：使用率 > 80% 时显示红色

3. **服务器信息卡片** (24 列)
   - 图标：`el-icon-monitor`
   - 标题：服务器信息
   - 内容：2 行表格（服务器名称、IP、操作系统、架构）

4. **Java 虚拟机信息卡片** (24 列)
   - 图标：`el-icon-coffee-cup`
   - 标题：Java 虚拟机信息
   - 内容：多行表格（Java 名称、版本、启动时间、运行时长、路径、参数）

5. **磁盘状态卡片** (24 列)
   - 图标：`el-icon-receiving`
   - 标题：磁盘状态
   - 内容：动态表格（遍历 sysFiles 数组）
   - 警告样式：使用率 > 80% 时显示红色

## 数据流

```
created()
  ↓
getList()
  ↓
openLoading() - 显示加载提示
  ↓
getServer() API 调用
  ↓
更新 server 数据
  ↓
closeLoading() - 关闭加载提示
  ↓
页面渲染完成
```

## 状态管理

### 页面状态
```javascript
data() {
  return {
    // 服务器信息
    server: []
  }
}
```

### 数据结构
```javascript
server: {
  cpu: {
    cpuNum: 8,
    used: 25.3,
    sys: 15.5,
    free: 57.1
  },
  mem: {
    total: 16.0,
    used: 8.5,
    free: 7.5,
    usage: 53.13
  },
  jvm: {
    total: 2048.0,
    used: 1024.0,
    free: 1024.0,
    usage: 50.0,
    version: "1.8.0_291",
    home: "/usr/lib/jvm/java-8-openjdk",
    name: "OpenJDK 64-Bit Server VM",
    startTime: "2024-01-15 08:30:00",
    runTime: "15 天 10 小时 30 分钟",
    inputArgs: "[-Xms512m, -Xmx4096m]"
  },
  sys: {
    computerName: "server-01",
    computerIp: "192.168.1.100",
    osName: "Linux",
    osArch: "amd64",
    userDir: "/opt/ruoyi"
  },
  sysFiles: [
    {
      dirName: "/",
      sysTypeName: "ext4",
      typeName: "ext4",
      total: "500.0 GB",
      free: "200.0 GB",
      used: "300.0 GB",
      usage: 60.0
    }
  ]
}
```

## 样式设计

### 条件样式

**内存使用率警告：**
```vue
<td :class="{'text-danger': server.mem.usage > 80}">
  {{ server.mem.usage }}%
</td>
```

**磁盘使用率警告：**
```vue
<td :class="{'text-danger': sysFile.usage > 80}">
  {{ sysFile.usage }}%
</td>
```

### 表格样式
- 使用 Element UI 表格样式
- 单元格等宽布局
- 悬停高亮效果

### 卡片样式
- 固定高度
- 圆角边框
- 阴影效果
- 头部图标 + 标题

## 交互功能

### 1. 数据加载
- 页面创建时自动加载数据
- 显示加载提示（loading）
- 加载完成后关闭提示

### 2. 数据展示
- 条件渲染（v-if）：数据存在时才显示
- 列表渲染（v-for）：遍历磁盘分区列表
- 格式化显示：自动转换单位

### 3. 状态反馈
- 加载状态：`$modal.loading()`
- 完成状态：`$modal.closeLoading()`
- 错误处理：异常捕获和提示

## 响应式设计

### 栅格布局
- CPU/内存卡片：`el-col :span="12"`（各占 50%）
- 其他卡片：`el-col :span="24"`（占 100%）

### 自适应策略
- 大屏（≥1200px）：并排显示
- 中屏（768-1199px）：自动换行
- 小屏（<768px）：单列显示

## 性能优化

### 1. 条件渲染
```vue
<td v-if="server.cpu">{{ server.cpu.cpuNum }}</td>
```
避免数据未加载时的空值显示

### 2. 列表缓存
```vue
<tr v-for="(sysFile, index) in server.sysFiles" :key="index">
```
使用 index 作为 key，提高渲染性能

### 3. 表格布局优化
```vue
<table style="width: 100%;table-layout:fixed;">
```
固定表格布局算法，提高渲染速度

## 图标使用

| 卡片 | 图标 | 含义 |
|------|------|------|
| CPU | `el-icon-cpu` | 处理器 |
| 内存 | `el-icon-tickets` | 内存条 |
| 服务器 | `el-icon-monitor` | 显示器 |
| JVM | `el-icon-coffee-cup` | Java 咖啡杯 |
| 磁盘 | `el-icon-receiving` | 存储设备 |

## 生命周期

### created()
```javascript
created() {
  this.getList()      // 加载数据
  this.openLoading()  // 显示加载提示
}
```

### 方法

**getList()**
```javascript
getList() {
  getServer().then(response => {
    this.server = response.data
    this.$modal.closeLoading()
  })
}
```

**openLoading()**
```javascript
openLoading() {
  this.$modal.loading("正在加载服务监控数据，请稍候！")
}
```

## 错误处理

### 1. 数据为空处理
```vue
<td v-if="server.cpu">{{ server.cpu.cpuNum }}</td>
```
数据未加载时不显示

### 2. API 调用失败
```javascript
getServer().then(response => {
  // 成功处理
}).catch(error => {
  // 错误处理（由 request 拦截器统一处理）
})
```

### 3. 加载超时
- 设置合理的超时时间
- 显示友好的错误提示

## 可访问性

### 1. 语义化标签
- 使用 table 展示结构化数据
- 使用 thead/tbody 区分表头表体

### 2. 颜色对比度
- 警告红色使用标准色值
- 确保文字清晰可读

### 3. 键盘导航
- 支持 Tab 键切换焦点
- 支持 Enter 键操作

## 浏览器兼容性

- Chrome ≥ 60
- Firefox ≥ 55
- Safari ≥ 11
- Edge ≥ 79
- IE：不支持（使用 polyfill）
