# 015-server - 数据模型

## 实体关系图

```
┌─────────────────┐
│     Server      │
├─────────────────┤
│ - cpu: Cpu      │
│ - mem: Mem      │
│ - jvm: Jvm      │
│ - sys: Sys      │
│ - sysFiles      │
└────────┬────────┘
         │
    ┌────┴────┬─────────┬────────┬──────────┐
    ↓         ↓         ↓        ↓          ↓
┌──────┐  ┌──────┐  ┌─────┐  ┌────┐   ┌──────────┐
│ Cpu  │  │ Mem  │  │ Jvm │  │ Sys│   │ SysFile  │
└──────┘  └──────┘  └─────┘  └────┘   └──────────┘
```

## 数据模型详细定义

### Server（服务器信息）

**说明：** 服务器信息聚合根，包含所有服务器相关子信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| cpu | Cpu | CPU 相关信息 |
| mem | Mem | 内存相关信息 |
| jvm | Jvm | JVM 相关信息 |
| sys | Sys | 系统相关信息 |
| sysFiles | List<SysFile> | 磁盘分区列表 |

**方法：**
- `copyTo()`: 采集并复制服务器信息到当前对象

---

### Cpu（CPU 信息）

**说明：** CPU 相关信息，包含核心数和使用率统计。

| 字段名 | 类型 | 精度 | 说明 |
|--------|------|------|------|
| cpuNum | int | - | 核心数（逻辑处理器） |
| total | double | 2 位 | CPU 总使用率 (%) |
| sys | double | 2 位 | CPU 系统使用率 (%) |
| used | double | 2 位 | CPU 用户使用率 (%) |
| wait | double | 2 位 | CPU 等待率 (%) |
| free | double | 2 位 | CPU 空闲率 (%) |

**计算公式：**
```
total = user + nice + system + idle + iowait + irq + softirq + steal
used% = (user / total) × 100
sys% = (system / total) × 100
free% = (idle / total) × 100
```

**采集方法：**
1. 获取 CPU 时间片计数（prevTicks）
2. 等待 1000ms
3. 再次获取 CPU 时间片计数（ticks）
4. 计算差值得到各状态使用时间

---

### Mem（内存信息）

**说明：** 物理内存相关信息。

| 字段名 | 类型 | 单位 | 说明 |
|--------|------|------|------|
| total | double | GB | 内存总量 |
| used | double | GB | 已用内存 |
| free | double | GB | 剩余内存 |
| usage | double | % | 使用率 |

**计算公式：**
```
total = memory.getTotal() / (1024^3)
used = (memory.getTotal() - memory.getAvailable()) / (1024^3)
free = memory.getAvailable() / (1024^3)
usage = (used / total) × 100
```

**转换规则：**
- 原始值：字节（Bytes）
- 显示值：GB（保留 2 位小数）

---

### Jvm（JVM 信息）

**说明：** Java 虚拟机相关信息。

| 字段名 | 类型 | 单位 | 说明 |
|--------|------|------|------|
| total | double | MB | JVM 总内存 |
| max | double | MB | JVM 最大可用内存 |
| free | double | MB | JVM 空闲内存 |
| used | double | MB | JVM 已用内存 |
| usage | double | % | JVM 使用率 |
| version | String | - | JDK 版本 |
| home | String | - | JDK 安装路径 |

**计算公式：**
```
total = Runtime.totalMemory() / (1024^2)
max = Runtime.maxMemory() / (1024^2)
free = Runtime.freeMemory() / (1024^2)
used = total - free
usage = (used / total) × 100
```

**派生字段：**
- `name`: JVM 名称（RuntimeMXBean.getVmName()）
- `startTime`: 启动时间（格式化后的日期时间）
- `runTime`: 运行时长（人类可读格式）
- `inputArgs`: 运行参数

---

### Sys（系统信息）

**说明：** 操作系统和服务器基本信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| computerName | String | 服务器名称（主机名） |
| computerIp | String | 服务器 IP 地址 |
| userDir | String | 项目路径（user.dir） |
| osName | String | 操作系统名称 |
| osArch | String | 系统架构（x86_64 等） |

**数据来源：**
- computerName: 通过 DNS 解析获取
- computerIp: 通过 IpUtils 工具类获取
- osName: System.getProperty("os.name")
- osArch: System.getProperty("os.arch")
- userDir: System.getProperty("user.dir")

---

### SysFile（磁盘分区信息）

**说明：** 磁盘分区相关信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| dirName | String | 盘符路径（挂载点） |
| sysTypeName | String | 文件系统类型 |
| typeName | String | 盘符类型（名称） |
| total | String | 总大小（人类可读） |
| free | String | 剩余大小（人类可读） |
| used | String | 已用大小（人类可读） |
| usage | double | 使用率 (%) |

**计算公式：**
```
total = fs.getTotalSpace()
free = fs.getUsableSpace()
used = total - free
usage = (used / total) × 100
```

**大小转换规则：**
```
if size >= GB: "%.1f GB"
else if size >= MB: "%.1f MB" (or "%.0f MB" if > 100)
else if size >= KB: "%.1f KB" (or "%.0f KB" if > 100)
else: "%d B"
```

## 数据采集流程

### Server.copyTo() 方法流程

```
SystemInfo si = new SystemInfo()
    ↓
HardwareAbstractionLayer hal = si.getHardware()
    ↓
┌──────────────────────────────────────┐
│ 1. setCpuInfo(hal.getProcessor())    │
│    - 获取 CPU 时间片                   │
│    - 等待 1000ms                      │
│    - 计算使用率                      │
├──────────────────────────────────────┤
│ 2. setMemInfo(hal.getMemory())       │
│    - 获取总内存                      │
│    - 获取可用内存                    │
│    - 计算已用内存                    │
├──────────────────────────────────────┤
│ 3. setSysInfo()                      │
│    - 获取主机名                      │
│    - 获取 IP 地址                      │
│    - 获取系统属性                    │
├──────────────────────────────────────┤
│ 4. setJvmInfo()                      │
│    - 获取 Runtime 内存信息            │
│    - 获取 Java 属性                   │
├──────────────────────────────────────┤
│ 5. setSysFiles(si.getOperatingSystem())│
│    - 获取文件系统                    │
│    - 遍历所有分区                    │
│    - 计算各分区使用率                │
└──────────────────────────────────────┘
```

## 数据类型转换

### 数值精度处理

使用 `Arith` 工具类进行精确计算：

```java
// 保留 2 位小数
Arith.round(value, 2)

// 除法运算（保留 4 位）
Arith.div(dividend, divisor, 4)

// 乘法运算
Arith.mul(a, b)
```

### 字节转换

```java
convertFileSize(long size):
  - GB: size / (1024^3)
  - MB: size / (1024^2)
  - KB: size / 1024
  - B: 原始值
```

### 时间转换

```java
// 启动时间
DateUtils.parseDateToStr(YYYY_MM_DD_HH_MM_SS, startDate)

// 运行时长
DateUtils.timeDistance(now, startDate)
  → 格式：X 天 X 小时 X 分钟 X 秒
```

## 数据验证规则

1. **CPU 使用率验证**
   - 所有使用率之和 = 100%
   - 各分项使用率 ∈ [0, 100]

2. **内存使用率验证**
   - used + free = total
   - usage ∈ [0, 100]

3. **磁盘使用率验证**
   - used + free ≈ total（考虑保留空间）
   - usage ∈ [0, 100]

## 数据更新策略

- **采集频率**: 每次请求时采集
- **数据时效**: 实时数据
- **缓存策略**: 不缓存，每次返回最新数据
- **并发控制**: 无锁，允许并发读取
