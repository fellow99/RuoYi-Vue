# 008-Notice 通知公告模块前端页面

## 1. 页面结构

### 1.1 通知公告管理页面

**文件路径：** `ruoyi-ui/src/views/system/notice/index.vue`

**路由配置：**
```javascript
{
  path: '/system/notice',
  component: Layout,
  hidden: false,
  children: [{
    path: 'notice',
    component: () => import('@/views/system/notice/index'),
    name: 'Notice',
    meta: { title: '通知公告', icon: 'form' }
  }]
}
```

## 2. 页面功能

### 2.1 搜索区域
- 公告标题（文本输入，模糊查询）
- 公告类型（下拉选择：全部/通知/公告）
- 公告状态（下拉选择：全部/正常/关闭）
- 搜索按钮
- 重置按钮

### 2.2 操作按钮
- 新增（权限：system:notice:add）
- 修改（权限：system:notice:edit，单选）
- 删除（权限：system:notice:remove，多选）

### 2.3 列表展示
| 列名 | 字段 | 说明 |
|------|------|------|
| 选择框 | - | 支持多选 |
| 序号 | - | 行号 |
| 公告标题 | noticeTitle | 公告标题，支持溢出提示 |
| 公告类型 | noticeType | 使用 dict-tag 组件显示（通知/公告） |
| 公告状态 | status | 使用 dict-tag 组件显示（正常/关闭） |
| 创建者 | createBy | 创建人 |
| 创建时间 | createTime | 格式化显示（yyyy-MM-dd HH:mm:ss） |
| 操作 | - | 修改、删除按钮 |

### 2.4 新增/修改对话框
- 公告标题（必填，文本输入，最大长度 50）
- 公告类型（必填，单选：通知/公告）
- 公告内容（必填，富文本编辑器）
- 公告状态（必填，单选：正常/关闭）
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
  noticeTitle: [
    { required: true, message: "公告标题不能为空", trigger: "blur" },
    { min: 0, max: 50, message: "公告标题不能超过 50 个字符", trigger: "blur" }
  ],
  noticeType: [
    { required: true, message: "公告类型不能为空", trigger: "change" }
  ],
  noticeContent: [
    { required: true, message: "公告内容不能为空", trigger: "blur" }
  ]
}
```

## 5. 使用的 API

```javascript
import { 
  listNotice,    // 查询通知公告列表
  getNotice,     // 查询通知公告详情
  delNotice,     // 删除通知公告
  addNotice,     // 新增通知公告
  updateNotice   // 修改通知公告
} from "@/api/system/notice"
```

## 6. 使用的字典

```javascript
dicts: ['sys_notice_type', 'sys_notice_status']
```

## 7. 数据模型

### 7.1 查询参数
```javascript
queryParams: {
  pageNum: 1,
  pageSize: 10,
  noticeTitle: undefined,
  noticeType: undefined,
  status: undefined
}
```

### 7.2 表单参数
```javascript
form: {
  noticeId: undefined,
  noticeTitle: undefined,
  noticeType: undefined,
  noticeContent: undefined,
  status: undefined,
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
    noticeList: [],       // 通知公告表格数据
    title: "",            // 弹出层标题
    open: false           // 是否显示弹出层
  }
}
```

## 8. 页面样式

- 使用 Element UI 组件库
- 响应式布局，支持不同屏幕尺寸
- 表格支持列宽自适应
- 对话框固定宽度 700px（富文本编辑器需要更宽）
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
7. 富文本编辑器提供友好的编辑体验

## 10. 富文本编辑器

### 10.1 编辑器配置
- 支持常见的文本格式化功能
- 支持插入图片、表格、链接等
- 支持 HTML 源码编辑
- 支持全屏编辑

### 10.2 内容处理
```javascript
// 新增时初始化富文本内容
this.form.noticeContent = ''

// 修改时加载富文本内容
getNotice(noticeId).then(response => {
  this.form = response.data
  // 富文本编辑器加载 content
})

// 提交时获取富文本内容
submitForm() {
  this.$refs["form"].validate(valid => {
    if (valid) {
      // 获取富文本内容
      const content = this.$refs.editor.getHtml()
      this.form.noticeContent = content
      // 提交表单
    }
  })
}
```

## 11. 权限控制

- 新增按钮：`v-hasPermi="['system:notice:add']"`
- 修改按钮：`v-hasPermi="['system:notice:edit']"`
- 删除按钮：`v-hasPermi="['system:notice:remove']"`

## 12. 特殊处理

### 12.1 删除确认
```javascript
handleDelete(row) {
  const noticeIds = row.noticeId || this.ids
  this.$modal.confirm('是否确认删除通知公告编号为"' + noticeIds + '"的数据项？')
    .then(() => delNotice(noticeIds))
    .then(() => {
      this.getList()
      this.$modal.msgSuccess("删除成功")
    })
}
```

### 12.2 公告类型显示
```vue
<template slot-scope="scope">
  <dict-tag :options="dict.type.sys_notice_type" :value="scope.row.noticeType"/>
</template>
```

### 12.3 公告状态显示
```vue
<template slot-scope="scope">
  <dict-tag :options="dict.type.sys_notice_status" :value="scope.row.status"/>
</template>
```
