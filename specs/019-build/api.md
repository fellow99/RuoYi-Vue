# 019-在线构建器 - API 接口

**模块编号：** 019  
**模块名称：** 在线构建器 (Form Builder / 表单构建器)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、接口概述

**重要说明：** 在线构建器是一个**纯前端工具**，**没有后端 API 接口**。所有功能都在浏览器端完成，不涉及与服务器的数据交互。

### 1.1 模块特性

| 特性 | 说明 |
|------|------|
| 后端接口 | 无 |
| 数据存储 | 浏览器内存 |
| 数据持久化 | 导出为文件 |
| 认证要求 | 仅需登录访问页面 |

### 1.2 页面访问

**访问方式：** 通过前端路由访问

| 环境 | 地址 |
|------|------|
| 本地开发 | http://localhost:8080/#/tool/build |
| 生产环境 | https://your-domain.com/#/tool/build |

---

## 二、前端数据流

### 2.1 数据流图

```
┌─────────────────────────────────────────────────────────┐
│                    表单构建器页面                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐          │
│  │ 组件库   │───>│  画布    │<───│ 属性面板 │          │
│  │ (左侧)   │    │ (中间)   │    │ (右侧)   │          │
│  └──────────┘    └──────────┘    └──────────┘          │
│       │               │               │                 │
│       │               │               │                 │
│       ▼               ▼               ▼                 │
│  ┌──────────────────────────────────────────┐          │
│  │          内存数据 (Vue 响应式)            │          │
│  │  - inputComponents (输入型组件列表)       │          │
│  │  - selectComponents (选择型组件列表)      │          │
│  │  - layoutComponents (布局型组件列表)      │          │
│  │  - drawingList (画布组件列表)             │          │
│  │  - formConf (表单配置)                    │          │
│  │  - activeData (当前选中组件数据)          │          │
│  └──────────────────────────────────────────┘          │
│                       │                                 │
│                       ▼                                 │
│              ┌─────────────────┐                        │
│              │   代码生成器     │                        │
│              └─────────────────┘                        │
│                       │                                 │
│          ┌────────────┼────────────┐                    │
│          ▼            ▼            ▼                    │
│    ┌──────────┐ ┌──────────┐ ┌──────────┐              │
│    │ 导出文件 │ │ 复制代码 │ │ 运行预览 │              │
│    └──────────┘ └──────────┘ └──────────┘              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 2.2 数据操作

**组件添加：**
```javascript
// 从组件库添加组件到画布
addComponent(item) {
  const clone = this.cloneComponent(item)
  this.drawingList.push(clone)
  this.activeFormItem(clone)
}
```

**组件复制：**
```javascript
// 复制画布中的组件
drawingItemCopy(item, parent) {
  let clone = JSON.parse(JSON.stringify(item))
  clone = this.createIdAndKey(clone)
  parent.push(clone)
  this.activeFormItem(clone)
}
```

**组件删除：**
```javascript
// 从画布删除组件
drawingItemDelete(index, parent) {
  parent.splice(index, 1)
}
```

**组件更新：**
```javascript
// 更新组件属性（通过 v-model 双向绑定）
// 右侧面板修改属性 → activeData 更新 → 画布实时更新
```

---

## 三、代码生成逻辑

### 3.1 代码生成流程

```
1. 收集表单数据
   ↓
2. 组装表单配置 (AssembleFormData)
   ↓
3. 生成 HTML 模板 (makeUpHtml)
   ↓
4. 生成 JavaScript 代码 (makeUpJs)
   ↓
5. 生成 CSS 样式 (makeUpCss)
   ↓
6. 组合代码 (vueTemplate + vueScript + cssStyle)
   ↓
7. 格式化代码 (js-beautify)
   ↓
8. 输出结果
```

### 3.2 代码生成函数

**生成代码主函数：**
```javascript
generateCode() {
  const { type } = this.generateConf
  this.AssembleFormData()
  const script = vueScript(makeUpJs(this.formData, type))
  const html = vueTemplate(makeUpHtml(this.formData, type))
  const css = cssStyle(makeUpCss(this.formData))
  return beautifier.html(html + script + css, beautifierConf.html)
}
```

**组装表单数据：**
```javascript
AssembleFormData() {
  this.formData = {
    fields: JSON.parse(JSON.stringify(this.drawingList)),
    ...this.formConf
  }
}
```

### 3.3 代码导出方式

#### 3.3.1 导出文件

```javascript
execDownload(data) {
  const codeStr = this.generateCode()
  const blob = new Blob([codeStr], { type: 'text/plain;charset=utf-8' })
  this.$download.saveAs(blob, data.fileName)
}
```

#### 3.3.2 复制代码

```javascript
execCopy(data) {
  document.getElementById('copyNode').click()
}

// ClipboardJS 配置
clipboard = new ClipboardJS('#copyNode', {
  text: trigger => {
    const codeStr = this.generateCode()
    this.$notify({
      title: '成功',
      message: '代码已复制到剪切板，可粘贴。',
      type: 'success'
    })
    return codeStr
  }
})
```

#### 3.3.3 运行预览

```javascript
execRun(data) {
  this.AssembleFormData()
  this.drawerVisible = true  // 打开预览弹窗
}
```

---

## 四、组件配置数据流

### 4.1 组件库配置

**数据来源：** `@/utils/generator/config`

```javascript
import { 
  inputComponents, 
  selectComponents, 
  layoutComponents, 
  formConf 
} from '@/utils/generator/config'
```

**组件列表：**
- `inputComponents` - 输入型组件配置数组
- `selectComponents` - 选择型组件配置数组
- `layoutComponents` - 布局型组件配置数组
- `formConf` - 表单默认配置

### 4.2 组件克隆

```javascript
cloneComponent(origin) {
  const clone = JSON.parse(JSON.stringify(origin))
  clone.formId = ++this.idGlobal
  clone.span = formConf.span
  clone.renderKey = +new Date()
  
  if (!clone.layout) clone.layout = 'colFormItem'
  
  if (clone.layout === 'colFormItem') {
    clone.vModel = `field${this.idGlobal}`
    clone.placeholder !== undefined && (clone.placeholder += clone.label)
    tempActiveData = clone
  } else if (clone.layout === 'rowFormItem') {
    delete clone.label
    clone.componentName = `row${this.idGlobal}`
    clone.gutter = this.formConf.gutter
    tempActiveData = clone
  }
  
  return tempActiveData
}
```

---

## 五、拖拽数据流

### 5.1 拖拽配置

**使用库：** vuedraggable

**拖拽组配置：**
```javascript
group: { 
  name: 'componentsGroup', 
  pull: 'clone', 
  put: false 
}
```

**配置说明：**
- `name`: 组名称，相同组的元素可以互相拖拽
- `pull`: 是否可以从列表拉出（clone 表示克隆）
- `put`: 是否可以放入其他元素

### 5.2 拖拽事件

**拖拽结束事件：**
```javascript
onEnd(obj, a) {
  if (obj.from !== obj.to) {
    // 从组件库拖入画布
    this.activeData = tempActiveData
    this.activeId = this.idGlobal
  }
}
```

---

## 六、属性配置数据流

### 6.1 双向绑定

**组件属性绑定：**
```vue
<el-form-item label="标题">
  <el-input v-model="activeData.label" placeholder="请输入标题" />
</el-form-item>

<el-form-item label="占位提示">
  <el-input v-model="activeData.placeholder" placeholder="请输入占位提示" />
</el-form-item>

<el-form-item label="是否必填">
  <el-switch v-model="activeData.required" />
</el-form-item>
```

### 6.2 特殊属性处理

**默认值输入：**
```javascript
onDefaultValueInput(str) {
  if (isArray(this.activeData.defaultValue)) {
    // 数组类型
    this.$set(
      this.activeData,
      'defaultValue',
      str.split(',').map(val => (isNumberStr(val) ? +val : val))
    )
  } else if (['true', 'false'].indexOf(str) > -1) {
    // 布尔类型
    this.$set(this.activeData, 'defaultValue', JSON.parse(str))
  } else {
    // 字符串和数字
    this.$set(
      this.activeData,
      'defaultValue',
      isNumberStr(str) ? +str : str
    )
  }
}
```

**开关值输入：**
```javascript
onSwitchValueInput(val, name) {
  if (['true', 'false'].indexOf(val) > -1) {
    this.$set(this.activeData, name, JSON.parse(val))
  } else {
    this.$set(this.activeData, name, isNumberStr(val) ? +val : val)
  }
}
```

**时间格式设置：**
```javascript
setTimeValue(val, type) {
  const valueFormat = type === 'week' ? dateTimeFormat.date : val
  this.$set(this.activeData, 'defaultValue', null)
  this.$set(this.activeData, 'value-format', valueFormat)
  this.$set(this.activeData, 'format', val)
}
```

---

## 七、组件类型切换

### 7.1 组件类型切换逻辑

```javascript
tagChange(newTag) {
  newTag = this.cloneComponent(newTag)
  newTag.vModel = this.activeData.vModel
  newTag.formId = this.activeId
  newTag.span = this.activeData.span
  
  // 删除旧组件特有属性
  delete this.activeData.tag
  delete this.activeData.tagIcon
  delete this.activeData.document
  
  // 保留相同类型的属性
  Object.keys(newTag).forEach(key => {
    if (this.activeData[key] !== undefined
      && typeof this.activeData[key] === typeof newTag[key]) {
      newTag[key] = this.activeData[key]
    }
  })
  
  this.activeData = newTag
  this.updateDrawingList(newTag, this.drawingList)
}
```

---

## 八、表单配置

### 8.1 表单属性配置

```vue
<!-- 表单名 -->
<el-input v-model="formConf.formRef" placeholder="请输入表单名（ref）" />

<!-- 表单模型 -->
<el-input v-model="formConf.formModel" placeholder="请输入数据模型" />

<!-- 校验模型 -->
<el-input v-model="formConf.formRules" placeholder="请输入校验模型" />

<!-- 表单尺寸 -->
<el-radio-group v-model="formConf.size">
  <el-radio-button label="medium">中等</el-radio-button>
  <el-radio-button label="small">较小</el-radio-button>
  <el-radio-button label="mini">迷你</el-radio-button>
</el-radio-group>

<!-- 标签对齐 -->
<el-radio-group v-model="formConf.labelPosition">
  <el-radio-button label="left">左对齐</el-radio-button>
  <el-radio-button label="right">右对齐</el-radio-button>
  <el-radio-button label="top">顶部对齐</el-radio-button>
</el-radio-group>

<!-- 标签宽度 -->
<el-input-number v-model="formConf.labelWidth" placeholder="标签宽度" />

<!-- 栅格间隔 -->
<el-input-number v-model="formConf.gutter" :min="0" placeholder="栅格间隔" />

<!-- 禁用表单 -->
<el-switch v-model="formConf.disabled" />

<!-- 表单按钮 -->
<el-switch v-model="formConf.formBtns" />
```

---

## 九、无后端接口说明

### 9.1 为什么没有后端接口？

在线构建器定位为**纯前端工具**，原因如下：

1. **设计阶段工具**：用于快速生成表单代码原型
2. **无需持久化**：设计结果直接导出为代码文件
3. **轻量级**：不依赖后端服务，降低系统复杂度
4. **灵活性**：生成的代码可以自由集成到任何项目

### 9.2 与后端的交互

虽然构建器本身没有后端接口，但生成的表单在实际使用时会调用后端 API：

```javascript
// 生成的表单提交示例
submitForm() {
  this.$refs[this.formConf.formRef].validate(valid => {
    if (valid) {
      // 调用后端 API
      this.$axios.post('/api/submit', this[this.formConf.formModel])
        .then(response => {
          this.$message.success('提交成功')
        })
    }
  })
}
```

### 9.3 扩展建议

如需保存设计到服务器，可扩展以下功能：

1. **保存设计**：POST /tool/form/save - 保存表单设计 JSON
2. **加载设计**：GET /tool/form/{id} - 加载已保存的表单设计
3. **设计列表**：GET /tool/form/list - 获取表单设计列表
4. **删除设计**：DELETE /tool/form/{id} - 删除表单设计

**保存的数据结构：**
```json
{
  "formConf": { ... },
  "fields": [ ... ]
}
```
