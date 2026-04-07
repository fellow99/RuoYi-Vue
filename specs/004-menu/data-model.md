# 004-菜单管理 - 数据模型

**模块编号：** 004  
**模块名称：** 菜单管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 菜单权限表 (sys_menu)

**表名：** `sys_menu`  
**说明：** 存储系统菜单权限信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| menu_id | BIGINT | - | YES | - | 菜单 ID（主键） |
| menu_name | VARCHAR | 50 | YES | - | 菜单名称 |
| parent_id | BIGINT | - | NO | 0 | 父菜单 ID |
| order_num | INT | - | NO | 0 | 显示顺序 |
| path | VARCHAR | 200 | NO | - | 路由地址 |
| component | VARCHAR | 255 | NO | - | 组件路径 |
| query | VARCHAR | 255 | NO | - | 路由参数 |
| route_name | VARCHAR | 255 | NO | - | 路由名称 |
| is_frame | CHAR | 1 | NO | 1 | 是否外链（0 是 1 否） |
| is_cache | CHAR | 1 | NO | 0 | 是否缓存（0 缓存 1 不缓存） |
| menu_type | CHAR | 1 | NO | - | 类型（M 目录 C 菜单 F 按钮） |
| visible | CHAR | 1 | NO | 0 | 显示状态（0 显示 1 隐藏） |
| status | CHAR | 1 | NO | 0 | 菜单状态（0 正常 1 停用） |
| perms | VARCHAR | 100 | NO | - | 权限标识 |
| icon | VARCHAR | 100 | NO | - | 菜单图标 |
| create_by | VARCHAR | 64 | NO | - | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | - | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |
| remark | VARCHAR | 500 | NO | - | 备注 |

**索引：**
- PRIMARY KEY (`menu_id`)
- KEY `idx_parent_id` (`parent_id`)
- KEY `idx_menu_type` (`menu_type`)
- KEY `idx_status` (`status`)

---

## 二、关联表

### 2.1 角色菜单关联表 (sys_role_menu)

**表名：** `sys_role_menu`  
**说明：** 角色与菜单的多对多关联关系

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|-------|------|------|------|------|
| role_id | BIGINT | - | YES | 角色 ID（主键） |
| menu_id | BIGINT | - | YES | 菜单 ID（主键） |

**索引：**
- PRIMARY KEY (`role_id`, `menu_id`)
- KEY `idx_menu_id` (`menu_id`)

---

## 三、字段验证规则

### 3.1 SysMenu 字段验证

| 字段 | 验证规则 | 错误提示 |
|------|---------|---------|
| menuName | @NotBlank, @Size(0,50) | 菜单名称不能为空/长度不能超过 50 个字符 |
| orderNum | @NotNull | 显示顺序不能为空 |
| path | @Size(0,200) | 路由地址不能超过 200 个字符 |
| component | @Size(0,255) | 组件路径不能超过 255 个字符 |
| menuType | @NotBlank | 菜单类型不能为空 |
| perms | @Size(0,100) | 权限标识长度不能超过 100 个字符 |

---

## 四、字段枚举值

### 4.1 菜单类型 (menuType)

| 值 | 说明 | 用途 |
|---|------|------|
| M | 目录 | 一级或二级菜单分类 |
| C | 菜单 | 实际功能页面 |
| F | 按钮 | 页面内操作按钮 |

### 4.2 是否外链 (isFrame)

| 值 | 说明 |
|---|------|
| 0 | 是（地址必须以 http(s)://开头） |
| 1 | 否（内部路由） |

### 4.3 是否缓存 (isCache)

| 值 | 说明 |
|---|------|
| 0 | 缓存（Keep-Alive） |
| 1 | 不缓存 |

### 4.4 显示状态 (visible)

| 值 | 说明 |
|---|------|
| 0 | 显示 |
| 1 | 隐藏 |

### 4.5 菜单状态 (status)

| 值 | 说明 |
|---|------|
| 0 | 正常 |
| 1 | 停用 |

---

## 五、扩展字段说明

### 5.1 临时字段（非数据库字段）

| 字段名 | 类型 | 说明 |
|-------|------|------|
| parentName | String | 父菜单名称 |
| children | List<SysMenu> | 子菜单列表 |

---

## 六、业务校验方法

### 6.1 菜单名称唯一性校验

```java
boolean checkMenuNameUnique(SysMenu menu);
```

### 6.2 路由配置唯一性校验

```java
boolean checkRouteConfigUnique(SysMenu menu);
```

### 6.3 子菜单检查

```java
boolean hasChildByMenuId(Long menuId);
```

### 6.4 角色分配检查

```java
boolean checkMenuExistRole(Long menuId);
```
