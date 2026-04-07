# 001-用户管理 - 前端页面

**模块编号：** 001  
**模块名称：** 用户管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、页面概述

**页面路径：** `ruoyi-ui/src/views/system/user/`

**主要文件：**
- `index.vue` - 用户管理主页面
- `authRole.vue` - 用户授权角色页面
- `profile/index.vue` - 个人中心（独立模块）

---

## 二、用户管理主页面 (index.vue)

### 2.1 页面布局

```
┌─────────────────────────────────────────────────────────┐
│ 搜索栏                                                   │
│ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ │
│ │用户账号 │ │手机号码 │ │  状态  │ │  部门  │ │  搜索  │ │
│ └────────┘ └────────┘ └────────┘ └────────┘ └────────┘ │
├─────────────────────────────────────────────────────────┤
│ 工具栏                                                   │
│ [新增] [修改] [删除] [导出] [导入]                       │
├─────────────────────────────────────────────────────────┤
│ 数据表格                                                 │
│ ┌────┬──────┬──────┬──────┬──────┬──────┬──────┬────┐ │
│ │选择│账号  │昵称  │部门  │手机  │状态  │时间  │操作│ │
│ ├────┼──────┼──────┼──────┼──────┼──────┼──────┼────┤ │
│ │ ☐  │admin │管理员│研发部│158** │正常  │03-12 │编辑│ │
│ │    │      │      │      │      │      │      │删除│ │
│ │    │      │      │      │      │      │      │更多│ │
│ └────┴──────┴──────┴──────┴──────┴──────┴──────┴────┘ │
├─────────────────────────────────────────────────────────┤
│ 分页                                                     │
│ 共 100 条  < 1 2 3 ... 10 >                              │
└─────────────────────────────────────────────────────────┘
```

### 2.2 搜索区域

**搜索字段：**

| 字段 | 组件类型 | 说明 |
|------|---------|------|
| 用户账号 | Input | 模糊匹配 |
| 手机号码 | Input | 模糊匹配 |
| 状态 | Select | 0-正常/1-停用 |
| 部门 | Treeselect | 树形选择器 |

**操作按钮：**
- 搜索：执行查询
- 重置：清空搜索条件

### 2.3 工具栏

**按钮列表：**

| 按钮 | 权限 | 说明 |
|------|------|------|
| 新增 | `system:user:add` | 打开新增对话框 |
| 修改 | `system:user:edit` | 修改选中用户（单选） |
| 删除 | `system:user:remove` | 删除选中用户（支持批量） |
| 导出 | `system:user:export` | 导出当前查询结果 |
| 导入 | `system:user:import` | 打开导入对话框 |

### 2.4 数据表格

**列定义：**

| 列名 | 字段 | 宽度 | 说明 |
|------|------|------|------|
| 选择 | selection | 50 | 多选框 |
| 用户账号 | userName | 100 | - |
| 用户昵称 | nickName | 100 | - |
| 部门 | dept.deptName | 120 | - |
| 手机号码 | phonenumber | 120 | - |
| 状态 | status | 80 | 开关组件 |
| 创建时间 | createTime | 160 | 格式化显示 |
| 操作 | - | 200 | 操作按钮组 |

**操作列按钮：**

| 按钮 | 权限 | 说明 |
|------|------|------|
| 编辑 | `system:user:edit` | 修改用户 |
| 删除 | `system:user:remove` | 删除用户 |
| 重置密码 | `system:user:resetPwd` | 重置密码 |
| 分配角色 | `system:user:edit` | 打开授权对话框 |

### 2.5 新增/编辑对话框

**表单字段：**

| 字段 | 组件类型 | 必填 | 验证规则 |
|------|---------|------|---------|
| 用户账号 | Input | 是 | 2-30 字符 |
| 用户昵称 | Input | 是 | 0-30 字符 |
| 所属部门 | Treeselect | 是 | - |
| 登录密码 | Input | 新增必填 | - |
| 手机号码 | Input | 否 | 11 位 |
| 邮箱 | Input | 否 | 邮箱格式 |
| 性别 | Radio | 否 | 0-男/1-女/2-未知 |
| 状态 | Radio | 否 | 0-正常/1-停用 |
| 岗位 | Select | 否 | 多选 |
| 角色 | Select | 否 | 多选 |
| 备注 | Input | 否 | 500 字符 |

**表单布局：** 使用 Element UI Form 组件，两列布局

**提交逻辑：**
1. 表单验证
2. 检查唯一性（账号、手机、邮箱）
3. 提交 API
4. 刷新列表

### 2.6 角色授权对话框

**页面组件：** `authRole.vue`

**布局：**

```
┌────────────────────────────────────┐
│ 用户信息：admin - 管理员            │
├────────────────────────────────────┤
│ 角色列表：                          │
│ ☑ 超级管理员                        │
│ ☐ 普通角色                          │
│ ☐ 访客角色                          │
├────────────────────────────────────┤
│          [取消]  [提交]            │
└────────────────────────────────────┘
```

**实现逻辑：**
1. 加载用户信息
2. 加载所有角色列表
3. 标记已分配角色
4. 提交角色 ID 数组

### 2.7 导入对话框

**功能：**

1. 下载导入模板
2. 选择 Excel 文件
3. 选择是否更新已存在用户
4. 上传并显示结果

**导入结果展示：**
- 成功数量
- 失败数量
- 失败原因详情

---

## 三、API 调用

### 3.1 API 文件路径

`ruoyi-ui/src/api/system/user.js`

### 3.2 API 方法

```javascript
// 查询用户列表
export function listUser(query) {
  return request({
    url: '/system/user/list',
    method: 'get',
    params: query
  })
}

// 查询用户详细
export function getUser(userId) {
  return request({
    url: '/system/user/' + userId,
    method: 'get'
  })
}

// 新增用户
export function addUser(data) {
  return request({
    url: '/system/user',
    method: 'post',
    data: data
  })
}

// 修改用户
export function updateUser(data) {
  return request({
    url: '/system/user',
    method: 'put',
    data: data
  })
}

// 删除用户
export function delUser(userId) {
  return request({
    url: '/system/user/' + userId,
    method: 'delete'
  })
}

// 重置密码
export function resetUserPwd(data) {
  return request({
    url: '/system/user/resetPwd',
    method: 'put',
    data: data
  })
}

// 状态修改
export function changeUserStatus(data) {
  return request({
    url: '/system/user/changeStatus',
    method: 'put',
    data: data
  })
}

// 获取授权角色
export function authRole(userId) {
  return request({
    url: '/system/user/authRole/' + userId,
    method: 'get'
  })
}

// 分配角色
export function updateAuthRole(data) {
  return request({
    url: '/system/user/authRole',
    method: 'put',
    params: data
  })
}

// 导出用户
export function exportUser(query) {
  return request({
    url: '/system/user/export',
    method: 'post',
    params: query,
    responseType: 'blob'
  })
}

// 导入用户
export function importUser(data) {
  return request({
    url: '/system/user/importData',
    method: 'post',
    data: data
  })
}

// 下载模板
export function importTemplate() {
  return request({
    url: '/system/user/importTemplate',
    method: 'post',
    responseType: 'blob'
  })
}

// 获取部门树
export function deptTree() {
  return request({
    url: '/system/user/deptTree',
    method: 'get'
  })
}
```

---

## 四、组件依赖

### 4.1 使用的外部组件

| 组件 | 来源 | 用途 |
|------|------|------|
| Treeselect | @riophae/vue-treeselect | 部门树形选择 |
| Pagination | @/components/Pagination | 分页组件 |
| RightToolbar | @/components/RightToolbar | 右侧工具栏 |

### 4.2 使用的指令

| 指令 | 用途 |
|------|------|
| v-hasPermi | 权限控制（按钮显示/隐藏） |

### 4.3 使用的 Mixins

| Mixin | 用途 |
|-------|------|
| @/mixins | 通用混入（未使用） |

---

## 五、状态管理

### 5.1 页面状态

```javascript
data() {
  return {
    // 遮罩层
    loading: true,
    // 选中数组
    ids: [],
    // 非单个禁用
    single: true,
    // 非多个禁用
    multiple: true,
    // 显示搜索条件
    showSearch: true,
    // 总条数
    total: 0,
    // 用户表格数据
    userList: [],
    // 弹出层标题
    title: "",
    // 部门数据
    deptOptions: [],
    // 岗位数据
    postOptions: [],
    // 角色数据
    roleOptions: [],
    // 是否显示弹出层
    open: false,
    // 是否显示分配角色弹出层
    openAuthRole: false,
    // 是否显示导入弹出层
    openImport: false,
    // 查询参数
    queryParams: {},
    // 表单参数
    form: {},
    // 用户授权角色信息
    authRole: {}
  }
}
```

---

## 六、权限控制

### 6.1 按钮权限

使用 `v-hasPermi` 指令控制按钮显示：

```vue
<el-button
  type="primary"
  plain
  icon="Plus"
  v-hasPermi="['system:user:add']"
  @click="handleAdd"
>新增</el-button>
```

### 6.2 行操作权限

```vue
<el-button
  link
  type="primary"
  icon="Edit"
  v-hasPermi="['system:user:edit']"
  @click="handleUpdate(row)"
>编辑</el-button>

<el-button
  link
  type="primary"
  icon="Delete"
  v-hasPermi="['system:user:remove']"
  @click="handleDelete(row)"
>删除</el-button>
```

---

## 七、交互细节

### 7.1 状态切换

- 使用 `el-switch` 组件
- 切换时调用 `changeUserStatus` API
- 超级管理员不可停用

### 7.2 批量删除

- 选中多行后启用删除按钮
- 删除前确认提示
- 不允许删除当前用户和超级管理员

### 7.3 表单验证

- 使用 Element UI Form 验证
- 自定义验证规则（唯一性检查）
- 实时验证与提交前验证结合

### 7.4 文件上传

- 使用 `el-upload` 组件
- 限制文件类型为 xlsx/xls
- 上传后显示导入结果

---

## 八、响应式设计

- 表格支持横向滚动
- 对话框自适应屏幕宽度
- 移动端优化（未完全适配）

---

## 九、扩展点

1. **自定义列显示**：可扩展列配置功能
2. **高级搜索**：可扩展更多搜索条件
3. **批量操作**：可扩展批量修改岗位/角色
4. **用户导入模板定制**：可自定义导入字段
