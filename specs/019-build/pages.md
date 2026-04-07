# 019-在线构建器 - 前端页面

**模块编号：** 019  
**模块名称：** 在线构建器 (Form Builder / 表单构建器)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、页面概述

**页面路径：** `ruoyi-ui/src/views/tool/build/`

**主要文件：**
- `index.vue` - 表单构建器主页面
- `RightPanel.vue` - 右侧属性配置面板
- `CodeTypeDialog.vue` - 代码类型选择对话框
- `DraggableItem.vue` - 可拖拽组件项
- `IconsDialog.vue` - 图标选择对话框
- `TreeNodeDialog.vue` - 树节点对话框

**页面类型：** 可视化表单设计器

**功能说明：** 提供拖拽式的表单设计界面，支持组件拖拽、属性配置、代码生成

---

## 二、页面布局

### 2.1 整体布局

```
┌─────────────────────────────────────────────────────────────────┐
│  Form Generator                                                  │
├─────────────┬───────────────────────────────┬───────────────────┤
│             │                               │                   │
│  组件库     │        画布区域               │   属性配置面板    │
│  (左侧)     │        (中间)                 │    (右侧)         │
│             │                               │                   │
│ ┌─────────┐ │ ┌───────────────────────────┐ │ ┌───────────────┐ │
│ │输入型   │ │ │  [导出] [复制] [清空]     │ │ │ 组件属性 |    │ │
│ ├─────────┤ │ ├───────────────────────────┤ │ │ 表单属性      │ │
│ │单行文本 │ │ │                           │ │ ├───────────────┤ │
│ │多行文本 │ │ │  ┌─────────────────────┐  │ │ │               │ │
│ │密码     │ │ │  │ 单行文本            │  │ │ │ 字段名：     │ │
│ │计数器   │ │ │  │ [请输入]            │  │ │ │ [field101]   │ │
│ ├─────────┤ │ │  └─────────────────────┘  │ │ │               │ │
│ │选择型   │ │ │                           │ │ │ 标题：       │ │
│ ├─────────┤ │ │  ┌─────────────────────┐  │ │ │ [单行文本]   │ │
│ │下拉选择 │ │ │  │ 下拉选择            │  │ │ │               │ │
│ │级联选择 │ │ │  │ [请选择]            │  │ │ │ 占位提示：   │ │
│ │单选框组 │ │ │  └─────────────────────┘  │ │ │ [请输入]     │ │
│ │多选框组 │ │ │                           │ │ │               │ │
│ │开关     │ │ │  从左侧拖入或点选组件     │ │ │ 表单栅格：   │ │
│ │滑块     │ │ │  进行表单设计             │ │ │ [====|====]  │ │
│ │时间选择 │ │ │                           │ │ │               │ │
│ │日期选择 │ │ │                           │ │ │ 是否必填：   │ │
│ ├─────────┤ │ │                           │ │ │ (●)          │ │
│ │布局型   │ │ │                           │ │ │               │ │
│ ├─────────┤ │ │                           │ │ │ 正则校验：   │ │
│ │行容器   │ │ │                           │ │ │ [+] 添加规则  │ │
│ │按钮     │ │ │                           │ │ │               │ │
│ └─────────┘ │ │                           │ │ │               │ │
│             │ │                           │ │ │               │ │
└─────────────┴───────────────────────────────┴───────────────────┘
```

### 2.2 区域划分

| 区域 | 宽度 | 功能 |
|------|------|------|
| 左侧组件库 | 260px | 展示可拖拽的表单组件 |
| 中间画布 | 自适应 | 表单设计区域 |
| 右侧属性面板 | 350px | 配置组件和表单属性 |

---

## 三、核心组件

### 3.1 主页面 (index.vue)

**功能：** 表单构建器主容器

**核心数据：**
```javascript
data() {
  return {
    idGlobal: 100,                    // 全局 ID 计数器
    formConf: formConf,               // 表单配置
    inputComponents: inputComponents, // 输入型组件列表
    selectComponents: selectComponents, // 选择型组件列表
    layoutComponents: layoutComponents, // 布局型组件列表
    drawingList: drawingDefaultValue, // 画布组件列表
    activeId: drawingDefaultValue[0].formId, // 当前选中组件 ID
    activeData: drawingDefaultValue[0] // 当前选中组件数据
  }
}
```

**核心方法：**
```javascript
methods: {
  // 添加组件
  addComponent(item) { ... },
  
  // 克隆组件
  cloneComponent(origin) { ... },
  
  // 选中组件
  activeFormItem(element) { ... },
  
  // 复制组件
  drawingItemCopy(item, parent) { ... },
  
  // 删除组件
  drawingItemDelete(index, parent) { ... },
  
  // 生成代码
  generateCode() { ... },
  
  // 导出文件
  execDownload(data) { ... },
  
  // 复制代码
  execCopy(data) { ... },
  
  // 清空画布
  empty() { ... }
}
```

### 3.2 右侧属性面板 (RightPanel.vue)

**功能：** 配置组件和表单属性

**标签页：**
- **组件属性**：配置选中组件的属性
- **表单属性**：配置整个表单的属性

**核心数据：**
```javascript
data() {
  return {
    currentTab: 'field',              // 当前标签页
    dateTypeOptions: [...],           // 日期类型选项
    colorFormatOptions: [...],        // 颜色格式选项
    justifyOptions: [...],            // 对齐选项
    tagList: [...]                    // 组件类型列表
  }
}
```

**核心方法：**
```javascript
methods: {
  // 添加正则规则
  addReg() { ... },
  
  // 添加选项
  addSelectItem() { ... },
  
  // 添加树节点
  addTreeItem() { ... },
  
  // 设置默认值
  setDefaultValue(val) { ... },
  
  // 默认值输入
  onDefaultValueInput(str) { ... },
  
  // 组件类型切换
  tagChange(tagIcon) { ... }
}
```

### 3.3 可拖拽组件项 (DraggableItem.vue)

**功能：** 画布中的可拖拽组件项

**功能特性：**
- 显示组件预览
- 支持拖拽排序
- 显示复制/删除按钮
- 高亮选中状态

### 3.4 代码类型对话框 (CodeTypeDialog.vue)

**功能：** 选择生成代码的类型

**选项：**
- **页面**：生成完整的 Vue 页面组件
- **组件**：生成可复用的 Vue 组件

### 3.5 图标选择对话框 (IconsDialog.vue)

**功能：** 选择组件图标

**图标来源：** Element UI 图标库

### 3.6 树节点对话框 (TreeNodeDialog.vue)

**功能：** 添加级联选择的树节点

---

## 四、组件库

### 4.1 输入型组件

**组件列表：**

| 组件名称 | 图标 | 说明 |
|---------|------|------|
| 单行文本 | input | 单行文本输入框 |
| 多行文本 | textarea | 多行文本输入框 |
| 密码 | password | 密码输入框 |
| 计数器 | number | 数字计数器 |

### 4.2 选择型组件

**组件列表：**

| 组件名称 | 图标 | 说明 |
|---------|------|------|
| 下拉选择 | select | 下拉选择框 |
| 级联选择 | cascader | 级联选择器 |
| 单选框组 | radio | 单选框组 |
| 多选框组 | checkbox | 多选框组 |
| 开关 | switch | 开关组件 |
| 滑块 | slider | 滑块组件 |
| 时间选择 | time | 时间选择器 |
| 时间范围 | time-range | 时间范围选择器 |
| 日期选择 | date | 日期选择器 |
| 日期范围 | date-range | 日期范围选择器 |
| 评分 | rate | 评分组件 |
| 颜色选择 | color | 颜色选择器 |
| 上传 | upload | 文件上传组件 |

### 4.3 布局型组件

**组件列表：**

| 组件名称 | 图标 | 说明 |
|---------|------|------|
| 行容器 | row | 行布局容器 |
| 按钮 | button | 按钮组件 |

---

## 五、交互操作

### 5.1 添加组件

**方式一：拖拽**
1. 从左侧组件库拖拽组件
2. 移动到中间画布区域
3. 释放鼠标完成添加

**方式二：点击**
1. 点击左侧组件库中的组件
2. 组件自动添加到画布末尾
3. 自动选中添加的组件

### 5.2 调整顺序

1. 拖拽画布中的组件
2. 移动到目标位置
3. 释放鼠标完成排序

### 5.3 选中组件

1. 点击画布中的组件
2. 组件高亮显示
3. 右侧面板显示该组件的属性

### 5.4 复制组件

1. 选中组件
2. 点击组件右上角的复制按钮
3. 组件被复制到下方

### 5.5 删除组件

1. 选中组件
2. 点击组件右上角的删除按钮
3. 组件被删除

### 5.6 清空画布

1. 点击顶部工具栏的"清空"按钮
2. 确认清空操作
3. 画布所有组件被清空

---

## 六、属性配置

### 6.1 通用属性

**所有组件共有：**

| 属性 | 说明 | 配置方式 |
|------|------|---------|
| 字段名 | v-model 绑定变量 | 输入框 |
| 标题 | 组件标签文字 | 输入框 |
| 表单栅格 | 组件占栅格数 | 滑块（1-24） |
| 默认值 | 组件默认值 | 输入框 |
| 是否必填 | 必填校验 | 开关 |
| 是否禁用 | 禁用状态 | 开关 |

### 6.2 专属属性

**单行文本专属：**

| 属性 | 说明 | 配置方式 |
|------|------|---------|
| 占位提示 | 输入框占位提示 | 输入框 |
| 前缀 | 输入框前缀文字 | 输入框 |
| 后缀 | 输入框后缀文字 | 输入框 |
| 前图标 | 输入框前图标 | 输入框 + 选择 |
| 后图标 | 输入框后图标 | 输入框 + 选择 |
| 最大长度 | 最大输入字符数 | 输入框 |
| 显示字数统计 | 显示已输入字数 | 开关 |

**下拉选择专属：**

| 属性 | 说明 | 配置方式 |
|------|------|---------|
| 占位提示 | 选择框占位提示 | 输入框 |
| 选项列表 | 可选项列表 | 动态列表 |
| 是否多选 | 允许多选 | 开关 |
| 是否可搜索 | 支持搜索过滤 | 开关 |
| 选项样式 | 默认/按钮样式 | 单选框 |

### 6.3 表单属性

**配置整个表单：**

| 属性 | 说明 | 配置方式 |
|------|------|---------|
| 表单名 | 表单 ref 引用名 | 输入框 |
| 表单模型 | 数据模型名称 | 输入框 |
| 校验模型 | 校验规则名称 | 输入框 |
| 表单尺寸 | medium/small/mini | 单选框 |
| 标签对齐 | left/right/top | 单选框 |
| 标签宽度 | 标签宽度（像素） | 数字输入 |
| 栅格间隔 | 栅格间隔（像素） | 数字输入 |
| 禁用表单 | 禁用整个表单 | 开关 |
| 表单按钮 | 显示表单按钮 | 开关 |

---

## 七、代码生成

### 7.1 生成流程

1. 完成表单设计
2. 点击"导出 vue 文件"或"复制代码"按钮
3. 弹出代码类型选择对话框
4. 选择生成类型（页面/组件）
5. 系统生成代码
6. 下载文件或复制到剪贴板

### 7.2 生成选项

**导出 vue 文件：**
- 选择生成类型
- 输入文件名
- 下载 .vue 文件

**复制代码：**
- 选择生成类型
- 代码复制到剪贴板
- 可粘贴到任何地方

**运行预览：**
- 选择生成类型
- 弹窗预览效果
- 可测试表单功能

### 7.3 生成代码示例

```vue
<template>
  <el-form ref="elForm" :model="formData" :rules="rules" size="medium" label-position="right">
    <el-row :gutter="15">
      <el-col :span="24">
        <el-form-item label="单行文本" prop="field101">
          <el-input v-model="formData.field101" placeholder="请输入" clearable />
        </el-form-item>
      </el-col>
      <el-col :span="24">
        <el-form-item label="下拉选择" prop="field102">
          <el-select v-model="formData.field102" placeholder="请选择" clearable>
            <el-option label="选项一" value="1" />
            <el-option label="选项二" value="2" />
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
export default {
  data() {
    return {
      formData: {
        field101: undefined,
        field102: undefined
      },
      rules: {
        field101: [
          { required: true, message: '请输入单行文本', trigger: 'blur' }
        ],
        field102: [
          { required: true, message: '请选择下拉选择', trigger: 'change' }
        ]
      }
    }
  }
}
</script>
```

---

## 八、样式说明

### 8.1 布局样式

**左侧组件库：**
```scss
.left-board {
  width: 260px;
  position: absolute;
  left: 0;
  top: 0;
  height: 100vh;
}
```

**中间画布：**
```scss
.center-board {
  height: 100vh;
  width: auto;
  margin: 0 350px 0 260px;
}
```

**右侧属性面板：**
```scss
.right-board {
  width: 350px;
  position: absolute;
  right: 0;
  top: 0;
}
```

### 8.2 组件项样式

**组件库中的组件项：**
```scss
.components-item {
  display: inline-block;
  width: 48%;
  margin: 1%;
}

.components-body {
  padding: 8px 10px;
  background: #f6f7ff;
  cursor: move;
  border: 1px dashed #f6f7ff;
  
  &:hover {
    border: 1px dashed #787be8;
    color: #787be8;
  }
}
```

**画布中的组件项：**
```scss
.drawing-item {
  position: relative;
  cursor: move;
  
  &.active-from-item > .el-form-item {
    background: #f6f7ff;
    border-radius: 6px;
  }
  
  & > .drawing-item-copy,
  & > .drawing-item-delete {
    display: none;
    position: absolute;
    top: -10px;
    width: 22px;
    height: 22px;
    line-height: 22px;
    text-align: center;
    border-radius: 50%;
  }
  
  &:hover > .drawing-item-copy,
  &:hover > .drawing-item-delete {
    display: initial;
  }
}
```

---

## 九、路由配置

### 9.1 路由定义

```javascript
{
  path: '/tool/build',
  component: Layout,
  hidden: false,
  children: [{
    path: 'build',
    component: () => import('@/views/tool/build'),
    name: 'FormBuild',
    meta: { 
      title: '表单构建',
      icon: 'build',
      noCache: true
    }
  }]
}
```

### 9.2 菜单信息

| 属性 | 值 |
|------|-----|
| 菜单名称 | 表单构建 |
| 父级菜单 | 系统工具 |
| 路由路径 | /tool/build |
| 组件路径 | tool/build/index |
| 权限标识 | 无（仅需登录） |
| 图标 | build |
| 是否缓存 | 否 |

---

## 十、注意事项

### 10.1 浏览器兼容性

- 推荐使用 Chrome、Firefox、Edge 等现代浏览器
- 不支持 IE11 及以下版本

### 10.2 数据保存

**重要：** 页面刷新后所有设计数据会丢失

**建议：**
- 及时导出代码
- 复制代码到安全位置
- 完成设计后立即保存

### 10.3 性能优化

- 组件数量较多时可能影响性能
- 建议合理控制表单复杂度
- 复杂表单可分拆为多个子表单

### 10.4 代码集成

生成的代码需要手动集成到项目中：
1. 复制生成的代码
2. 创建新的 .vue 文件
3. 粘贴代码
4. 根据业务需求修改
5. 集成到路由中
