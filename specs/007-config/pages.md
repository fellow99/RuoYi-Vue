# 007-Config 参数管理模块前端页面

## 1. 页面结构

### 1.1 参数配置管理页面

**文件路径：** `ruoyi-ui/src/views/system/config/index.vue`

**路由配置：**
```javascript
{
  path: '/system/config',
  component: Layout,
  hidden: false,
  children: [{
    path: 'config',
    component: () => import('@/views/system/config/index'),
    name: 'Config',
    meta: { title: '参数设置', icon: 'form' }
  }]
}
```

## 2. 页面功能

### 2.1 搜索区域
- 参数名称（文本输入，模糊查询）
- 参数键名（文本输入，模糊查询）
- 系统内置（下拉选择：全部/是/否）
- 创建时间（日期范围选择器）
- 搜索按钮
- 重置按钮

### 2.2 操作按钮
- 新增（权限：system:config:add）
- 修改（权限：system:config:edit，单选）
- 删除（权限：system:config:remove，多选）
- 导出（权限：system:config:export）
- 刷新缓存（权限：system:config:remove）

### 2.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 参数主键 | configId | 参数配置 ID |
| 参数名称 | configName | 参数配置名称 |
| 参数键名 | configKey | 参数配置键名 |
| 参数键值 | configValue | 参数配置键值 |
| 系统内置 | configType | 使用 dict-tag 组件显示（是/否） |
| 备注 | remark | 备注信息 |
| 创建时间 | createTime | 格式化显示（yyyy-MM-dd HH:mm:ss） |
| 操作 | - | 修改、删除按钮 |

### 2.4 新增/修改对话框
- 参数名称（必填，文本输入）
- 参数键名（必填，文本输入）
- 参数键值（必填，文本域）
- 系统内置（必填，单选：是/否）
- 备注（可选，文本域）

## 3. 组件事件

```javascript
// 查询列表
getList()

// 搜索
handleQuery()

// 重置搜索
resetQuery()

// 新增
handleAdd()

// 修改
handleUpdate(row)

// 删除
handleDelete(row)

// 导出
handleExport()

// 刷新缓存
handleRefreshCache()

// 取消对话框
cancel()

// 表单重置
reset()

// 提交表单
submitForm()

// 多选框选中数据
handleSelectionChange(selection)
```

## 4. 表单校验规则

```javascript
rules: {
  configName: [
    { required: true, message: "参数名称不能为空", trigger: "blur" }
  ],
  configKey: [
    { required: true, message: "参数键名不能为空", trigger: "blur" }
  ],
  configValue: [
    { required: true, message: "参数键值不能为空", trigger: "blur" }
  ]
}
```

## 5. 使用的 API

```javascript
import { 
  listConfig,      // 查询参数列表
  getConfig,       // 查询参数详情
  delConfig,       // 删除参数配置
  addConfig,       // 新增参数配置
  updateConfig,    // 修改参数配置
  refreshCache     // 刷新参数缓存
} from "@/api/system/config"
```

## 6. 使用的字典

```javascript
dicts: ['sys_yes_no']
```

## 7. 数据模型

### 7.1 查询参数
```javascript
queryParams: {
  pageNum: 1,
  pageSize: 10,
  configName: undefined,
  configKey: undefined,
  configType: undefined
}
```

### 7.2 表单参数
```javascript
form: {
  configId: undefined,
  configName: undefined,
  configKey: undefined,
  configValue: undefined,
  configType: "Y",
  remark: undefined
}
```

### 7.3 其他状态
```javascript
data() {
  return {
    loading: true,        // 遮罩层
    ids: [],              // 选中数组
    single: true,         // 非单个禁用
    multiple: true,       // 非多个禁用
    showSearch: true,     // 显示搜索条件
    total: 0,             // 总条数
    configList: [],       // 参数表格数据
    title: "",            // 弹出层标题
    open: false,          // 是否显示弹出层
    dateRange: []         // 日期范围
  }
}
```

## 8. 页面样式

- 使用 Element UI 组件库
- 响应式布局，支持不同屏幕尺寸
- 表格支持列宽自适应
- 对话框固定宽度 500px
- 操作按钮使用图标 + 文字形式
- 搜索表单 label-width="68px"
- 表单 label-width="80px"

## 9. 用户体验优化

1. 搜索表单支持回车键触发搜索
2. 删除操作需要二次确认
3. 操作成功后自动刷新列表
4. 操作成功/失败有明确提示
5. 列表支持分页
6. 表格列支持溢出提示（show-overflow-tooltip）
7. 内置参数删除时显示友好错误提示
8. 刷新缓存后显示成功提示

## 10. 特殊处理

### 10.1 日期范围处理
```javascript
// 查询时添加日期范围
listConfig(this.addDateRange(this.queryParams, this.dateRange))

// 重置时清空日期范围
this.dateRange = []
```

### 10.2 删除确认
```javascript
this.$modal.confirm('是否确认删除参数编号为"' + configIds + '"的数据项？')
  .then(() => delConfig(configIds))
  .then(() => {
    this.getList()
    this.$modal.msgSuccess("删除成功")
  })
```

### 10.3 刷新缓存
```javascript
handleRefreshCache() {
  refreshCache().then(() => {
    this.$modal.msgSuccess("刷新成功")
  })
}
```

## 11. 权限控制

- 新增按钮：`v-hasPermi="['system:config:add']"`
- 修改按钮：`v-hasPermi="['system:config:edit']"`
- 删除按钮：`v-hasPermi="['system:config:remove']"`
- 导出按钮：`v-hasPermi="['system:config:export']"`
- 刷新缓存：`v-hasPermi="['system:config:remove']"`
