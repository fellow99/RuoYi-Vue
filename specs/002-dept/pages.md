# 002-部门管理 - 前端页面

**模块编号：** 002  
**模块名称：** 部门管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、页面概述

**页面路径：** `ruoyi-ui/src/views/system/dept/`

**主要文件：**
- `index.vue` - 部门管理主页面

---

## 二、页面布局

```
┌─────────────────────────────────────────────────────────┐
│ 搜索栏                                                   │
│ ┌────────┐ ┌────────┐ ┌────────┐                        │
│ │部门名称 │ │  状态  │ │  搜索  │                        │
│ └────────┘ └────────┘ └────────┘                        │
├─────────────────────────────────────────────────────────┤
│ 工具栏                                                   │
│ [新增] [展开/折叠]                                       │
├─────────────────────────────────────────────────────────┤
│ 树形表格                                                 │
│ ┌──────────────────────────────────────────────────┐   │
│ │ > 若依科技                                        │   │
│ │   > 深圳分公司                                    │   │
│ │     > 研发部门                                    │   │
│ │     > 市场部门                                    │   │
│ │   > 北京分公司                                    │   │
│ └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 三、功能区域

### 3.1 搜索区域

**搜索字段：**

| 字段 | 组件类型 | 说明 |
|------|---------|------|
| 部门名称 | Input | 模糊匹配 |
| 状态 | Select | 0-正常/1-停用 |

**操作按钮：**
- 搜索：执行查询
- 重置：清空搜索条件

### 3.2 工具栏

**按钮列表：**

| 按钮 | 权限 | 说明 |
|------|------|------|
| 新增 | `system:dept:add` | 打开新增对话框 |
| 展开/折叠 | - | 切换树形展开状态 |

### 3.3 树形表格

**列定义：**

| 列名 | 字段 | 宽度 | 说明 |
|------|------|------|------|
| 部门名称 | deptName | - | 树形节点 |
| 显示顺序 | orderNum | 100 | - |
| 负责人 | leader | 100 | - |
| 联系电话 | phone | 120 | - |
| 状态 | status | 100 | 开关组件 |
| 创建时间 | createTime | 160 | 格式化显示 |
| 操作 | - | 200 | 操作按钮组 |

**操作列按钮：**

| 按钮 | 权限 | 说明 |
|------|------|------|
| 新增 | `system:dept:add` | 新增子部门 |
| 编辑 | `system:dept:edit` | 修改部门 |
| 删除 | `system:dept:remove` | 删除部门 |

---

## 四、新增/编辑对话框

**表单字段：**

| 字段 | 组件类型 | 必填 | 验证规则 |
|------|---------|------|---------|
| 上级部门 | Treeselect | 是 | - |
| 部门名称 | Input | 是 | 30 字符内 |
| 显示顺序 | InputNumber | 是 | - |
| 负责人 | Input | 否 | 50 字符内 |
| 联系电话 | Input | 否 | 11 位 |
| 邮箱 | Input | 否 | 邮箱格式 |
| 状态 | Radio | 否 | 0-正常/1-停用 |

**表单布局：** 使用 Element UI Form 组件，单列布局

**特殊逻辑：**
- 新增时：上级部门不能选择自己
- 修改时：排除当前部门及子部门
- 停用时：检查是否有正常子部门

---

## 五、API 调用

### 5.1 API 文件路径

`ruoyi-ui/src/api/system/dept.js`

### 5.2 API 方法

```javascript
// 查询部门列表
export function listDept(query) {
  return request({
    url: '/system/dept/list',
    method: 'get',
    params: query
  })
}

// 查询部门列表（排除节点）
export function listDeptExcludeChild(deptId) {
  return request({
    url: '/system/dept/list/exclude/' + deptId,
    method: 'get'
  })
}

// 查询部门详细
export function getDept(deptId) {
  return request({
    url: '/system/dept/' + deptId,
    method: 'get'
  })
}

// 新增部门
export function addDept(data) {
  return request({
    url: '/system/dept',
    method: 'post',
    data: data
  })
}

// 修改部门
export function updateDept(data) {
  return request({
    url: '/system/dept',
    method: 'put',
    data: data
  })
}

// 删除部门
export function delDept(deptId) {
  return request({
    url: '/system/dept/' + deptId,
    method: 'delete'
  })
}
```

---

## 六、组件依赖

### 6.1 使用的外部组件

| 组件 | 来源 | 用途 |
|------|------|------|
| Treeselect | @riophae/vue-treeselect | 部门树形选择 |

### 6.2 使用的指令

| 指令 | 用途 |
|------|------|
| v-hasPermi | 权限控制（按钮显示/隐藏） |

---

## 七、状态管理

```javascript
data() {
  return {
    // 遮罩层
    loading: true,
    // 显示搜索条件
    showSearch: true,
    // 部门表格数据
    deptList: [],
    // 弹出层标题
    title: "",
    // 是否显示弹出层
    open: false,
    // 查询参数
    queryParams: {},
    // 表单参数
    form: {},
    // 部门选项
    deptOptions: []
  }
}
```

---

## 八、树形数据处理

### 8.1 树形构建

```javascript
// 构建部门树
function buildDeptTree(list) {
  const tree = []
  list.forEach(item => {
    if (item.parentId === 0) {
      tree.push(item)
      buildChildren(item, list)
    }
  })
  return tree
}

function buildChildren(parent, list) {
  parent.children = list.filter(item => item.parentId === parent.deptId)
  parent.children.forEach(child => buildChildren(child, list))
}
```

### 8.2 展开/折叠

```javascript
// 切换展开状态
toggleExpand() {
  this.isExpand = !this.isExpand
  // 设置所有节点展开状态
}
```

---

## 九、权限控制

### 9.1 按钮权限

```vue
<el-button
  type="primary"
  plain
  icon="Plus"
  v-hasPermi="['system:dept:add']"
  @click="handleAdd"
>新增</el-button>
```

### 9.2 行操作权限

```vue
<el-button
  link
  type="primary"
  icon="Edit"
  v-hasPermi="['system:dept:edit']"
  @click="handleUpdate(row)"
>编辑</el-button>

<el-button
  link
  type="primary"
  icon="Delete"
  v-hasPermi="['system:dept:remove']"
  @click="handleDelete(row)"
>删除</el-button>
```

---

## 十、交互细节

### 10.1 状态切换

- 使用 `el-switch` 组件
- 切换时检查是否有正常子部门
- 有正常子部门时不允许停用

### 10.2 删除确认

- 删除前检查是否有子部门
- 删除前检查是否有用户
- 确认后执行删除

### 10.3 上级部门选择

- 新增时：排除当前部门（避免循环）
- 修改时：排除当前部门及子部门
- 使用 `listDeptExcludeChild` API

---

## 十一、注意事项

1. **树形数据加载**：一次性加载所有部门，前端构建树形
2. **祖先节点维护**：新增/修改时需正确维护 `ancestors` 字段
3. **停用顺序**：从下往上停用（先停子部门）
4. **删除顺序**：从下往上删除（先删子部门）
