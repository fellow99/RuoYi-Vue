# 019-在线构建器 - 数据模型

**模块编号：** 019  
**模块名称：** 在线构建器 (Form Builder / 表单构建器)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、数据模型概述

在线构建器是一个**纯前端工具**，不依赖后端数据库存储。所有数据都存储在浏览器内存中，支持导出为代码文件。

### 1.1 数据存储方式

| 数据类型 | 存储位置 | 生命周期 |
|---------|---------|---------|
| 组件配置 | 浏览器内存 | 页面刷新后丢失 |
| 表单配置 | 浏览器内存 | 页面刷新后丢失 |
| 生成代码 | 本地文件/剪贴板 | 永久保存 |

### 1.2 无数据库表

**重要说明：** 在线构建器模块**没有数据库表**，所有数据都是运行时内存数据。

---

## 二、核心数据模型

### 2.1 表单配置模型 (formConf)

**说明：** 表单整体配置信息

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| formRef | String | 'elForm' | 表单引用名（ref） |
| formModel | String | 'formData' | 数据模型名称 |
| formRules | String | 'rules' | 校验规则模型名称 |
| size | String | 'medium' | 表单尺寸（medium/small/mini） |
| labelPosition | String | 'right' | 标签位置（left/right/top） |
| labelWidth | Number | 100 | 标签宽度（像素） |
| gutter | Number | 15 | 栅格间隔（像素） |
| disabled | Boolean | false | 是否禁用表单 |
| span | Number | 24 | 默认栅格数 |
| formBtns | Boolean | true | 是否显示表单按钮 |

**数据结构：**
```javascript
const formConf = {
  formRef: 'elForm',
  formModel: 'formData',
  size: 'medium',
  labelPosition: 'right',
  labelWidth: 100,
  formRules: 'rules',
  gutter: 15,
  disabled: false,
  span: 24,
  formBtns: true
}
```

### 2.2 组件基础模型

**说明：** 所有组件的通用属性

| 字段名 | 类型 | 说明 | 示例 |
|-------|------|------|------|
| formId | Number | 组件唯一 ID | 101 |
| renderKey | Number | 渲染 key（用于强制更新） | 1710234567890 |
| tag | String | Element UI 组件标签 | 'el-input' |
| tagIcon | String | 组件图标名称 | 'input' |
| label | String | 字段标签 | '单行文本' |
| span | Number | 栅格数（1-24） | 24 |
| required | Boolean | 是否必填 | true |
| disabled | Boolean | 是否禁用 | false |
| regList | Array | 正则校验规则列表 | [] |

### 2.3 输入型组件模型

#### 2.3.1 单行文本 (el-input)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-input' | 组件标签 |
| tagIcon | String | 'input' | 图标 |
| placeholder | String | '请输入' | 占位提示 |
| defaultValue | Any | undefined | 默认值 |
| clearable | Boolean | true | 是否可清空 |
| prepend | String | '' | 前缀文字 |
| append | String | '' | 后缀文字 |
| prefix-icon | String | '' | 前图标 |
| suffix-icon | String | '' | 后图标 |
| maxlength | Number | null | 最大长度 |
| show-word-limit | Boolean | false | 显示字数统计 |
| readonly | Boolean | false | 是否只读 |

**数据示例：**
```javascript
{
  label: '单行文本',
  tag: 'el-input',
  tagIcon: 'input',
  placeholder: '请输入',
  defaultValue: undefined,
  span: 24,
  clearable: true,
  prepend: '',
  append: '',
  'prefix-icon': '',
  'suffix-icon': '',
  maxlength: null,
  'show-word-limit': false,
  readonly: false,
  disabled: false,
  required: true,
  regList: []
}
```

#### 2.3.2 多行文本 (el-input textarea)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-input' | 组件标签 |
| tagIcon | String | 'textarea' | 图标 |
| type | String | 'textarea' | 类型 |
| placeholder | String | '请输入' | 占位提示 |
| defaultValue | Any | undefined | 默认值 |
| autosize | Object | {minRows: 4, maxRows: 4} | 自适应高度 |
| maxlength | Number | null | 最大长度 |
| show-word-limit | Boolean | false | 显示字数统计 |

#### 2.3.3 密码 (el-input show-password)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-input' | 组件标签 |
| tagIcon | String | 'password' | 图标 |
| placeholder | String | '请输入' | 占位提示 |
| show-password | Boolean | true | 显示切换密码按钮 |
| clearable | Boolean | true | 是否可清空 |

#### 2.3.4 计数器 (el-input-number)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-input-number' | 组件标签 |
| tagIcon | String | 'number' | 图标 |
| placeholder | String | '' | 占位提示 |
| defaultValue | Number | undefined | 默认值 |
| min | Number | undefined | 最小值 |
| max | Number | undefined | 最大值 |
| step | Number | undefined | 步长 |
| step-strictly | Boolean | false | 严格步数 |
| precision | Number | undefined | 精度 |
| controls-position | String | '' | 按钮位置（right/空） |

### 2.4 选择型组件模型

#### 2.4.1 下拉选择 (el-select)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-select' | 组件标签 |
| tagIcon | String | 'select' | 图标 |
| placeholder | String | '请选择' | 占位提示 |
| defaultValue | Any | undefined | 默认值 |
| clearable | Boolean | true | 是否可清空 |
| filterable | Boolean | false | 是否可搜索 |
| multiple | Boolean | false | 是否多选 |
| options | Array | [...] | 选项列表 |
| optionType | String | 'default' | 选项样式（default/button） |
| border | Boolean | false | 是否带边框 |

**选项数据结构：**
```javascript
options: [
  { label: '选项一', value: 1 },
  { label: '选项二', value: 2 }
]
```

#### 2.4.2 级联选择 (el-cascader)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-cascader' | 组件标签 |
| tagIcon | String | 'cascader' | 图标 |
| placeholder | String | '请选择' | 占位提示 |
| defaultValue | Array | [] | 默认值 |
| props | Object | {...} | 配置项 |
| show-all-levels | Boolean | true | 是否展示全路径 |
| filterable | Boolean | false | 是否可筛选 |
| dataType | String | 'dynamic' | 数据类型（dynamic/static） |
| labelKey | String | 'label' | 标签键名 |
| valueKey | String | 'value' | 值键名 |
| childrenKey | String | 'children' | 子级键名 |
| separator | String | '/' | 选项分隔符 |
| options | Array | [...] | 选项树 |

**选项树结构：**
```javascript
options: [
  {
    id: 1,
    value: 1,
    label: '选项 1',
    children: [
      {
        id: 2,
        value: 2,
        label: '选项 1-1'
      }
    ]
  }
]
```

#### 2.4.3 单选框组 (el-radio-group)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-radio-group' | 组件标签 |
| tagIcon | String | 'radio' | 图标 |
| defaultValue | Any | undefined | 默认值 |
| optionType | String | 'default' | 选项样式 |
| border | Boolean | false | 是否带边框 |
| size | String | 'medium' | 尺寸 |
| options | Array | [...] | 选项列表 |

#### 2.4.4 多选框组 (el-checkbox-group)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-checkbox-group' | 组件标签 |
| tagIcon | String | 'checkbox' | 图标 |
| defaultValue | Array | [] | 默认值 |
| optionType | String | 'default' | 选项样式 |
| border | Boolean | false | 是否带边框 |
| size | String | 'medium' | 尺寸 |
| min | Number | undefined | 至少应选 |
| max | Number | undefined | 最多可选 |
| options | Array | [...] | 选项列表 |

#### 2.4.5 开关 (el-switch)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-switch' | 组件标签 |
| tagIcon | String | 'switch' | 图标 |
| defaultValue | Boolean | false | 默认值 |
| active-text | String | '' | 开启提示 |
| inactive-text | String | '' | 关闭提示 |
| active-value | Any | true | 开启值 |
| inactive-value | Any | false | 关闭值 |
| active-color | String | null | 开启颜色 |
| inactive-color | String | null | 关闭颜色 |

#### 2.4.6 滑块 (el-slider)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-slider' | 组件标签 |
| tagIcon | String | 'slider' | 图标 |
| defaultValue | Number | null | 默认值 |
| min | Number | 0 | 最小值 |
| max | Number | 100 | 最大值 |
| step | Number | 1 | 步长 |
| show-stops | Boolean | false | 显示间断点 |
| range | Boolean | false | 范围选择 |

#### 2.4.7 时间选择 (el-time-picker)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-time-picker' | 组件标签 |
| tagIcon | String | 'time' | 图标 |
| placeholder | String | '请选择' | 占位提示 |
| defaultValue | Any | null | 默认值 |
| format | String | 'HH:mm:ss' | 显示格式 |
| value-format | String | 'HH:mm:ss' | 绑定值格式 |
| picker-options | Object | {...} | 选项配置 |
| is-range | Boolean | false | 是否为范围选择 |
| range-separator | String | '至' | 分隔符 |
| start-placeholder | String | '开始时间' | 开始占位 |
| end-placeholder | String | '结束时间' | 结束占位 |

#### 2.4.8 日期选择 (el-date-picker)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-date-picker' | 组件标签 |
| tagIcon | String | 'date' | 图标 |
| placeholder | String | '请选择' | 占位提示 |
| defaultValue | Any | null | 默认值 |
| type | String | 'date' | 类型（date/week/month/year/datetime） |
| format | String | 'yyyy-MM-dd' | 显示格式 |
| value-format | String | 'yyyy-MM-dd' | 绑定值格式 |
| readonly | Boolean | false | 是否只读 |

#### 2.4.9 评分 (el-rate)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-rate' | 组件标签 |
| tagIcon | String | 'rate' | 图标 |
| defaultValue | Number | 0 | 默认值 |
| max | Number | 5 | 最大值 |
| allow-half | Boolean | false | 允许半选 |
| show-text | Boolean | false | 显示辅助文字 |
| show-score | Boolean | false | 显示分数 |
| disabled | Boolean | false | 是否禁用 |

#### 2.4.10 颜色选择 (el-color-picker)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-color-picker' | 组件标签 |
| tagIcon | String | 'color' | 图标 |
| defaultValue | String | null | 默认值 |
| show-alpha | Boolean | false | 是否显示透明度 |
| color-format | String | '' | 颜色格式（hex/rgb/rgba/hsv/hsl） |
| size | String | 'medium' | 尺寸 |

#### 2.4.11 上传 (el-upload)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-upload' | 组件标签 |
| tagIcon | String | 'upload' | 图标 |
| action | String | 'https://...' | 上传地址 |
| defaultValue | Any | null | 默认值 |
| name | String | 'file' | 文件字段名 |
| accept | String | '' | 文件类型 |
| auto-upload | Boolean | true | 自动上传 |
| multiple | Boolean | false | 多选文件 |
| list-type | String | 'text' | 列表类型（text/picture/picture-card） |
| fileSize | Number | 2 | 文件大小限制 |
| sizeUnit | String | 'MB' | 大小单位 |
| buttonText | String | '点击上传' | 按钮文字 |
| showTip | Boolean | false | 显示提示 |

### 2.5 布局型组件模型

#### 2.5.1 行容器 (rowFormItem)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| layout | String | 'rowFormItem' | 布局类型 |
| tagIcon | String | 'row' | 图标 |
| type | String | 'default' | 布局模式（default/flex） |
| justify | String | 'start' | 水平排列（start/end/center/space-around/space-between） |
| align | String | 'top' | 垂直排列（top/middle/bottom） |
| gutter | Number | 15 | 栅格间隔 |
| children | Array | [] | 子组件列表 |
| layoutTree | Boolean | true | 是否为布局树 |

#### 2.5.2 按钮 (el-button)

| 字段名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| tag | String | 'el-button' | 组件标签 |
| tagIcon | String | 'button' | 图标 |
| label | String | '按钮' | 按钮文字 |
| type | String | 'primary' | 类型（primary/success/warning/danger/info） |
| icon | String | 'el-icon-search' | 图标 |
| size | String | 'medium' | 尺寸 |
| disabled | Boolean | false | 是否禁用 |

---

## 三、校验规则模型

### 3.1 正则校验规则 (regList)

**说明：** 组件的正则校验规则列表

| 字段名 | 类型 | 说明 | 示例 |
|-------|------|------|------|
| pattern | String | 正则表达式 | `^\d+$` |
| message | String | 错误提示 | "请输入数字" |

**数据结构：**
```javascript
regList: [
  {
    pattern: '^1[3-9]\\d{9}$',
    message: '请输入正确的手机号码'
  },
  {
    pattern: '^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$',
    message: '请输入正确的邮箱地址'
  }
]
```

### 3.2 内置校验规则

**触发方式配置：**

| 组件类型 | 触发方式 |
|---------|---------|
| el-input | blur |
| el-input-number | blur |
| el-select | change |
| el-radio-group | change |
| el-checkbox-group | change |
| el-cascader | change |
| el-time-picker | change |
| el-date-picker | change |
| el-rate | change |

---

## 四、生成代码数据模型

### 4.1 生成的 Vue 组件结构

```javascript
{
  template: `
    <el-form ref="elForm" :model="formData" :rules="rules" ...>
      <el-row :gutter="15">
        <el-col :span="24">
          <el-form-item label="单行文本" prop="field101">
            <el-input v-model="formData.field101" placeholder="请输入" />
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  `,
  script: `
    export default {
      data() {
        return {
          formData: {
            field101: undefined
          },
          rules: {
            field101: [
              { required: true, message: '请输入单行文本', trigger: 'blur' }
            ]
          }
        }
      }
    }
  `,
  style: `/* 样式 */`
}
```

### 4.2 表单数据模型

```javascript
formData: {
  field101: undefined,  // 单行文本
  field102: undefined,  // 下拉选择
  field103: [],         // 多选框
  // ...
}
```

### 4.3 校验规则模型

```javascript
rules: {
  field101: [
    { required: true, message: '请输入单行文本', trigger: 'blur' }
  ],
  field102: [
    { required: true, message: '请选择下拉选择', trigger: 'change' }
  ],
  field103: [
    { required: true, message: '请至少选择一个', trigger: 'change', min: 1 }
  ]
}
```

---

## 五、组件 ID 生成规则

### 5.1 ID 生成逻辑

```javascript
// 全局 ID 计数器
let idGlobal = 100

// 生成新 ID
function generateId() {
  return ++idGlobal
}

// 生成 vModel
function generateVModel(id) {
  return `field${id}`
}

// 生成 renderKey
function generateRenderKey() {
  return +new Date()
}
```

### 5.2 ID 使用示例

| 组件 | formId | vModel | renderKey |
|------|--------|--------|-----------|
| 第 1 个组件 | 101 | field101 | 1710234567890 |
| 第 2 个组件 | 102 | field102 | 1710234567891 |
| 第 3 个组件 | 103 | field103 | 1710234567892 |

---

## 六、无持久化存储

**重要说明：**

在线构建器模块**不使用任何持久化存储**：

1. **无数据库表**：不存储设计数据到数据库
2. **无本地存储**：不使用 localStorage/sessionStorage
3. **内存数据**：所有数据都在浏览器内存中
4. **刷新丢失**：页面刷新后所有设计数据丢失

**数据保存方式：**
- 导出为 .vue 文件
- 复制代码到剪贴板
- 手动保存到其他位置
