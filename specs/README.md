# RuoYi-Vue 规范文档

> 完整的系统规范文档，涵盖架构设计、功能规格、API 接口、数据模型和技术方案

**版本：** 3.9.1  
**生成时间：** 2026-03-12  
**最后更新：** 2026-03-13  
**文档状态：** ✅ 已完成

---

## 📖 项目介绍

RuoYi-Vue 是一套基于 Spring Boot + Vue 的前后端分离快速开发框架。本规范文档旨在为 RuoYi-Vue 框架的所有核心功能模块提供完整的技术规范说明。

### 技术栈

| 层级 | 技术 |
|------|------|
| **后端** | Spring Boot 2.x, Spring Security, MyBatis, Redis, MySQL |
| **前端** | Vue 2.x, Vue Router, Vuex, Element UI, Axios, ECharts |
| **工具** | Druid, Swagger, Quartz, OSHI |

### 核心功能

- **系统管理** - 用户、部门、岗位、菜单、角色、字典、参数、通知
- **系统监控** - 在线用户、定时任务、操作日志、登录日志、缓存监控、服务器监控、连接池监视
- **系统工具** - 代码生成、系统接口 (Swagger)、在线构建器

---

## 📚 文档介绍

本规范文档使用 Speckit 工具集从现有代码逆向生成，遵循以下规范：

### 文档类型

| 文档类型 | 用途 | 内容 |
|----------|------|------|
| `spec.md` | 功能规格 | 用户故事、功能需求、验收标准、成功标准 |
| `data-model.md` | 数据模型 | 实体关系、数据结构、业务逻辑 |
| `api.md` | API 接口 | 接口定义、请求/响应、错误码 |
| `pages.md` | 前端页面 | 页面布局、组件结构、交互设计 |
| `plan.md` | 技术方案 | 架构设计、技术选型、实现计划 |
| `tasks.md` | 任务清单 | 开发任务、依赖关系、优先级 |

### 文档结构

```
specs/
├── 核心文档                    # 整体规格和架构文档
├── 001-019/                   # 19 个功能模块规范
├── README.md                  # 本文档（文档索引）
├── ARCHITECTURE.md            # 系统架构
├── STRUCTURE.md               # 项目结构
├── TECH.md                    # 技术栈说明
├── constitution.md            # 项目章程
├── overall-*                  # 整体规格系列
├── SPECS_CHECKLIST.md         # 完成情况清单
└── PROJECT_SUMMARY.md         # 项目汇总报告
```

---

## 📁 文档索引

### 核心文档

| 文档 | 说明 | 大小 |
|------|------|------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | 系统架构设计 | 31KB |
| [STRUCTURE.md](STRUCTURE.md) | 项目目录结构 | 30KB |
| [TECH.md](TECH.md) | 技术栈说明 | 7.5KB |
| [constitution.md](constitution.md) | 项目章程与原则 | 15KB |
| [overall-spec.md](overall-spec.md) | 整体规格 | 11KB |
| [overall-plan.md](overall-plan.md) | 整体技术方案 | 26KB |
| [overall-api.md](overall-api.md) | 整体 API 规范 | 22KB |
| [overall-data-model.md](overall-data-model.md) | 整体数据模型 | 21KB |
| [SPECS_CHECKLIST.md](SPECS_CHECKLIST.md) | 规范检查清单 | 11KB |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | 项目汇总报告 | 15KB |

---

### 功能模块规范

#### 系统管理模块 (001-009)

| 模块 | 文档 | 说明 |
|------|------|------|
| [001-user](001-user/) | spec, data-model, api, pages | 用户管理 - 系统用户配置、角色分配 |
| [002-dept](002-dept/) | spec, data-model, api, pages | 部门管理 - 组织机构树、数据权限 |
| [003-post](003-post/) | spec, data-model, api, pages | 岗位管理 - 用户职务配置 |
| [004-menu](004-menu/) | spec, data-model, api, pages | 菜单管理 - 菜单权限、按钮标识 |
| [005-role](005-role/) | spec, data-model, api, pages | 角色管理 - 权限分配、数据范围 |
| [006-dict](006-dict/) | spec, data-model, api, pages | 字典管理 - 固定数据维护 |
| [007-config](007-config/) | spec, data-model, api, pages | 参数管理 - 系统参数配置 |
| [008-notice](008-notice/) | spec, data-model, api, pages | 通知公告 - 系统通知发布 |
| [009-common](009-common/) | spec, data-model, api, pages | 公共模块 - 个人中心、首页 |

#### 日志与监控模块 (010-016)

| 模块 | 文档 | 说明 |
|------|------|------|
| [010-oper-log](010-oper-log/) | spec, data-model, api, pages | 操作日志 - 用户操作记录 |
| [011-login-log](011-login-log/) | spec, data-model, api, pages | 登录日志 - 登录记录查询 |
| [012-online](012-online/) | spec, data-model, api, pages | 在线用户 - 在线会话管理 |
| [013-job](013-job/) | spec, data-model, api, pages | 定时任务 - 任务调度管理 |
| [014-cache](014-cache/) | spec, data-model, api, pages | 缓存监控 - Redis 状态监控 |
| [015-server](015-server/) | spec, data-model, api, pages | 服务器监控 - CPU/内存/磁盘 |
| [016-pool](016-pool/) | spec, data-model, api, pages | 连接池监视 - Druid 监控 |

#### 系统工具模块 (017-019)

| 模块 | 文档 | 说明 |
|------|------|------|
| [017-gen](017-gen/) | spec, data-model, api, pages | 代码生成 - 表结构生成代码 |
| [018-swagger](018-swagger/) | spec, data-model, api, pages | 系统接口 - Swagger 配置 |
| [019-build](019-build/) | spec, data-model, api, pages | 在线构建器 - 前端构建工具 |

---

## 📊 完成情况

| 类别 | 模块数 | 文档数 | 状态 |
|------|--------|--------|------|
| 核心文档 | 10 | 10 | ✅ 100% |
| 系统管理模块 | 9 | 36 | ✅ 100% |
| 日志与监控模块 | 7 | 28 | ✅ 100% |
| 系统工具模块 | 3 | 12 | ✅ 100% |
| **总计** | **29** | **86** | ✅ 100% |

详细进度请参考 [SPECS_CHECKLIST.md](SPECS_CHECKLIST.md)

---

## 🔧 Speckit 工具使用

本规范文档使用以下 Speckit 技能生成：

| 技能 | 用途 |
|------|------|
| `speckit-baseline` | 从现有代码逆向生成规范文档 |
| `speckit-constitution` | 创建项目章程 |
| `speckit-specify` | 编写功能规格 |
| `speckit-plan` | 生成技术方案 |
| `speckit-tasks` | 生成任务清单 |
| `speckit-checklist` | 生成质量检查清单 |

---

## 📖 文档使用指南

### 开发人员
1. 阅读 `constitution.md` 了解项目原则
2. 查看 `overall-*` 系列文档了解整体架构
3. 根据开发需求查阅对应模块的 `spec.md` 和 `api.md`
4. 参考 `pages.md` 进行前端开发

### 测试人员
1. 根据 `spec.md` 中的验收标准编写测试用例
2. 参考 `api.md` 进行接口测试
3. 使用 `pages.md` 进行 UI 测试

### 运维人员
1. 查看 `ARCHITECTURE.md` 了解系统架构
2. 参考 `TECH.md` 了解技术栈和部署依赖
3. 使用监控模块文档进行日常运维

---

## 📝 更新记录

| 日期 | 版本 | 说明 |
|------|------|------|
| 2026-03-12 | 1.0 | 初始版本，完成所有核心模块规范文档 |
| 2026-03-13 | 1.1 | 更新文档索引，添加 README.md |

---

## 📞 联系方式

如有问题或建议，请联系项目维护人员。

---

<div align="center">

**RuoYi-Vue 规范文档** | 基于 Speckit 工具集生成

</div>
