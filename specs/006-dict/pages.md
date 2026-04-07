# 006-Dict 字典管理模块前端页面

## 1. 页面结构

### 1.1 字典类型管理页面

**文件路径：** `ruoyi-ui/src/views/system/dict/type.vue`（或 index.vue）

**路由配置：**
```javascript
{
  path: '/system/dict-type',
  component: Layout,
  hidden: false,
  children: [{
    path: 'type',
    component: () => import('@/views/system/dict/type'),
    name: 'DictType',
    meta: { title: '字典类型', icon: 'form' }
  }]
}
```

### 1.2 字典数据管理页面

**文件路径：** `ruoyi-ui/src/views/system/dict/data.vue`（或 index.vue）

**路由配置：**
```javascript
{
  path: '/system/dict-data',
  component: Layout,
  hidden: false,
  children: [{
    path: 'data',
    component: () => import('@/views/system/dict/data'),
    name: 'DictData',
    meta: { title: '字典数据', icon: 'form' }
  }]
}
```

## 2. 字典类型页面功能

### 2.1 搜索区域
- 字典名称（文本输入，模糊查询）
- 字典类型（文本输入，模糊查询）
- 状态（下拉选择：全部/正常/停用）
- 搜索按钮
- 重置按钮

### 2.2 操作按钮
- 新增（权限：system:dict:add）
- 修改（权限：system:dict:edit，单选）
- 删除（权限：system:dict:remove，多选）
- 导出（权限：system:dict:export）
- 刷新缓存（权限：system:dict:remove）

### 2.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 字典主键 | dictId | 字典类型 ID |
| 字典名称 | dictName | 字典类型名称 |
| 字典类型 | dictType | 字典类型标识 |
| 状态 | status | 使用 dict-tag 组件显示（正常/停用） |
| 备注 | remark | 备注信息 |
| 创建时间 | createTime | 格式化显示 |
| 操作 | - | 修改、删除按钮 |

### 2.4 新增/修改对话框
- 字典名称（必填，文本输入）
- 字典类型（必填，文本输入，格式校验：字母开头，小写字母 + 数字 + 下划线）
- 状态（必填，单选：正常/停用）
- 备注（可选，文本域）

## 3. 字典数据页面功能

### 3.1 搜索区域
- 字典类型（下拉选择，从字典类型管理获取）
- 字典标签（文本输入，模糊查询）
- 状态（下拉选择：全部/正常/停用）
- 搜索按钮
- 重置按钮

### 3.2 操作按钮
- 新增（权限：system:dict:add）
- 修改（权限：system:dict:edit，单选）
- 删除（权限：system:dict:remove，多选）
- 导出（权限：system:dict:export）

### 3.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 字典编码 | dictCode | 字典数据 ID |
| 字典排序 | dictSort | 数值越小越靠前 |
| 字典标签 | dictLabel | 显示给用户看的文本 |
| 字典键值 | dictValue | 实际存储的值 |
| 字典类型 | dictType | 关联的字典类型 |
| 是否默认 | isDefault | 是/否 |
| 状态 | status | 使用 dict-tag 组件显示 |
| 创建时间 | createTime | 格式化显示 |
| 操作 | - | 修改、删除按钮 |

### 3.4 新增/修改对话框
- 字典类型（必填，下拉选择）
- 字典标签（必填，文本输入）
- 字典键值（必填，文本输入）
- 字典排序（可选，数字输入，默认 0）
- 是否默认（可选，单选：是/否）
- 状态（必填，单选：正常/停用）
- 备注（可选，文本域）

## 4. 组件事件

### 4.1 字典类型组件事件
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
```

### 4.2 字典数据组件事件
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
```

## 5. 表单校验规则

### 5.1 字典类型校验
```javascript
rules: {
  dictName: [
    { required: true, message: "字典名称不能为空", trigger: "blur" },
    { min: 0, max: 100, message: "字典名称长度不能超过 100 个字符", trigger: "blur" }
  ],
  dictType: [
    { required: true, message: "字典类型不能为空", trigger: "blur" },
    { min: 0, max: 100, message: "字典类型长度不能超过 100 个字符", trigger: "blur" },
    { pattern: "^[a-z][a-z0-9_]*$", message: "字典类型必须以字母开头，且只能为（小写字母，数字，下滑线）", trigger: "blur" }
  ]
}
```

### 5.2 字典数据校验
```javascript
rules: {
  dictType: [
    { required: true, message: "字典类型不能为空", trigger: "change" }
  ],
  dictLabel: [
    { required: true, message: "字典标签不能为空", trigger: "blur" },
    { min: 0, max: 100, message: "字典标签长度不能超过 100 个字符", trigger: "blur" }
  ],
  dictValue: [
    { required: true, message: "字典键值不能为空", trigger: "blur" },
    { min: 0, max: 100, message: "字典键值长度不能超过 100 个字符", trigger: "blur" }
  ]
}
```

## 6. 使用的 API

### 6.1 字典类型 API
```javascript
import { listType, getType, delType, addType, updateType, refreshCache } from "@/api/system/dict/type"
```

### 6.2 字典数据 API
```javascript
import { listData, getData, delData, addData, updateData } from "@/api/system/dict/data"
```

## 7. 使用的字典

```javascript
dicts: ['sys_normal_disable', 'sys_yes_no']
```

## 8. 页面样式

- 使用 Element UI 组件库
- 响应式布局，支持不同屏幕尺寸
- 表格支持列宽自适应
- 对话框固定宽度 500px
- 操作按钮使用图标 + 文字形式

## 9. 用户体验优化

1. 搜索表单支持回车键触发搜索
2. 删除操作需要二次确认
3. 操作成功后自动刷新列表
4. 操作成功/失败有明确提示
5. 列表支持分页
6. 表格列支持溢出提示（show-overflow-tooltip）
