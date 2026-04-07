# 定时任务前端页面 (013-job)

**模块编号：** 013  
**最后更新：** 2026-03-12

---

## 一、页面概述

### 1.1 页面信息

| 项目 | 说明 |
|------|------|
| 页面名称 | 定时任务 |
| 页面路径 | `/monitor/job` |
| 组件文件 | `ruoyi-ui/src/views/monitor/job/index.vue` |
| 路由名称 | Job |
| 技术栈 | Vue 2.x + Element UI |

### 1.2 页面功能

- 定时任务列表展示
- 多条件查询筛选
- 新增/修改/删除任务
- 任务状态切换
- 立即执行任务
- 查看任务详细
- 查看调度日志
- 导出 Excel 文件

---

## 二、页面布局

### 2.1 整体结构

```
┌─────────────────────────────────────────────────────────┐
│  查询表单区域                                            │
│  ┌─────────────────────────────────────────────────┐    │
│  │ 任务名称 [____] 任务组名 [▼] 任务状态 [▼]       │    │
│  │ [搜索] [重置]                                    │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  工具栏                                                  │
│  [新增] [修改] [删除] [导出] [日志] [显示搜索] [刷新]  │
├─────────────────────────────────────────────────────────┤
│  数据表格                                                │
│  ┌─────────────────────────────────────────────────┐    │
│  │ ☑ │ 编号 │ 名称 │ 组名 │ 调用目标 │ Cron │ 状态 │    │
│  ├─────────────────────────────────────────────────┤    │
│  │ ☐ │ 1 │ 任务 1 │ DEFAULT │ ... │ 0/5*... │ [开关] │    │
│  │   │     │      │       │       │        │  [更多] │    │
│  └─────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  分页组件                                                │
│  共 100 条  [首页] [上一页] 1/10 [下一页] [末页]         │
└─────────────────────────────────────────────────────────┘
```

### 2.2 新增/修改弹窗

```
┌───────────────────────────────────────────────────┐
│  添加任务/修改任务                         [×]    │
├───────────────────────────────────────────────────┤
│  任务名称：[________________]  任务分组：[▼]      │
│  调用方法：[________________] (?)                 │
│  cron 表达式：[________________] [生成表达式]      │
│  任务状态：○正常 ○暂停                            │
│  执行策略：○立即 ○执行一次 ○放弃                  │
│  是否并发：○允许 ○禁止                            │
├───────────────────────────────────────────────────┤
│                      [确定] [取消]                │
└───────────────────────────────────────────────────┘
```

### 2.3 任务详细弹窗

```
┌───────────────────────────────────────────────────┐
│  任务详细                                  [×]    │
├───────────────────────────────────────────────────┤
│  任务编号：1                                      │
│  任务名称：测试任务                               │
│  任务分组：默认组                                 │
│  创建时间：2026-03-12 10:00:00                    │
│  cron 表达式：0/5 * * * * ?                        │
│  下次执行时间：2026-03-12 10:05:00                │
│  调用目标方法：ryTask.ryParams('test')            │
│  任务状态：正常                                   │
│  是否并发：禁止                                   │
│  执行策略：放弃执行                               │
├───────────────────────────────────────────────────┤
│                                  [关闭]           │
└───────────────────────────────────────────────────┘
```

---

## 三、组件详情

### 3.1 查询表单

**表单字段：**

| 字段 | 类型 | 占位符 | 数据源 |
|------|------|--------|--------|
| jobName | Input | 请输入任务名称 | - |
| jobGroup | Select | 请选择任务组名 | sys_job_group |
| status | Select | 请选择任务状态 | sys_job_status |

### 3.2 工具栏

**按钮列表：**

| 按钮 | 图标 | 权限 | 说明 |
|------|------|------|------|
| 新增 | el-icon-plus | monitor:job:add | 新增任务 |
| 修改 | el-icon-edit | monitor:job:edit | 修改选中任务 |
| 删除 | el-icon-delete | monitor:job:remove | 删除选中任务 |
| 导出 | el-icon-download | monitor:job:export | 导出任务 |
| 日志 | el-icon-s-operation | monitor:job:query | 查看调度日志 |

### 3.3 数据表格

**列定义：**

| 列名 | 字段 | 宽度 | 说明 |
|------|------|------|------|
| 选择框 | - | 55 | 多选框 |
| 任务编号 | jobId | 100 | 任务 ID |
| 任务名称 | jobName | - | 任务名称 |
| 任务组名 | jobGroup | - | 字典标签 |
| 调用目标字符串 | invokeTarget | - | 调用方法 |
| cron 执行表达式 | cronExpression | - | Cron 表达式 |
| 状态 | status | - | 开关组件 |
| 操作 | - | - | 修改/删除/更多 |

**更多菜单：**
- 执行一次（monitor:job:changeStatus）
- 任务详细（monitor:job:query）
- 调度日志（monitor:job:query）

### 3.4 表单字段

**新增/修改表单：**

| 字段 | 类型 | 必填 | 验证 |
|------|------|------|------|
| jobName | Input | 是 | 不能为空，≤64 字符 |
| jobGroup | Select | 是 | 选择任务组 |
| invokeTarget | Input | 是 | 不能为空，≤500 字符 |
| cronExpression | Input | 是 | 不能为空，≤255 字符 |
| misfirePolicy | Radio | 否 | 默认 1（立即执行） |
| concurrent | Radio | 否 | 默认 1（禁止并发） |
| status | Radio | 否 | 默认 0（正常） |

---

## 四、交互逻辑

### 4.1 查询操作

```javascript
handleQuery() {
  this.queryParams.pageNum = 1
  this.getList()
}

resetQuery() {
  this.resetForm("queryForm")
  this.handleQuery()
}
```

### 4.2 状态切换

```javascript
handleStatusChange(row) {
  let text = row.status === "0" ? "启用" : "停用"
  this.$modal.confirm('确认要"' + text + '""' + row.jobName + '"任务吗？')
    .then(() => changeJobStatus(row.jobId, row.status))
    .then(() => this.$modal.msgSuccess(text + "成功"))
    .catch(() => row.status = row.status === "0" ? "1" : "0")
}
```

### 4.3 立即执行

```javascript
handleRun(row) {
  this.$modal.confirm('确认要立即执行一次"' + row.jobName + '"任务吗？')
    .then(() => runJob(row.jobId, row.jobGroup))
    .then(() => this.$modal.msgSuccess("执行成功"))
}
```

### 4.4 查看详细

```javascript
handleView(row) {
  getJob(row.jobId).then(response => {
    this.form = response.data
    this.openView = true
  })
}
```

### 4.5 查看日志

```javascript
handleJobLog(row) {
  const jobId = row.jobId || 0
  this.$router.push('/monitor/job-log/index/' + jobId)
}
```

### 4.6 Cron 表达式生成

```javascript
handleShowCron() {
  this.expression = this.form.cronExpression
  this.openCron = true
}

crontabFill(value) {
  this.form.cronExpression = value
}
```

---

## 五、数据字典

### 5.1 使用的字典

| 字典类型 | 字典名称 | 用途 |
|----------|----------|------|
| sys_job_group | 任务组名 | 任务分组选择 |
| sys_job_status | 任务状态 | 任务状态展示 |

### 5.2 字典配置

```javascript
export default {
  dicts: ['sys_job_group', 'sys_job_status']
}
```

---

## 六、路由配置

### 6.1 路由定义

```javascript
{
  path: '/monitor/job',
  component: Layout,
  hidden: false,
  children: [{
    path: 'index',
    component: () => import('@/views/monitor/job'),
    name: 'Job',
    meta: { title: '定时任务', icon: 'job' }
  }]
}
```

### 6.2 任务日志路由

```javascript
{
  path: '/monitor/job-log',
  component: Layout,
  hidden: true,
  children: [{
    path: 'index/:jobId(\\d+)',
    component: () => import('@/views/monitor/job/log'),
    name: 'JobLog',
    meta: { title: '任务日志' }
  }]
}
```

---

## 七、组件依赖

### 7.1 引入组件

```javascript
import { listJob, getJob, delJob, addJob, updateJob, runJob, changeJobStatus } from "@/api/monitor/job"
import Crontab from '@/components/Crontab'
```

### 7.2 自定义组件

- `Crontab`: Cron 表达式生成器
- `dict-tag`: 字典标签展示
- `right-toolbar`: 右侧工具栏
- `pagination`: 分页组件

---

## 八、表单验证

### 8.1 验证规则

```javascript
rules: {
  jobName: [
    { required: true, message: "任务名称不能为空", trigger: "blur" }
  ],
  invokeTarget: [
    { required: true, message: "调用目标字符串不能为空", trigger: "blur" }
  ],
  cronExpression: [
    { required: true, message: "cron 执行表达式不能为空", trigger: "blur" }
  ]
}
```

### 8.2 提交验证

```javascript
submitForm: function() {
  this.$refs["form"].validate(valid => {
    if (valid) {
      if (this.form.jobId != undefined) {
        updateJob(this.form).then(...)
      } else {
        addJob(this.form).then(...)
      }
    }
  })
}
```

---

## 九、优化建议

### 9.1 性能优化

- 列表数据分页加载
- 避免频繁查询
- Cron 表达式生成器按需加载

### 9.2 用户体验

- 加载状态提示
- 操作成功/失败提示
- 二次确认防止误操作
- Cron 表达式生成器辅助输入

### 9.3 安全建议

- 调用目标白名单提示
- 危险调用警告
- 敏感操作二次确认

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
