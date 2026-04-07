# 018-系统接口 - 前端页面

**模块编号：** 018  
**模块名称：** 系统接口 (System API / Swagger)  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、页面概述

**页面路径：** `ruoyi-ui/src/views/tool/swagger/`

**主要文件：**
- `index.vue` - Swagger UI 嵌入页面

**页面类型：** iframe 嵌入页

**功能说明：** 通过 iframe 嵌入 Swagger UI，展示系统所有 API 接口文档

---

## 二、页面结构

### 2.1 页面布局

```
┌─────────────────────────────────────────────────────────┐
│ 系统工具 > 系统接口                                      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │                                                   │  │
│  │           Swagger UI (iframe 嵌入)                │  │
│  │                                                   │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │ 若依管理系统_接口文档                         │  │  │
│  │  ├─────────────────────────────────────────────┤  │  │
│  │  │ [Authorize]                                  │  │  │
│  │  ├─────────────────────────────────────────────┤  │  │
│  │  │ 用户管理                                      │  │  │
│  │  │   GET /system/user/list                      │  │  │
│  │  │   POST /system/user                          │  │  │
│  │  │   ...                                        │  │  │
│  │  │                                              │  │  │
│  │  │ 角色管理                                      │  │  │
│  │  │   ...                                        │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  │                                                   │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 2.2 组件结构

```
index.vue
└── iFrame 组件
    └── iframe (src: /swagger-ui/index.html)
```

---

## 三、核心代码

### 3.1 页面代码

**文件：** `ruoyi-ui/src/views/tool/swagger/index.vue`

```vue
<template>
  <i-frame :src="url" />
</template>

<script>
import iFrame from "@/components/iFrame/index"

export default {
  name: "Swagger",
  components: { iFrame },
  data() {
    return {
      url: process.env.VUE_APP_BASE_API + "/swagger-ui/index.html"
    }
  }
}
</script>
```

### 3.2 代码说明

| 部分 | 说明 |
|------|------|
| iFrame 组件 | 通用的 iframe 封装组件 |
| url | Swagger UI 地址，通过环境变量配置 |
| VUE_APP_BASE_API | 后端 API 基础路径（如 http://localhost:8080） |

---

## 四、iFrame 组件

### 4.1 组件路径

**文件：** `ruoyi-ui/src/components/iFrame/index.vue`

### 4.2 组件功能

- 全屏展示 iframe 内容
- 自适应高度
- 处理加载状态

### 4.3 组件代码（简化）

```vue
<template>
  <div class="iframe-container">
    <iframe 
      :src="src" 
      frameborder="0" 
      width="100%" 
      height="100%"
      class="iframe-content"
    />
  </div>
</template>

<script>
export default {
  name: "iFrame",
  props: {
    src: {
      type: String,
      required: true
    }
  }
}
</script>

<style scoped>
.iframe-container {
  width: 100%;
  height: 100vh;
}
.iframe-content {
  width: 100%;
  height: 100%;
  border: none;
}
</style>
```

---

## 五、页面配置

### 5.1 路由配置

**文件：** `ruoyi-ui/src/router/index.js`

```javascript
{
  path: '/tool/swagger',
  component: Layout,
  hidden: false,
  children: [{
    path: 'swagger',
    component: () => import('@/views/tool/swagger'),
    name: 'Swagger',
    meta: { 
      title: '系统接口',
      icon: 'swagger',
      noCache: true
    }
  }]
}
```

### 5.2 菜单配置

**菜单信息：**

| 属性 | 值 |
|------|-----|
| 菜单名称 | 系统接口 |
| 父级菜单 | 系统工具 |
| 路由路径 | /tool/swagger |
| 组件路径 | tool/swagger/index |
| 权限标识 | 无（仅需登录） |
| 图标 | swagger |
| 是否缓存 | 否 |

### 5.3 环境变量配置

**文件：** `.env` 或 `.env.development`

```bash
# 开发环境
VUE_APP_BASE_API=http://localhost:8080

# 生产环境
VUE_APP_BASE_API=https://your-domain.com
```

---

## 六、Swagger UI 界面说明

### 6.1 界面布局

```
┌─────────────────────────────────────────────────────────┐
│ 若依管理系统_接口文档                    [Authorize]    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ ▼ 用户管理                                              │
│   GET    /system/user/list     获取用户列表    [Try]   │
│   POST   /system/user          新增用户        [Try]   │
│   PUT    /system/user          修改用户        [Try]   │
│   DELETE /system/user/{userId} 删除用户        [Try]   │
│                                                         │
│ ▼ 角色管理                                              │
│   ...                                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 6.2 主要功能区

| 区域 | 功能 |
|------|------|
| 标题栏 | 显示 API 文档标题、版本信息 |
| Authorize 按钮 | 设置 JWT Token 认证 |
| 分组列表 | 按 Controller 分组展示接口 |
| 接口项 | 显示接口方法、路径、摘要 |
| Try 按钮 | 展开接口详情和测试表单 |

### 6.3 接口测试表单

展开接口后显示：

```
┌─────────────────────────────────────────┐
│ GET /system/user/list                   │
├─────────────────────────────────────────┤
│ 参数：                                   │
│ ┌─────────────┬───────────┬──────────┐ │
│ │ 参数名      │ 类型      │ 值       │ │
│ ├─────────────┼───────────┼──────────┤ │
│ │ userName    │ string    │ [输入框] │ │
│ │ pageNum     │ integer   │ [输入框] │ │
│ │ pageSize    │ integer   │ [输入框] │ │
│ └─────────────┴───────────┴──────────┘ │
│                                         │
│ [Execute]  [Clear]                      │
├─────────────────────────────────────────┤
│ 响应：                                   │
│ Code: 200                               │
│ Body: {...}                             │
└─────────────────────────────────────────┘
```

---

## 七、使用流程

### 7.1 访问页面

1. 登录系统
2. 点击菜单：系统工具 > 系统接口
3. 页面加载 Swagger UI

### 7.2 授权认证

1. 点击右上角"Authorize"按钮
2. 在 Value 输入框中输入：`Bearer {token}`
   - token 通过登录接口获取
   - 或从浏览器 localStorage 中获取（key: token）
3. 点击"Authorize"确认
4. 点击"Close"关闭弹窗

### 7.3 测试接口

1. 展开目标接口分组
2. 点击要测试的接口
3. 填写请求参数
4. 点击"Execute"执行
5. 查看响应结果

---

## 八、样式定制

### 8.1 当前样式

系统使用 Swagger UI 默认样式，无额外定制。

### 8.2 可选定制

如需定制样式，可覆盖以下 CSS：

```css
/* 修改主题色 */
.swagger-ui .topbar {
  background-color: #409EFF;
}

/* 修改字体 */
.swagger-ui .info .title {
  font-family: 'Your Font', sans-serif;
}

/* 隐藏特定分组 */
.swagger-ui .opblock-tag[data-tag="敏感模块"] {
  display: none;
}
```

---

## 九、注意事项

### 9.1 跨域问题

**问题：** iframe 可能遇到跨域限制

**解决方案：**
- 确保前后端同源，或配置 CORS
- 后端配置允许 iframe 嵌入

### 9.2 Token 过期

**问题：** Token 过期后接口测试失败

**解决方案：**
- 重新登录获取新 token
- 更新 Authorization 配置

### 9.3 生产环境

**注意：** 生产环境应禁用 Swagger

**配置方式：**
```yaml
springdoc:
  api-docs:
    enabled: false
  swagger-ui:
    enabled: false
```

### 9.4 菜单权限

**说明：** 系统接口菜单默认对所有登录用户开放

**如需限制：**
- 在菜单管理中设置可见角色
- 或添加权限标识控制

---

## 十、相关文件

| 文件路径 | 说明 |
|---------|------|
| `ruoyi-ui/src/views/tool/swagger/index.vue` | Swagger 页面组件 |
| `ruoyi-ui/src/components/iFrame/index.vue` | iframe 封装组件 |
| `ruoyi-admin/src/main/java/com/ruoyi/web/core/config/SwaggerConfig.java` | Swagger 配置类 |
| `ruoyi-ui/src/assets/icons/svg/swagger.svg` | Swagger 图标 |

---

## 十一、扩展建议

### 11.1 功能扩展

1. **快捷登录**：在页面中添加一键获取 token 按钮
2. **接口收藏**：支持收藏常用接口
3. **接口搜索**：快速搜索接口
4. **导出文档**：支持导出 Markdown/PDF 格式

### 11.2 样式优化

1. **主题定制**：匹配系统主题色
2. **响应式优化**：适配移动端
3. **暗黑模式**：支持暗黑主题
