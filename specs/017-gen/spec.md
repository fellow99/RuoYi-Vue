# 017-代码生成 - 功能规格

**模块编号：** 017  
**模块名称：** 代码生成 (Code Generation)  
**所属模块：** 系统工具  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、功能概述

代码生成模块是 RuoYi-Vue 系统的核心效率工具，用于根据数据库表结构自动生成完整的 CRUD 代码。该模块基于 Apache Velocity 模板引擎，支持多种模板类型（单表 CRUD、树表、主子表），可生成后端 Java 代码（Entity、Mapper、Service、Controller）和前端 Vue 代码（API、页面组件）。

### 1.1 核心功能

- **表导入**：从数据库导入表结构到代码生成配置
- **表创建**：通过 SQL 语句创建表结构并导入
- **配置管理**：配置生成代码的包路径、模块名、业务名等
- **代码预览**：预览生成的代码内容
- **代码下载**：下载生成的 ZIP 压缩包
- **本地生成**：直接生成代码到项目路径（需配置允许）
- **同步数据库**：同步数据库表结构变更到生成配置
- **批量生成**：支持多表批量生成代码

### 1.2 支持的模板类型

| 模板类型 | 标识 | 说明 | 适用场景 |
|---------|------|------|---------|
| CRUD 单表 | `crud` | 基础增删改查 | 普通业务表 |
| 树表 | `tree` | 树形结构 CRUD | 部门、菜单等层级数据 |
| 主子表 | `sub` | 主子表关联 CRUD | 订单 - 订单明细等 |

### 1.3 支持的前端模板

| 前端类型 | 标识 | 说明 |
|---------|------|------|
| Element UI | `element-ui` | Vue 2 + Element UI |
| Element Plus | `element-plus` | Vue 3 + Element Plus |
| Element Plus TS | `element-plus-typescript` | Vue 3 + Element Plus + TypeScript |

### 1.4 业务规则

1. **表名唯一性**：每个导入的表名在系统中必须唯一
2. **生成配置必填**：包路径、模块名、业务名、功能名、作者必填
3. **主键识别**：自动识别表的主键列，用于生成代码的主键处理
4. **字段映射**：数据库字段自动映射为 Java 驼峰命名
5. **字典关联**：支持字段关联字典类型，生成下拉选择组件
6. **查询配置**：可配置哪些字段作为查询条件、查询方式
7. **代码覆盖保护**：默认不允许覆盖已生成的代码（需配置开启）

---

## 二、功能详细设计

### 2.1 代码生成列表查询

**功能描述：** 分页查询已导入的代码生成配置列表

**查询条件：**
- 表名称（模糊匹配）
- 表描述（模糊匹配）
- 创建时间范围

**列表字段：**
- 序号、表名称、表描述、实体类名称
- 创建时间、更新时间、操作列

**权限标识：** `tool:gen:list`

### 2.2 数据库表列表查询

**功能描述：** 查询数据库中未导入的表列表，用于导入操作

**查询条件：**
- 表名称（模糊匹配）
- 表描述（模糊匹配）

**列表字段：**
- 表名称、表描述、引擎、字符集、创建时间

**权限标识：** `tool:gen:list`

### 2.3 导入表结构

**功能描述：** 从数据库导入表结构到代码生成配置

**操作流程：**
1. 选择数据库表（支持多选）
2. 选择前端模板类型（element-ui/element-plus/element-plus-typescript）
3. 系统自动初始化表配置和列配置
4. 保存导入的配置

**初始化规则：**
- 表配置：自动生成类名（首字母大写）、默认包路径、模块名、业务名
- 列配置：自动识别主键、字段类型映射、Java 类型映射
- 默认生成作者：当前登录用户

**权限标识：** `tool:gen:import`

### 2.4 创建表结构

**功能描述：** 通过 SQL 语句创建表并导入到代码生成配置

**操作流程：**
1. 输入 CREATE TABLE SQL 语句
2. 选择前端模板类型
3. 系统解析 SQL 并创建表
4. 自动导入新生成的表到代码生成配置

**权限要求：** admin 角色

**权限标识：** 仅限 admin 角色

### 2.5 修改代码生成配置

**功能描述：** 修改代码生成的配置信息

**可配置字段：**

**表配置：**
- 表名称（不可修改）
- 表描述
- 实体类名称
- 模板类型（crud/tree/sub）
- 前端模板类型
- 包路径
- 模块名
- 业务名
- 功能名
- 功能作者
- 生成方式（0=ZIP 下载/1=本地路径）
- 生成路径

**列配置：**
- 字段描述
- Java 属性名
- Java 类型
- 是否主键
- 是否自增
- 是否必填
- 是否插入字段
- 是否编辑字段
- 是否列表字段
- 是否查询字段
- 查询方式（EQ/NE/GT/LT/LIKE/BETWEEN）
- 显示类型（input/textarea/select/checkbox/radio/datetime/image/upload/editor）
- 字典类型

**权限标识：** `tool:gen:edit`

### 2.6 预览代码

**功能描述：** 预览生成的代码内容

**预览内容：**
- 后端代码：Entity、Mapper、XML、Service、ServiceImpl、Controller
- 前端代码：api.js、index.vue、router.js
- SQL 脚本：menu.sql

**操作：**
- 查看各文件内容（语法高亮）
- 复制代码到剪贴板

**权限标识：** `tool:gen:preview`

### 2.7 生成代码（下载）

**功能描述：** 生成代码并下载 ZIP 压缩包

**生成内容：**
- 完整的后端代码目录结构
- 完整的前端代码目录结构
- SQL 脚本文件

**权限标识：** `tool:gen:code`

### 2.8 生成代码（本地）

**功能描述：** 生成代码到本地项目路径

**配置要求：**
- 需要在系统配置中开启 `allowOverwrite` 选项
- 生成路径必须有效

**权限标识：** `tool:gen:code`

### 2.9 同步数据库

**功能描述：** 同步数据库表结构变更到代码生成配置

**同步内容：**
- 列的新增/删除/修改
- 列类型变更
- 主键变更

**注意：** 会重置手动修改的列配置

**权限标识：** `tool:gen:edit`

### 2.10 删除代码生成配置

**功能描述：** 删除代码生成配置（不影响数据库表）

**支持操作：** 单条删除、批量删除

**权限标识：** `tool:gen:remove`

---

## 三、代码生成规则

### 3.1 命名规则

| 配置项 | 示例 | 说明 |
|-------|------|------|
| 表名 | `sys_user` | 下划线命名 |
| 类名 | `SysUser` | 首字母大写驼峰 |
| 包路径 | `com.ruoyi.system` | 标准 Java 包名 |
| 模块名 | `system` | 小写 |
| 业务名 | `user` | 小写 |
| 功能名 | `用户管理` | 中文描述 |

### 3.2 字段类型映射

| 数据库类型 | Java 类型 | 说明 |
|-----------|----------|------|
| varchar/char | String | 字符串 |
| text/longtext | String | 长文本 |
| int/integer | Integer | 整数 |
| bigint | Long | 长整数 |
| decimal/numeric | BigDecimal | 高精度数字 |
| datetime/timestamp | Date | 日期时间 |
| date | Date | 日期 |
| tinyint(1) | Boolean | 布尔值 |

### 3.3 查询方式

| 查询方式 | 标识 | 说明 |
|---------|------|------|
| 等于 | EQ | `=` |
| 不等于 | NE | `!=` |
| 大于 | GT | `>` |
| 小于 | LT | `<` |
| 模糊 | LIKE | `LIKE '%value%'` |
| 范围 | BETWEEN | `BETWEEN start AND end` |

### 3.4 显示类型

| 显示类型 | 组件 | 说明 |
|---------|------|------|
| input | 文本框 | 单行文本输入 |
| textarea | 文本域 | 多行文本输入 |
| select | 下拉框 | 单选 |
| checkbox | 复选框 | 多选 |
| radio | 单选框 | 单选 |
| datetime | 日期控件 | 日期时间选择 |
| image | 图片上传 | 图片上传控件 |
| upload | 文件上传 | 文件上传控件 |
| editor | 富文本 | 富文本编辑器 |

---

## 四、权限配置

### 4.1 权限标识列表

| 权限标识 | 说明 | 适用角色 |
|---------|------|---------|
| `tool:gen:list` | 查询代码生成列表 | 管理员 |
| `tool:gen:query` | 查询代码生成详情 | 管理员 |
| `tool:gen:import` | 导入表结构 | 管理员 |
| `tool:gen:edit` | 修改/同步配置 | 管理员 |
| `tool:gen:remove` | 删除配置 | 管理员 |
| `tool:gen:preview` | 预览代码 | 管理员 |
| `tool:gen:code` | 生成代码 | 管理员 |

### 4.2 角色要求

- 大部分操作需要管理员权限
- 创建表操作仅限 admin 角色

---

## 五、配置项

### 5.1 系统配置

| 配置项 | 默认值 | 说明 |
|-------|--------|------|
| `gen.allowOverwrite` | false | 是否允许覆盖已生成的代码 |
| `gen.packageName` | com.ruoyi | 默认包路径 |
| `gen.author` | ruoyi | 默认作者 |
| `gen.autoRemovePre` | false | 是否自动去除表前缀 |
| `gen.tablePrefix` | sys_ | 表前缀 |

### 5.2 模板配置

模板文件位于 `resources/vm/` 目录：

**后端模板：**
- `template/java/domain.java.vm` - 实体类
- `template/java/mapper.java.vm` - Mapper 接口
- `template/java/service.java.vm` - Service 接口
- `template/java/serviceImpl.java.vm` - Service 实现
- `template/java/controller.java.vm` - Controller
- `template/xml/mapper.xml.vm` - MyBatis XML

**前端模板：**
- `template/vue/api.js.vm` - API 接口
- `template/vue/index.vue.vm` - 列表页面
- `template/vue/index-tree.vue.vm` - 树表页面
- `template/vue/router.js.vm` - 路由配置

**SQL 模板：**
- `template/sql/menu.sql.vm` - 菜单 SQL
