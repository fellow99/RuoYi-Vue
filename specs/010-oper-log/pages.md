# 操作日志前端页面 (010-oper-log)

**模块编号：** 010  
**最后更新：** 2026-03-12

---

## 一、页面概述

### 1.1 页面信息

| 项目 | 说明 |
|------|------|
| 页面名称 | 操作日志 |
| 页面路径 | `/monitor/operlog` |
| 组件文件 | `ruoyi-ui/src/views/monitor/operlog/index.vue` |
| 路由名称 | Operlog |
| 技术栈 | Vue 2.x + Element UI |

### 1.2 页面功能

- 操作日志列表展示
- 多条件查询筛选
- 日志详细查看
- 批量删除日志
- 清空所有日志
- 导出 Excel 文件

---

## 二、页面布局

### 2.1 整体结构

```
┌─────────────────────────────────────────────────────────┐
│  查询表单区域                                            │
│  ┌─────────────────────────────────────────────────┐    │
│  │ 操作地址 [____] 系统模块 [____] 操作人员 [____]  │    │
│  │ 类型 [▼] 状态 [▼] 操作时间 [____ - ____] [搜索]  │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  工具栏                                                  │
│  [删除] [清空] [导出]              [显示搜索] [刷新]    │
├─────────────────────────────────────────────────────────┤
│  数据表格                                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │ ☑ │ 编号 │ 模块 │ 类型 │ 人员 │ 地址 │ 状态 │... │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ ☐ │ 1001 │ ... │ ... │ ... │ ... │ ... │ ... │    │
│  │ ☐ │ 1002 │ ... │ ... │ ... │ ... │ ... │ ... │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  分页组件                                                │
│  共 100 条  [首页] [上一页] 1/10 [下一页] [末页]         │
└─────────────────────────────────────────────────────────┘
```

### 2.2 详细弹窗

```
┌───────────────────────────────────────────────────┐
│  操作日志详细                              [×]    │
├───────────────────────────────────────────────────┤
│  操作模块：用户管理 / 新增                         │
│  登录信息：张三 / 192.168.1.100 / XX 省 XX 市       │
│  请求地址：/system/user/add                       │
│  请求方式：POST                                   │
│  操作方法：com.ruoyi.web.controller...add()       │
│  请求参数：{...JSON...}                           │
│  返回参数：{...JSON...}                           │
│  操作状态：正常                                   │
│  消耗时间：150 毫秒                                │
│  操作时间：2026-03-12 10:30:00                    │
│  异常信息：（失败时显示）                          │
├───────────────────────────────────────────────────┤
│                                  [关闭]           │
└───────────────────────────────────────────────────┘
```

---

## 三、组件详情

### 3.1 查询表单

**表单字段：**

| 字段 | 类型 | 占位符 | 验证 |
|------|------|--------|------|
| operIp | Input | 请输入操作地址 | 无 |
| title | Input | 请输入系统模块 | 无 |
| operName | Input | 请输入操作人员 | 无 |
| businessType | Select | 操作类型 | 字典：sys_oper_type |
| status | Select | 操作状态 | 字典：sys_common_status |
| dateRange | DatePicker | 操作时间 | 日期范围选择器 |

**操作按钮：**
- 搜索：触发表单查询
- 重置：清空查询条件

### 3.2 工具栏

**按钮列表：**

| 按钮 | 图标 | 权限 | 说明 |
|------|------|------|------|
| 删除 | el-icon-delete | monitor:operlog:remove | 批量删除选中日志 |
| 清空 | el-icon-delete | monitor:operlog:remove | 清空所有日志 |
| 导出 | el-icon-download | monitor:operlog:export | 导出查询结果 |

**右侧工具：**
- 显示搜索：控制查询表单显示/隐藏
- 刷新：重新加载列表数据

### 3.3 数据表格

**列定义：**

| 列名 | 字段 | 宽度 | 排序 | 说明 |
|------|------|------|------|------|
| 选择框 | - | 50 | - | 多选框 |
| 日志编号 | operId | - | - | 主键 ID |
| 系统模块 | title | - | - | 操作模块名称 |
| 操作类型 | businessType | - | - | 字典标签展示 |
| 操作人员 | operName | 110 | ✓ | 支持排序 |
| 操作地址 | operIp | 130 | - | IP 地址 |
| 操作地点 | operLocation | - | - | IP 解析地点 |
| 操作状态 | status | - | - | 字典标签展示 |
| 操作日期 | operTime | 160 | ✓ | 格式化展示 |
| 消耗时间 | costTime | 110 | ✓ | 毫秒单位 |
| 操作 | - | - | - | 详细按钮 |

**表格特性：**
- 支持多选
- 支持列排序
- 超长文本省略显示（show-overflow-tooltip）
- 字典值转换展示

### 3.4 分页组件

**配置项：**
- total: 总记录数
- page: 当前页码（v-model）
- limit: 每页数量（v-model）
- 支持页码跳转
- 支持每页数量切换

---

## 四、交互逻辑

### 4.1 查询操作

```javascript
// 搜索按钮
handleQuery() {
  this.queryParams.pageNum = 1
  this.getList()
}

// 重置按钮
resetQuery() {
  this.dateRange = []
  this.resetForm("queryForm")
  this.queryParams.pageNum = 1
  this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
}
```

### 4.2 多选操作

```javascript
// 选择变化
handleSelectionChange(selection) {
  this.ids = selection.map(item => item.operId)
  this.multiple = !selection.length
}
```

### 4.3 删除操作

```javascript
// 删除按钮
handleDelete(row) {
  const operIds = row.operId || this.ids
  this.$modal.confirm('是否确认删除日志编号为"' + operIds + '"的数据项？')
    .then(() => delOperlog(operIds))
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("删除成功")
    })
}
```

### 4.4 清空操作

```javascript
// 清空按钮
handleClean() {
  this.$modal.confirm('是否确认清空所有操作日志数据项？')
    .then(() => cleanOperlog())
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("清空成功")
    })
}
```

### 4.5 详细查看

```javascript
// 详细按钮
handleView(row) {
  this.open = true
  this.form = row
}
```

### 4.6 导出操作

```javascript
// 导出按钮
handleExport() {
  this.download('monitor/operlog/export', {
    ...this.queryParams
  }, `operlog_${new Date().getTime()}.xlsx`)
}
```

### 4.7 排序操作

```javascript
// 排序变化
handleSortChange(column, prop, order) {
  this.queryParams.orderByColumn = column.prop
  this.queryParams.isAsc = column.order
  this.getList()
}
```

---

## 五、数据字典

### 5.1 使用的字典

| 字典类型 | 字典名称 | 用途 |
|----------|----------|------|
| sys_oper_type | 操作类型 | 业务类型展示 |
| sys_common_status | 通用状态 | 操作状态展示 |

### 5.2 字典配置

```javascript
export default {
  dicts: ['sys_oper_type', 'sys_common_status']
}
```

---

## 六、样式说明

### 6.1 关键样式类

- `app-container`: 页面容器
- `mb8`: 底部间距 8px
- `small-padding`: 小内边距
- `fixed-width`: 固定宽度列

### 6.2 响应式布局

- 查询表单：inline 布局，小屏自动换行
- 表格：100% 宽度，自适应高度
- 工具栏：flex 布局，均匀分布

---

## 七、组件依赖

### 7.1 引入组件

```javascript
import { list, delOperlog, cleanOperlog } from "@/api/monitor/operlog"
```

### 7.2 使用组件

- `el-form`: 查询表单
- `el-table`: 数据表格
- `el-dialog`: 详情弹窗
- `el-pagination`: 分页组件
- `right-toolbar`: 右侧工具栏（自定义）
- `dict-tag`: 字典标签（自定义）
- `pagination`: 分页组件（自定义）

---

## 八、路由配置

### 8.1 路由定义

```javascript
{
  path: '/monitor/operlog',
  component: Layout,
  hidden: false,
  children: [{
    path: 'index',
    component: () => import('@/views/monitor/operlog'),
    name: 'Operlog',
    meta: { title: '操作日志', icon: 'form' }
  }]
}
```

### 8.2 菜单配置

- 父菜单：系统监控
- 菜单名称：操作日志
- 路由地址：/monitor/operlog/index
- 权限标识：monitor:operlog:list

---

## 九、优化建议

### 9.1 性能优化

- 列表数据分页加载
- 避免频繁查询（防抖处理）
- 大数据量时限制查询时间范围

### 9.2 用户体验

- 加载状态提示（v-loading）
- 操作成功/失败提示
- 二次确认防止误操作
- 支持键盘操作（Enter 搜索）

### 9.3 可访问性

- 按钮添加 aria-label
- 表格支持键盘导航
- 颜色对比度符合 WCAG 标准

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
