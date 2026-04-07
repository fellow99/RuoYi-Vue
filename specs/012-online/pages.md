# 在线用户前端页面 (012-online)

**模块编号：** 012  
**最后更新：** 2026-03-12

---

## 一、页面概述

### 1.1 页面信息

| 项目 | 说明 |
|------|------|
| 页面名称 | 在线用户 |
| 页面路径 | `/monitor/online` |
| 组件文件 | `ruoyi-ui/src/views/monitor/online/index.vue` |
| 路由名称 | Online |
| 技术栈 | Vue 2.x + Element UI |

### 1.2 页面功能

- 在线用户列表展示
- 条件查询筛选
- 强制退出用户
- 实时刷新列表

---

## 二、页面布局

### 2.1 整体结构

```
┌─────────────────────────────────────────────────────────┐
│  查询表单区域                                            │
│  ┌─────────────────────────────────────────────────┐    │
│  │ 登录地址 [____] 用户名称 [____] [搜索] [重置]   │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  数据表格                                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │ 序号 │ 会话编号 │ 用户 │ 部门 │ 主机 │ 地点 │... │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ 1 │ eyJhbG... │ admin │ 研发 │ 192.168 │ ... │    │
│  │ 2 │ eyJhbG... │ user1 │ 测试 │ 192.168 │ ... │    │
│  └─────────────────────────────────────────────────┤    │
│  │ [强退] │ [强退] │ [强退] │ [强退] │ [强退] │    │
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

**操作按钮：**
- 搜索：触发查询
- 重置：清空条件

### 3.2 数据表格

**列定义：**

| 列名 | 字段 | 宽度 | 说明 |
|------|------|------|------|
| 序号 | - | - | 前端计算序号 |
| 会话编号 | tokenId | - | Token ID（省略显示） |
| 登录名称 | userName | - | 用户账号 |
| 部门名称 | deptName | - | 所属部门 |
| 主机 | ipaddr | - | IP 地址 |
| 登录地点 | loginLocation | - | IP 解析地点 |
| 浏览器 | browser | - | 浏览器类型 |
| 操作系统 | os | - | 操作系统 |
| 登录时间 | loginTime | 180 | 格式化展示 |
| 操作 | - | - | 强退按钮 |

**表格特性：**
- 前端分页（slice 方式）
- 超长文本省略显示（show-overflow-tooltip）
- 固定操作列宽度

### 3.3 分页组件

**配置项：**
- total: 总记录数
- page: 当前页码（v-model）
- limit: 每页数量（v-model）
- 支持页码跳转

---

## 四、交互逻辑

### 4.1 查询操作

```javascript
// 搜索按钮
handleQuery() {
  this.pageNum = 1
  this.getList()
}

// 重置按钮
resetQuery() {
  this.resetForm("queryForm")
  this.handleQuery()
}

// 查询列表
getList() {
  this.loading = true
  list(this.queryParams).then(response => {
    this.list = response.rows
    this.total = response.total
    this.loading = false
  })
}
```

### 4.2 前端分页

```javascript
// 表格数据绑定
:data="list.slice((pageNum-1)*pageSize, pageNum*pageSize)"

// 序号计算
<template slot-scope="scope">
  <span>{{ (pageNum - 1) * pageSize + scope.$index + 1 }}</span>
</template>
```

### 4.3 强制退出

```javascript
handleForceLogout(row) {
  this.$modal.confirm('是否确认强退名称为"' + row.userName + '"的用户？')
    .then(() => forceLogout(row.tokenId))
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("强退成功")
    })
}
```

---

## 五、数据字典

### 5.1 使用的字典

本模块不使用数据字典。

---

## 六、路由配置

### 6.1 路由定义

```javascript
{
  path: '/monitor/online',
  component: Layout,
  hidden: false,
  children: [{
    path: 'index',
    component: () => import('@/views/monitor/online'),
    name: 'Online',
    meta: { title: '在线用户', icon: 'online' }
  }]
}
```

### 6.2 菜单配置

- 父菜单：系统监控
- 菜单名称：在线用户
- 路由地址：/monitor/online/index
- 权限标识：monitor:online:list

---

## 七、组件依赖

### 7.1 引入组件

```javascript
import { list, forceLogout } from "@/api/monitor/online"
```

### 7.2 使用组件

- `el-form`: 查询表单
- `el-table`: 数据表格
- `el-pagination`: 分页组件
- `right-toolbar`: 右侧工具栏（自定义）

---

## 八、特殊处理

### 8.1 前端分页

由于在线用户数据来自 Redis，不支持后端分页，采用前端分页方式：

```javascript
// 获取全部数据
list(this.queryParams).then(response => {
  this.list = response.rows  // 全部数据
  this.total = response.total
})

// 表格显示当前页数据
:data="list.slice((pageNum-1)*pageSize, pageNum*pageSize)"
```

### 8.2 序号计算

```javascript
// 序号 = (当前页 -1) * 每页数量 + 索引 + 1
{{ (pageNum - 1) * pageSize + scope.$index + 1 }}
```

---

## 九、优化建议

### 9.1 性能优化

- Redis keys 操作可能较慢，注意性能监控
- 大数据量时限制前端分页数量
- 避免频繁刷新（可添加自动刷新间隔）

### 9.2 用户体验

- 加载状态提示（v-loading）
- 操作成功/失败提示
- 二次确认防止误操作
- 支持手动刷新

### 9.3 安全建议

- 不能强制退出自己（前端判断）
- 强退操作需二次确认
- 敏感操作记录日志

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
