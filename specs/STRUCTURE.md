# RuoYi-Vue 项目结构文档

**版本：** 3.9.1  
**生成时间：** 2026-03-12  
**技术栈：** Spring Boot 4.x + Vue 2.x + Element UI

---

## 一、项目概述

RuoYi-Vue 是一套基于 SpringBoot + Vue 前后端分离的 Java 快速开发框架。

### 技术架构

**后端技术栈：**
- Spring Boot 4.x (JDK 17+)
- Spring Security (权限认证)
- Redis & Jwt (缓存和令牌)
- MyBatis (ORM 框架)

**前端技术栈：**
- Vue 2.x
- Element UI (UI 组件库)
- Vuex (状态管理)
- Vue Router 3 (路由管理)
- Axios (HTTP 客户端)

---

## 二、目录树结构

```
RuoYi-Vue/
├── bin/                          # 启动脚本目录
│   ├── ry.bat                    # Windows 启动脚本
│   └── ry.sh                     # Linux 启动脚本
├── doc/                          # 项目文档目录
│   └── 若依环境使用手册.docx      # 环境使用手册
├── ruoyi-admin/                  # 后端主启动模块
│   └── src/main/
│       ├── java/com/ruoyi/web/
│       │   ├── controller/       # REST API 控制器
│       │   │   ├── common/       # 公共控制器
│       │   │   │   ├── CaptchaController.java    # 验证码接口
│       │   │   │   └── CommonController.java     # 通用接口
│       │   │   ├── monitor/      # 监控模块控制器
│       │   │   │   ├── CacheController.java      # 缓存监控
│       │   │   │   ├── ServerController.java     # 服务器监控
│       │   │   │   ├── SysLogininforController.java  # 登录日志
│       │   │   │   ├── SysOperlogController.java     # 操作日志
│       │   │   │   └── SysUserOnlineController.java  # 在线用户
│       │   │   ├── system/       # 系统模块控制器
│       │   │   │   ├── SysConfigController.java    # 参数配置
│       │   │   │   ├── SysDeptController.java      # 部门管理
│       │   │   │   ├── SysDictDataController.java  # 字典数据
│       │   │   │   ├── SysDictTypeController.java  # 字典类型
│       │   │   │   ├── SysIndexController.java     # 首页
│       │   │   │   ├── SysLoginController.java     # 登录接口
│       │   │   │   ├── SysMenuController.java      # 菜单管理
│       │   │   │   ├── SysNoticeController.java    # 通知公告
│       │   │   │   ├── SysPostController.java      # 岗位管理
│       │   │   │   ├── SysProfileController.java   # 个人中心
│       │   │   │   ├── SysRegisterController.java  # 注册接口
│       │   │   │   ├── SysRoleController.java      # 角色管理
│       │   │   │   └── SysUserController.java      # 用户管理
│       │   │   └── tool/         # 工具模块控制器
│       │   │       └── TestController.java         # 测试接口
│       │   └── core/config/      # 核心配置
│       └── resources/
│           ├── i18n/             # 国际化资源
│           ├── META-INF/         # 元数据
│           └── mybatis/          # MyBatis 配置
├── ruoyi-common/                 # 通用模块（核心公共代码）
│   └── src/main/java/com/ruoyi/common/
│       ├── annotation/           # 自定义注解
│       ├── config/               # 通用配置
│       ├── constant/             # 常量定义
│       ├── core/                 # 核心类
│       │   ├── controller/       # 基础控制器
│       │   ├── domain/           # 实体类
│       │   │   ├── entity/       # 系统实体
│       │   │   └── model/        # 数据模型
│       │   ├── page/             # 分页相关
│       │   ├── redis/            # Redis 工具
│       │   └── text/             # 文本处理
│       ├── enums/                # 枚举类
│       ├── exception/            # 异常处理
│       │   ├── base/             # 基础异常
│       │   ├── file/             # 文件异常
│       │   ├── job/              # 任务异常
│       │   └── user/             # 用户异常
│       ├── filter/               # 过滤器
│       ├── utils/                # 工具类
│       │   ├── bean/             # Bean 工具
│       │   ├── file/             # 文件工具
│       │   ├── html/             # HTML 工具
│       │   ├── http/             # HTTP 工具
│       │   ├── ip/               # IP 工具
│       │   ├── poi/              # Excel 工具
│       │   ├── reflect/          # 反射工具
│       │   ├── sign/             # 签名工具
│       │   ├── spring/           # Spring 工具
│       │   ├── sql/              # SQL 工具
│       │   └── uuid/             # UUID 工具
│       └── xss/                  # XSS 防护
├── ruoyi-framework/              # 框架模块（核心框架实现）
│   └── src/main/java/com/ruoyi/framework/
│       ├── aspectj/              # AOP 切面
│       ├── config/properties/    # 配置属性
│       ├── datasource/           # 数据源
│       ├── interceptor/          # 拦截器
│       ├── manager/              # 管理器
│       ├── security/             # 安全相关
│       │   ├── context/          # 安全上下文
│       │   ├── filter/           # 安全过滤器
│       │   └── handle/           # 安全处理器
│       └── web/                  # Web 相关
│           ├── domain/server/    # 服务器信息
│           ├── exception/        # Web 异常
│           └── service/          # Web 服务
├── ruoyi-generator/              # 代码生成模块
│   └── src/main/java/com/ruoyi/generator/
│       ├── config/               # 生成配置
│       ├── controller/           # 生成控制器
│       ├── domain/               # 生成实体
│       ├── mapper/               # 生成数据访问
│       ├── service/              # 生成服务
│       └── util/                 # 生成工具
├── ruoyi-quartz/                 # 定时任务模块
├── ruoyi-system/                 # 系统业务模块
│   └── src/main/java/com/ruoyi/system/
│       ├── domain/               # 系统实体
│       ├── mapper/               # 数据访问层
│       └── service/              # 业务服务层
│           └── impl/             # 服务实现
├── ruoyi-ui/                     # 前端项目（Vue 2.x）
│   ├── bin/                      # 构建脚本
│   ├── build/                    # 构建配置
│   ├── public/                   # 公共静态资源
│   │   ├── html/                 # HTML 模板
│   │   └── styles/               # 样式文件
│   └── src/
│       ├── api/                  # API 接口定义
│       │   ├── monitor/          # 监控模块 API
│       │   ├── system/           # 系统模块 API
│       │   │   └── dict/         # 字典 API
│       │   └── tool/             # 工具模块 API
│       ├── assets/               # 静态资源
│       │   ├── 401_images/       # 401 页面图片
│       │   ├── 404_images/       # 404 页面图片
│       │   ├── icons/svg/        # SVG 图标
│       │   ├── images/           # 通用图片
│       │   ├── logo/             # Logo 文件
│       │   └── styles/           # 样式文件
│       ├── components/           # 公共组件
│       │   ├── Breadcrumb/       # 面包屑
│       │   ├── Crontab/          # Cron 表达式生成器
│       │   ├── DictData/         # 字典数据
│       │   ├── DictTag/          # 字典标签
│       │   ├── Editor/           # 富文本编辑器
│       │   ├── FileUpload/       # 文件上传
│       │   ├── Hamburger/        # 汉堡菜单按钮
│       │   ├── HeaderSearch/     # 头部搜索
│       │   ├── IconSelect/       # 图标选择器
│       │   ├── iFrame/           # iframe 组件
│       │   ├── ImagePreview/     # 图片预览
│       │   ├── ImageUpload/      # 图片上传
│       │   ├── Pagination/       # 分页组件
│       │   ├── PanThumb/         # 缩略图
│       │   ├── ParentView/       # 父级视图
│       │   ├── RightToolbar/     # 右侧工具栏
│       │   ├── RuoYi/            # 若依组件
│       │   │   ├── Doc/          # 文档组件
│       │   │   └── Git/          # Git 组件
│       │   ├── Screenfull/       # 全屏
│       │   ├── SizeSelect/       # 尺寸选择
│       │   ├── SvgIcon/          # SVG 图标
│       │   ├── ThemePicker/      # 主题选择器
│       │   └── TopNav/           # 顶部导航
│       ├── directive/            # 自定义指令
│       │   ├── dialog/           # 对话框指令
│       │   ├── module/           # 模块指令
│       │   └── permission/       # 权限指令
│       ├── layout/               # 布局组件
│       │   ├── components/       # 布局子组件
│       │   │   ├── Copyright/    # 版权信息
│       │   │   ├── IframeToggle/ # iframe 切换
│       │   │   ├── InnerLink/    # 内部链接
│       │   │   ├── Settings/     # 设置面板
│       │   │   ├── Sidebar/      # 侧边栏
│       │   │   ├── TagsView/     # 标签页
│       │   │   └── TopBar/       # 顶部栏
│       │   └── mixin/            # 布局混入
│       ├── plugins/              # 插件
│       ├── router/               # 路由配置
│       │   └── index.js          # 路由主文件
│       ├── store/                # Vuex 状态管理
│       │   └── modules/          # 状态模块
│       ├── utils/                # 工具函数
│       │   └── dict/             # 字典工具
│       │   └── generator/        # 生成器工具
│       └── views/                # 页面视图
│           ├── dashboard/        # 首页仪表盘
│           ├── error/            # 错误页面
│           ├── index.vue         # 主首页组件
│           ├── login.vue         # 登录页
│           ├── redirect.vue      # 重定向页
│           ├── register.vue      # 注册页
│           ├── monitor/          # 系统监控
│           │   ├── cache/        # 缓存监控
│           │   ├── druid/        # Druid 连接池
│           │   ├── job/          # 定时任务
│           │   ├── logininfor/   # 登录日志
│           │   ├── online/       # 在线用户
│           │   ├── operlog/      # 操作日志
│           │   └── server/       # 服务器监控
│           ├── system/           # 系统管理
│           │   ├── config/       # 参数配置
│           │   ├── dept/         # 部门管理
│           │   ├── dict/         # 字典管理
│           │   ├── menu/         # 菜单管理
│           │   ├── notice/       # 通知公告
│           │   ├── post/         # 岗位管理
│           │   ├── role/         # 角色管理
│           │   └── user/         # 用户管理
│           └── tool/             # 系统工具
│               ├── build/        # 表单构建
│               ├── gen/          # 代码生成
│               └── swagger/      # Swagger 接口文档
├── sql/                          # 数据库脚本
├── .git/                         # Git 版本控制
├── .github/                      # GitHub 配置
├── .gitignore                    # Git 忽略文件
├── LICENSE                       # 开源协议
├── pom.xml                       # Maven 项目配置
├── ry.bat                        # Windows 启动脚本
└── ry.sh                         # Linux 启动脚本
```

---

## 三、前端页面和路由清单

### 3.1 公共路由（constantRoutes）

| 路径 | 组件 | 名称 | 标题 | 说明 |
|------|------|------|------|------|
| `/redirect` | Layout | - | - | 重定向路由 |
| `/redirect/:path(.*)` | redirect | - | - | 动态重定向 |
| `/login` | login | - | - | 登录页（隐藏） |
| `/register` | register | - | - | 注册页（隐藏） |
| `/404` | error/404 | - | - | 404 错误页（隐藏） |
| `/401` | error/401 | - | - | 401 错误页（隐藏） |
| `/` | Layout | Index | 首页 | 主首页 |
| `/user/profile` | system/user/profile | Profile | 个人中心 | 用户个人中心（隐藏） |

### 3.2 动态路由（dynamicRoutes）

| 路径 | 组件 | 名称 | 标题 | 权限要求 |
|------|------|------|------|----------|
| `/system/user-auth/role/:userId` | system/user/authRole | AuthRole | 分配角色 | system:user:edit |
| `/system/role-auth/user/:roleId` | system/role/authUser | AuthUser | 分配用户 | system:role:edit |
| `/system/dict-data/index/:dictId` | system/dict/data | Data | 字典数据 | system:dict:list |
| `/monitor/job-log/index/:jobId` | monitor/job/log | JobLog | 调度日志 | monitor:job:list |
| `/tool/gen-edit/index/:tableId` | tool/gen/editTable | GenEdit | 修改生成配置 | tool:gen:edit |

### 3.3 页面视图目录结构

```
views/
├── dashboard/              # 首页仪表盘
├── error/                  # 错误页面
│   ├── 404.vue            # 404 错误
│   └── 401.vue            # 401 错误
├── monitor/                # 系统监控
│   ├── cache/             # 缓存监控
│   ├── druid/             # Druid 连接池监控
│   ├── job/               # 定时任务
│   ├── logininfor/        # 登录日志
│   ├── online/            # 在线用户
│   ├── operlog/           # 操作日志
│   └── server/            # 服务器监控
├── system/                 # 系统管理
│   ├── config/            # 参数配置
│   ├── dept/              # 部门管理
│   ├── dict/              # 字典管理
│   ├── menu/              # 菜单管理
│   ├── notice/            # 通知公告
│   ├── post/              # 岗位管理
│   ├── role/              # 角色管理
│   └── user/              # 用户管理
└── tool/                   # 系统工具
    ├── build/             # 表单构建器
    ├── gen/               # 代码生成
    └── swagger/           # Swagger 接口文档
```

---

## 四、后端 REST API 清单

### 4.1 公共接口（/）

| 接口路径 | Method | 说明 | 入口文件 |
|----------|--------|------|----------|
| `/captchaImage` | GET | 获取验证码 | CaptchaController.java |
| `/login` | POST | 用户登录 | CommonController.java |
| `/logout` | POST | 用户退出 | CommonController.java |
| `/getInfo` | GET | 获取用户信息 | CommonController.java |

### 4.2 系统管理接口（/system）

#### 用户管理（/system/user）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/user/list` | GET | 获取用户列表 | system:user:list | SysUserController.java |
| `/system/user/export` | POST | 导出用户数据 | system:user:export | SysUserController.java |
| `/system/user/importData` | POST | 导入用户数据 | system:user:import | SysUserController.java |
| `/system/user/importTemplate` | POST | 下载导入模板 | - | SysUserController.java |
| `/system/user/` | GET | 获取用户详情 | system:user:query | SysUserController.java |
| `/system/user/{userId}` | GET | 获取指定用户详情 | system:user:query | SysUserController.java |
| `/system/user/` | POST | 新增用户 | system:user:add | SysUserController.java |
| `/system/user/` | PUT | 修改用户 | system:user:edit | SysUserController.java |
| `/system/user/{userIds}` | DELETE | 删除用户 | system:user:remove | SysUserController.java |
| `/system/user/changeStatus` | PUT | 修改用户状态 | system:user:edit | SysUserController.java |
| `/system/user/resetPwd` | PUT | 重置密码 | system:user:edit | SysUserController.java |
| `/system/user/{userId}/authRole` | GET | 查询用户角色 | system:user:query | SysUserController.java |
| `/system/user/{userId}/authRole` | POST | 分配角色 | system:user:edit | SysUserController.java |

#### 角色管理（/system/role）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/role/list` | GET | 获取角色列表 | system:role:list | SysRoleController.java |
| `/system/role/{roleId}` | GET | 获取角色详情 | system:role:query | SysRoleController.java |
| `/system/role/` | POST | 新增角色 | system:role:add | SysRoleController.java |
| `/system/role/` | PUT | 修改角色 | system:role:edit | SysRoleController.java |
| `/system/role/{roleIds}` | DELETE | 删除角色 | system:role:remove | SysRoleController.java |
| `/system/role/changeStatus` | PUT | 修改角色状态 | system:role:edit | SysRoleController.java |
| `/system/role/authUser/allocatedList` | GET | 查询已分配用户列表 | system:role:query | SysRoleController.java |
| `/system/role/authUser/selectAll` | PUT | 批量授权用户 | system:role:edit | SysRoleController.java |
| `/system/role/authUser/cancel` | PUT | 取消授权用户 | system:role:edit | SysRoleController.java |

#### 菜单管理（/system/menu）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/menu/list` | GET | 获取菜单列表 | system:menu:list | SysMenuController.java |
| `/system/menu/{menuId}` | GET | 获取菜单详情 | system:menu:query | SysMenuController.java |
| `/system/menu/` | POST | 新增菜单 | system:menu:add | SysMenuController.java |
| `/system/menu/` | PUT | 修改菜单 | system:menu:edit | SysMenuController.java |
| `/system/menu/{menuIds}` | DELETE | 删除菜单 | system:menu:remove | SysMenuController.java |
| `/system/menu/treeselect` | GET | 获取菜单树 | system:menu:list | SysMenuController.java |
| `/system/menu/roleMenuTreeselect` | GET | 获取角色菜单树 | system:menu:query | SysMenuController.java |

#### 部门管理（/system/dept）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/dept/list` | GET | 获取部门列表 | system:dept:list | SysDeptController.java |
| `/system/dept/{deptId}` | GET | 获取部门详情 | system:dept:query | SysDeptController.java |
| `/system/dept/` | POST | 新增部门 | system:dept:add | SysDeptController.java |
| `/system/dept/` | PUT | 修改部门 | system:dept:edit | SysDeptController.java |
| `/system/dept/{deptIds}` | DELETE | 删除部门 | system:dept:remove | SysDeptController.java |
| `/system/dept/treeselect` | GET | 获取部门树 | system:dept:list | SysDeptController.java |

#### 岗位管理（/system/post）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/post/list` | GET | 获取岗位列表 | system:post:list | SysPostController.java |
| `/system/post/{postId}` | GET | 获取岗位详情 | system:post:query | SysPostController.java |
| `/system/post/` | POST | 新增岗位 | system:post:add | SysPostController.java |
| `/system/post/` | PUT | 修改岗位 | system:post:edit | SysPostController.java |
| `/system/post/{postIds}` | DELETE | 删除岗位 | system:post:remove | SysPostController.java |

#### 字典管理（/system/dict）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/dict/type/list` | GET | 获取字典类型列表 | system:dict:list | SysDictTypeController.java |
| `/system/dict/type/{dictId}` | GET | 获取字典类型详情 | system:dict:query | SysDictTypeController.java |
| `/system/dict/type/` | POST | 新增字典类型 | system:dict:add | SysDictTypeController.java |
| `/system/dict/type/` | PUT | 修改字典类型 | system:dict:edit | SysDictTypeController.java |
| `/system/dict/type/{dictIds}` | DELETE | 删除字典类型 | system:dict:remove | SysDictTypeController.java |
| `/system/dict/data/list` | GET | 获取字典数据列表 | system:dict:list | SysDictDataController.java |
| `/system/dict/data/{dictCode}` | GET | 获取字典数据详情 | system:dict:query | SysDictDataController.java |
| `/system/dict/data/` | POST | 新增字典数据 | system:dict:add | SysDictDataController.java |
| `/system/dict/data/` | PUT | 修改字典数据 | system:dict:edit | SysDictDataController.java |
| `/system/dict/data/{dictCodes}` | DELETE | 删除字典数据 | system:dict:remove | SysDictDataController.java |

#### 参数配置（/system/config）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/config/list` | GET | 获取参数列表 | system:config:list | SysConfigController.java |
| `/system/config/{configId}` | GET | 获取参数详情 | system:config:query | SysConfigController.java |
| `/system/config/` | POST | 新增参数 | system:config:add | SysConfigController.java |
| `/system/config/` | PUT | 修改参数 | system:config:edit | SysConfigController.java |
| `/system/config/{configIds}` | DELETE | 删除参数 | system:config:remove | SysConfigController.java |
| `/system/config/configKey/{configKey}` | GET | 根据 Key 查询参数 | system:config:query | SysConfigController.java |

#### 通知公告（/system/notice）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/notice/list` | GET | 获取公告列表 | system:notice:list | SysNoticeController.java |
| `/system/notice/{noticeId}` | GET | 获取公告详情 | system:notice:query | SysNoticeController.java |
| `/system/notice/` | POST | 新增公告 | system:notice:add | SysNoticeController.java |
| `/system/notice/` | PUT | 修改公告 | system:notice:edit | SysNoticeController.java |
| `/system/notice/{noticeIds}` | DELETE | 删除公告 | system:notice:remove | SysNoticeController.java |

#### 个人中心（/system/user/profile）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/system/user/profile` | GET | 获取个人信息 | - | SysProfileController.java |
| `/system/user/profile` | PUT | 修改个人信息 | - | SysProfileController.java |
| `/system/user/profile/updatePwd` | PUT | 修改密码 | - | SysProfileController.java |
| `/system/user/profile/avatar` | POST | 上传头像 | - | SysProfileController.java |

#### 登录注册（/）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/login` | POST | 用户登录 | - | SysLoginController.java |
| `/register` | POST | 用户注册 | - | SysRegisterController.java |

### 4.3 系统监控接口（/monitor）

#### 登录日志（/monitor/logininfor）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/logininfor/list` | GET | 获取登录日志列表 | monitor:logininfor:list | SysLogininforController.java |
| `/monitor/logininfor/{infoIds}` | DELETE | 删除登录日志 | monitor:logininfor:remove | SysLogininforController.java |
| `/monitor/logininfor/clean` | DELETE | 清空登录日志 | monitor:logininfor:remove | SysLogininforController.java |
| `/monitor/logininfor/unlock` | POST | 解锁账户 | monitor:logininfor:unlock | SysLogininforController.java |

#### 操作日志（/monitor/operlog）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/operlog/list` | GET | 获取操作日志列表 | monitor:operlog:list | SysOperlogController.java |
| `/monitor/operlog/{operId}` | GET | 获取操作日志详情 | monitor:operlog:query | SysOperlogController.java |
| `/monitor/operlog/{operIds}` | DELETE | 删除操作日志 | monitor:operlog:remove | SysOperlogController.java |
| `/monitor/operlog/clean` | DELETE | 清空操作日志 | monitor:operlog:remove | SysOperlogController.java |

#### 在线用户（/monitor/online）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/online/list` | GET | 获取在线用户列表 | monitor:online:list | SysUserOnlineController.java |
| `/monitor/online/{tokenId}` | DELETE | 强退用户 | monitor:online:force | SysUserOnlineController.java |

#### 定时任务（/monitor/job）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/job/list` | GET | 获取任务列表 | monitor:job:list | - |
| `/monitor/job/{jobId}` | GET | 获取任务详情 | monitor:job:query | - |
| `/monitor/job/` | POST | 新增任务 | monitor:job:add | - |
| `/monitor/job/` | PUT | 修改任务 | monitor:job:edit | - |
| `/monitor/job/{jobIds}` | DELETE | 删除任务 | monitor:job:remove | - |
| `/monitor/job/changeStatus` | PUT | 修改任务状态 | monitor:job:edit | - |
| `/monitor/job/{jobIds}/run` | PUT | 执行任务 | monitor:job:change | - |
| `/monitor/job/detail/{jobId}` | GET | 获取任务详细信息 | monitor:job:query | - |
| `/monitor/job/log/list` | GET | 获取任务执行日志 | monitor:job:list | - |

#### 缓存监控（/monitor/cache）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/cache` | GET | 获取缓存信息 | monitor:cache:list | CacheController.java |
| `/monitor/cache/getNames` | GET | 获取缓存名称列表 | monitor:cache:list | CacheController.java |
| `/monitor/cache/getKeys/{cacheName}` | GET | 获取键名列表 | monitor:cache:list | CacheController.java |
| `/monitor/cache/getValue/{cacheName}/{cacheKey}` | GET | 获取缓存值 | monitor:cache:list | CacheController.java |
| `/monitor/cache/clearCacheName/{cacheName}` | DELETE | 清理缓存 | monitor:cache:remove | CacheController.java |
| `/monitor/cache/clearCacheKey/{cacheKey}` | DELETE | 清理键值 | monitor:cache:remove | CacheController.java |
| `/monitor/cache/clearCacheAll` | DELETE | 清理全部缓存 | monitor:cache:remove | CacheController.java |

#### 服务器监控（/monitor/server）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/monitor/server` | GET | 获取服务器信息 | monitor:server:list | ServerController.java |

### 4.4 系统工具接口（/tool）

#### 代码生成（/tool/gen）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/tool/gen/list` | GET | 获取生成表列表 | tool:gen:list | GenController.java |
| `/tool/gen/{tableId}` | GET | 获取生成表详情 | tool:gen:query | GenController.java |
| `/tool/gen/importTable` | POST | 导入表结构 | tool:gen:import | GenController.java |
| `/tool/gen/editTable` | PUT | 修改生成配置 | tool:gen:edit | GenController.java |
| `/tool/gen/{tableIds}` | DELETE | 删除生成表 | tool:gen:remove | GenController.java |
| `/tool/gen/batchGenCode` | GET | 批量生成代码 | tool:gen:code | GenController.java |
| `/tool/gen/preview` | GET | 预览生成代码 | tool:gen:preview | GenController.java |
| `/tool/gen/download/{tableName}` | GET | 下载生成代码 | tool:gen:code | GenController.java |
| `/tool/gen/db/list` | GET | 获取数据库列表 | tool:gen:list | GenController.java |

#### Swagger 接口（/tool/swagger）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/tool/swagger` | GET | Swagger 文档首页 | - | - |

### 4.5 测试接口（/test）

| 接口路径 | Method | 说明 | 权限 | 入口文件 |
|----------|--------|------|------|----------|
| `/test/annotation` | GET | 测试注解 | - | TestController.java |
| `/test/demo/form` | POST | 测试表单 | - | TestController.java |

---

## 五、模块依赖关系

```
ruoyi-admin (主启动模块)
├── ruoyi-common (通用模块)
├── ruoyi-system (系统业务模块)
├── ruoyi-framework (框架模块)
├── ruoyi-generator (代码生成模块)
└── ruoyi-quartz (定时任务模块)
```

---

## 六、数据库表结构

数据库脚本位于 `sql/` 目录，主要包含：
- 系统基础表（用户、角色、菜单、部门等）
- 业务示例表
- 初始化数据

---

## 七、配置文件说明

### 后端配置
- `ruoyi-admin/src/main/resources/application.yml` - 主配置文件
- `ruoyi-admin/src/main/resources/application-druid.yml` - 数据库连接池配置
- `ruoyi-admin/src/main/resources/application-redis.yml` - Redis 配置

### 前端配置
- `ruoyi-ui/vue.config.js` - Vue CLI 配置
- `ruoyi-ui/src/utils/request.js` - Axios 请求配置
- `ruoyi-ui/src/settings.js` - 系统设置

---

## 八、开发环境要求

### 后端
- JDK 17+
- Maven 3.6+
- MySQL 5.7+ / 8.0+
- Redis 5.0+

### 前端
- Node.js 14.x+
- npm 6.x+ 或 yarn 1.x+

---

**文档生成完成**
