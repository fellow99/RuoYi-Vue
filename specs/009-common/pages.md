# 009-Common 公共模块前端页面

## 1. 页面结构

### 1.1 操作日志管理页面

**文件路径：** `ruoyi-ui/src/views/monitor/operlog/index.vue`

**路由配置：**
```javascript
{
  path: '/monitor/operlog',
  component: Layout,
  hidden: false,
  children: [{
    path: 'operlog',
    component: () => import('@/views/monitor/operlog/index'),
    name: 'Operlog',
    meta: { title: '操作日志', icon: 'form' }
  }]
}
```

### 1.2 登录日志管理页面

**文件路径：** `ruoyi-ui/src/views/monitor/logininfor/index.vue`

**路由配置：**
```javascript
{
  path: '/monitor/logininfor',
  component: Layout,
  hidden: false,
  children: [{
    path: 'logininfor',
    component: () => import('@/views/monitor/logininfor/index'),
    name: 'Logininfor',
    meta: { title: '登录日志', icon: 'form' }
  }]
}
```

### 1.3 在线用户管理页面

**文件路径：** `ruoyi-ui/src/views/monitor/online/index.vue`

**路由配置：**
```javascript
{
  path: '/monitor/online',
  component: Layout,
  hidden: false,
  children: [{
    path: 'online',
    component: () => import('@/views/monitor/online/index'),
    name: 'Online',
    meta: { title: '在线用户', icon: 'form' }
  }]
}
```

## 2. 操作日志页面功能

### 2.1 搜索区域
- 系统模块（文本输入，模糊查询）
- 操作人员（文本输入，模糊查询）
- 操作类型（下拉选择：全部/新增/修改/删除/授权/导出/导入/强退/生成代码/清空数据）
- 操作状态（下拉选择：全部/正常/异常）
- 操作时间（日期范围选择器）
- 搜索按钮
- 重置按钮

### 2.2 操作按钮
- 导出（权限：monitor:operlog:export）
- 删除（权限：monitor:operlog:remove，多选）
- 清空（权限：monitor:operlog:remove）

### 2.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 日志编号 | operId | 操作日志 ID |
| 系统模块 | title | 操作模块标题 |
| 操作类型 | businessType | 使用 dict-tag 组件显示 |
| 操作人员 | operName | 操作人 |
| 部门名称 | deptName | 所属部门 |
| 请求 URL | operUrl | 请求地址 |
| 操作地址 | operIp | IP 地址 |
| 操作状态 | status | 使用 dict-tag 组件显示（正常/异常） |
| 操作时间 | operTime | 格式化显示（yyyy-MM-dd HH:mm:ss） |
| 消耗时间 | costTime | 毫秒单位 |
| 操作 | - | 详情按钮 |

### 2.4 详情对话框
- 显示完整的操作日志信息
- 包含请求参数和返回参数的格式化显示
- 错误消息显示（如果有）

## 3. 登录日志页面功能

### 3.1 搜索区域
- 登录地址（文本输入，用户账号模糊查询）
- 用户 IP（文本输入，IP 地址）
- 状态（下拉选择：全部/成功/失败）
- 登录时间（日期范围选择器）
- 搜索按钮
- 重置按钮

### 3.2 操作按钮
- 导出（权限：monitor:logininfor:export）
- 删除（权限：monitor:logininfor:remove，多选）
- 清空（权限：monitor:logininfor:remove）

### 3.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 访问 ID | infoId | 登录日志 ID |
| 用户账号 | userName | 登录用户 |
| 登录地址 | ipaddr | IP 地址 |
| 登录地点 | loginLocation | 地理位置 |
| 浏览器 | browser | 浏览器类型 |
| 操作系统 | os | 操作系统 |
| 状态 | status | 使用 dict-tag 组件显示（成功/失败） |
| 描述信息 | msg | 登录结果描述 |
| 登录时间 | loginTime | 格式化显示（yyyy-MM-dd HH:mm:ss） |
| 操作 | - | 解锁按钮（仅失败记录） |

## 4. 在线用户页面功能

### 4.1 搜索区域
- 登录地址（文本输入，用户账号模糊查询）
- 用户 IP（文本输入，IP 地址）
- 搜索按钮
- 重置按钮

### 4.2 操作按钮
- 批量强退（权限：monitor:online:force，多选）
- 单条强退（权限：monitor:online:force）

### 4.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 序号 | - | 行号 |
| 用户账号 | userName | 在线用户 |
| 登录 IP | ipaddr | IP 地址 |
| 登录地点 | loginLocation | 地理位置 |
| 浏览器 | browser | 浏览器类型 |
| 操作系统 | os | 操作系统 |
| 登录时间 | loginTime | 格式化显示 |
| 操作 | - | 强退按钮 |

## 5. 组件事件

### 5.1 操作日志事件
```javascript
// 查询列表
getList()

// 搜索
handleQuery()

// 重置搜索
resetQuery()

// 删除
handleDelete(row)

// 导出
handleExport()

// 清空
handleClean()

// 查看详情
handleView(row)
```

### 5.2 登录日志事件
```javascript
// 查询列表
getList()

// 搜索
handleQuery()

// 重置搜索
resetQuery()

// 删除
handleDelete(row)

// 导出
handleExport()

// 清空
handleClean()

// 解锁账户
handleUnlock(row)
```

### 5.3 在线用户事件
```javascript
// 查询列表
getList()

// 搜索
handleQuery()

// 重置搜索
resetQuery()

// 强退
handleForceLogout(row)

// 批量强退
handleBatchForceLogout()
```

## 6. 使用的 API

### 6.1 操作日志 API
```javascript
import { 
  list,          // 查询操作日志列表
  delOperlog,    // 删除操作日志
  cleanOperlog,  // 清空操作日志
  export         // 导出操作日志
} from "@/api/monitor/operlog"
```

### 6.2 登录日志 API
```javascript
import { 
  list,            // 查询登录日志列表
  delLogininfor,   // 删除登录日志
  cleanLogininfor, // 清空登录日志
  unlock,          // 账户解锁
  export           // 导出登录日志
} from "@/api/monitor/logininfor"
```

### 6.3 在线用户 API
```javascript
import { 
  list,          // 查询在线用户列表
  forceLogout    // 用户强退
} from "@/api/monitor/online"
```

## 7. 使用的字典

### 7.1 操作日志字典
```javascript
dicts: ['sys_oper_type', 'sys_common_status']
```

### 7.2 登录日志字典
```javascript
dicts: ['sys_common_status']
```

## 8. 数据模型

### 8.1 操作日志查询参数
```javascript
queryParams: {
  pageNum: 1,
  pageSize: 10,
  title: undefined,
  businessType: undefined,
  status: undefined,
  operName: undefined,
  startTime: undefined,
  endTime: undefined
}
```

### 8.2 登录日志查询参数
```javascript
queryParams: {
  pageNum: 1,
  pageSize: 10,
  userName: undefined,
  ipaddr: undefined,
  status: undefined,
  startTime: undefined,
  endTime: undefined
}
```

### 8.3 在线用户查询参数
```javascript
queryParams: {
  pageNum: 1,
  pageSize: 10,
  userName: undefined,
  ipaddr: undefined
}
```

## 9. 页面样式

- 使用 Element UI 组件库
- 响应式布局，支持不同屏幕尺寸
- 表格支持列宽自适应
- 对话框宽度根据内容调整
- 操作按钮使用图标 + 文字形式
- 搜索表单 label-width="68px"

## 10. 用户体验优化

1. 搜索表单支持回车键触发搜索
2. 删除和清空操作需要二次确认
3. 操作成功后自动刷新列表
4. 操作成功/失败有明确提示
5. 列表支持分页
6. 表格列支持溢出提示（show-overflow-tooltip）
7. 详情对话框展示格式化后的 JSON 数据

## 11. 权限控制

### 11.1 操作日志权限
- 导出按钮：`v-hasPermi="['monitor:operlog:export']"`
- 删除按钮：`v-hasPermi="['monitor:operlog:remove']"`
- 清空按钮：`v-hasPermi="['monitor:operlog:remove']"`

### 11.2 登录日志权限
- 导出按钮：`v-hasPermi="['monitor:logininfor:export']"`
- 删除按钮：`v-hasPermi="['monitor:logininfor:remove']"`
- 清空按钮：`v-hasPermi="['monitor:logininfor:remove']"`
- 解锁按钮：`v-hasPermi="['monitor:logininfor:unlock']"`

### 11.3 在线用户权限
- 强退按钮：`v-hasPermi="['monitor:online:force']"`

## 12. 特殊处理

### 12.1 清空确认
```javascript
handleClean() {
  this.$modal.confirm('是否确认清空所有日志数据？').then(() => {
    cleanOperlog().then(() => {
      this.$modal.msgSuccess("清空成功")
      this.getList()
    })
  })
}
```

### 12.2 解锁账户
```javascript
handleUnlock(row) {
  this.$modal.confirm('是否确认解锁用户"' + row.userName + '"？').then(() => {
    unlock(row.userName).then(() => {
      this.$modal.msgSuccess("解锁成功")
    })
  })
}
```

### 12.3 强退用户
```javascript
handleForceLogout(row) {
  this.$modal.confirm('是否确认强退用户"' + row.userName + '"？').then(() => {
    forceLogout(row.tokenId).then(() => {
      this.$modal.msgSuccess("强退成功")
      this.getList()
    })
  })
}
```

### 12.4 详情展示
```javascript
handleView(row) {
  this.open = true
  this.title = "操作日志详情"
  this.form = row
  // 格式化 JSON 数据
  this.operParam = JSON.parse(row.operParam || '{}')
  this.jsonResult = JSON.parse(row.jsonResult || '{}')
}
```
