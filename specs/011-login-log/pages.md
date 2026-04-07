# 登录日志前端页面 (011-login-log)

**模块编号：** 011  
**最后更新：** 2026-03-12

---

## 一、页面概述

### 1.1 页面信息

| 项目 | 说明 |
|------|------|
| 页面名称 | 登录日志 |
| 页面路径 | `/monitor/logininfor` |
| 组件文件 | `ruoyi-ui/src/views/monitor/logininfor/index.vue` |
| 路由名称 | Logininfor |
| 技术栈 | Vue 2.x + Element UI |

### 1.2 页面功能

- 登录日志列表展示
- 多条件查询筛选
- 批量删除日志
- 清空所有日志
- 导出 Excel 文件
- 解锁用户账户

---

## 二、页面布局

### 2.1 整体结构

```
┌─────────────────────────────────────────────────────────┐
│  查询表单区域                                            │
│  ┌─────────────────────────────────────────────────┐    │
│  │ 登录地址 [____] 用户名称 [____] 状态 [▼]        │    │
│  │ 登录时间 [____ - ____] [搜索] [重置]            │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  工具栏                                                  │
│  [删除] [清空] [解锁] [导出]       [显示搜索] [刷新]    │
├─────────────────────────────────────────────────────────┤
│  数据表格                                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │ ☑ │ 编号 │ 用户 │ 地址 │ 地点 │ 浏览器 │ 状态 │... │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ ☐ │ 1001 │ ... │ ... │ ... │ ... │ ... │ ... │    │
│  │ ☐ │ 1002 │ ... │ ... │ ... │ ... │ ... │ ... │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  分页组件                                                │
│  共 100 条  [首页] [上一页] 1/10 [下一页] [末页]         │
└─────────────────────────────────────────────────────────┘
```

---

## 三、组件详情

### 3.1 查询表单

**表单字段：**

| 字段 | 类型 | 占位符 | 验证 |
|------|------|--------|------|
| ipaddr | Input | 请输入登录地址 | 无 |
| userName | Input | 请输入用户名称 | 无 |
| status | Select | 登录状态 | 字典：sys_common_status |
| dateRange | DatePicker | 登录时间 | 日期范围选择器 |

**操作按钮：**
- 搜索：触发表单查询
- 重置：清空查询条件

### 3.2 工具栏

**按钮列表：**

| 按钮 | 图标 | 权限 | 说明 |
|------|------|------|------|
| 删除 | el-icon-delete | monitor:logininfor:remove | 批量删除选中日志 |
| 清空 | el-icon-delete | monitor:logininfor:remove | 清空所有日志 |
| 解锁 | el-icon-unlock | monitor:logininfor:unlock | 解锁选中用户 |
| 导出 | el-icon-download | monitor:logininfor:export | 导出查询结果 |

**右侧工具：**
- 显示搜索：控制查询表单显示/隐藏
- 刷新：重新加载列表数据

### 3.3 数据表格

**列定义：**

| 列名 | 字段 | 宽度 | 排序 | 说明 |
|------|------|------|------|------|
| 选择框 | - | 55 | - | 多选框 |
| 访问编号 | infoId | - | - | 主键 ID |
| 用户名称 | userName | - | ✓ | 支持排序 |
| 登录地址 | ipaddr | 130 | - | IP 地址 |
| 登录地点 | loginLocation | - | - | IP 解析地点 |
| 浏览器 | browser | - | - | 浏览器类型 |
| 操作系统 | os | - | - | 操作系统 |
| 登录状态 | status | - | - | 字典标签展示 |
| 操作信息 | msg | - | - | 提示消息 |
| 登录日期 | loginTime | 180 | ✓ | 格式化展示 |

**表格特性：**
- 支持多选
- 支持列排序
- 超长文本省略显示（show-overflow-tooltip）
- 字典值转换展示

---

## 四、交互逻辑

### 4.1 查询操作

```javascript
handleQuery() {
  this.queryParams.pageNum = 1
  this.getList()
}

resetQuery() {
  this.dateRange = []
  this.resetForm("queryForm")
  this.queryParams.pageNum = 1
  this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
}
```

### 4.2 多选操作

```javascript
handleSelectionChange(selection) {
  this.ids = selection.map(item => item.infoId)
  this.single = selection.length != 1
  this.multiple = !selection.length
  this.selectName = selection.map(item => item.userName)
}
```

### 4.3 删除操作

```javascript
handleDelete(row) {
  const infoIds = row.infoId || this.ids
  this.$modal.confirm('是否确认删除访问编号为"' + infoIds + '"的数据项？')
    .then(() => delLogininfor(infoIds))
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("删除成功")
    })
}
```

### 4.4 清空操作

```javascript
handleClean() {
  this.$modal.confirm('是否确认清空所有登录日志数据项？')
    .then(() => cleanLogininfor())
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("清空成功")
    })
}
```

### 4.5 解锁操作

```javascript
handleUnlock() {
  const username = this.selectName
  this.$modal.confirm('是否确认解锁用户"' + username + '"数据项？')
    .then(() => unlockLogininfor(username))
    .then(() => {
      this.$modal.msgSuccess("用户" + username + "解锁成功")
    })
}
```

### 4.6 导出操作

```javascript
handleExport() {
  this.download('monitor/logininfor/export', {
    ...this.queryParams
  }, `logininfor_${new Date().getTime()}.xlsx`)
}
```

---

## 五、数据字典

### 5.1 使用的字典

| 字典类型 | 字典名称 | 用途 |
|----------|----------|------|
| sys_common_status | 通用状态 | 登录状态展示 |

### 5.2 字典配置

```javascript
export default {
  dicts: ['sys_common_status']
}
```

---

## 六、路由配置

### 6.1 路由定义

```javascript
{
  path: '/monitor/logininfor',
  component: Layout,
  hidden: false,
  children: [{
    path: 'index',
    component: () => import('@/views/monitor/logininfor'),
    name: 'Logininfor',
    meta: { title: '登录日志', icon: 'login' }
  }]
}
```

### 6.2 菜单配置

- 父菜单：系统监控
- 菜单名称：登录日志
- 路由地址：/monitor/logininfor/index
- 权限标识：monitor:logininfor:list

---

## 七、优化建议

### 7.1 性能优化

- 列表数据分页加载
- 避免频繁查询（防抖处理）
- 大数据量时限制查询时间范围

### 7.2 用户体验

- 加载状态提示（v-loading）
- 操作成功/失败提示
- 二次确认防止误操作
- 支持键盘操作（Enter 搜索）

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
