# 005-角色管理 - 数据模型

**模块编号：** 005  
**模块名称：** 角色管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 角色表 (sys_role)

**表名：** `sys_role`  
**说明：** 存储系统角色信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| role_id | BIGINT | - | YES | - | 角色 ID（主键） |
| role_name | VARCHAR | 30 | YES | - | 角色名称 |
| role_key | VARCHAR | 100 | YES | - | 角色权限字符 |
| role_sort | INT | - | YES | 0 | 显示顺序 |
| data_scope | CHAR | 1 | NO | 1 | 数据范围 |
| menu_check_strictly | TINYINT | - | NO | 1 | 菜单树选择项是否关联显示 |
| dept_check_strictly | TINYINT | - | NO | 1 | 部门树选择项是否关联显示 |
| status | CHAR | 1 | NO | 0 | 角色状态（0 正常 1 停用） |
| del_flag | CHAR | 1 | NO | 0 | 删除标志（0 代表存在 2 代表删除） |
| create_by | VARCHAR | 64 | NO | - | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | - | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |
| remark | VARCHAR | 500 | NO | - | 备注 |

**索引：**
- PRIMARY KEY (`role_id`)
- UNIQUE KEY `uk_role_key` (`role_key`)
- KEY `idx_status` (`status`)
- KEY `idx_del_flag` (`del_flag`)

**约束：**
- `role_key` 唯一

---

## 二、关联表

### 2.1 用户角色关联表 (sys_user_role)

**表名：** `sys_user_role`  
**说明：** 用户与角色的多对多关联关系

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|-------|------|------|------|------|
| user_id | BIGINT | - | YES | 用户 ID（主键） |
| role_id | BIGINT | - | YES | 角色 ID（主键） |

**索引：**
- PRIMARY KEY (`user_id`, `role_id`)
- KEY `idx_role_id` (`role_id`)

---

### 2.2 角色菜单关联表 (sys_role_menu)

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

### 2.3 角色部门关联表 (sys_role_dept)

**表名：** `sys_role_dept`  
**说明：** 角色与部门的关联关系（用于自定义数据权限）

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|-------|------|------|------|------|
| role_id | BIGINT | - | YES | 角色 ID（主键） |
| dept_id | BIGINT | - | YES | 部门 ID（主键） |

**索引：**
- PRIMARY KEY (`role_id`, `dept_id`)
- KEY `idx_dept_id` (`dept_id`)

---

## 三、字段验证规则

### 3.1 SysRole 字段验证

| 字段 | 验证规则 | 错误提示 |
|------|---------|---------|
| roleName | @NotBlank, @Size(0,30) | 角色名称不能为空/长度不能超过 30 个字符 |
| roleKey | @NotBlank, @Size(0,100) | 权限字符不能为空/长度不能超过 100 个字符 |
| roleSort | @NotNull | 显示顺序不能为空 |

---

## 四、字段枚举值

### 4.1 数据范围 (dataScope)

| 值 | 说明 |
|---|------|
| 1 | 全部数据权限 |
| 2 | 自定义数据权限 |
| 3 | 本部门数据权限 |
| 4 | 本部门及以下数据权限 |
| 5 | 仅本人数据权限 |

### 4.2 菜单树关联显示 (menuCheckStrictly)

| 值 | 说明 |
|---|------|
| 0 | 父子不互相关联显示 |
| 1 | 父子互相关联显示 |

### 4.3 部门树关联显示 (deptCheckStrictly)

| 值 | 说明 |
|---|------|
| 0 | 父子不互相关联显示 |
| 1 | 父子互相关联显示 |

### 4.4 角色状态 (status)

| 值 | 说明 |
|---|------|
| 0 | 正常 |
| 1 | 停用 |

### 4.5 删除标志 (delFlag)

| 值 | 说明 |
|---|------|
| 0 | 存在 |
| 2 | 删除 |

---

## 五、扩展字段说明

### 5.1 临时字段（非数据库字段）

| 字段名 | 类型 | 说明 |
|-------|------|------|
| flag | boolean | 用户是否存在此角色标识（默认 false） |
| menuIds | Long[] | 菜单 ID 数组（表单提交使用） |
| deptIds | Long[] | 部门 ID 数组（数据权限使用） |
| permissions | Set<String> | 角色菜单权限集合 |

---

## 六、业务校验方法

### 6.1 角色名称唯一性校验

```java
boolean checkRoleNameUnique(SysRole role);
```

### 6.2 角色权限唯一性校验

```java
boolean checkRoleKeyUnique(SysRole role);
```

### 6.3 角色允许操作校验

```java
void checkRoleAllowed(SysRole role);
```

### 6.4 角色数据权限校验

```java
void checkRoleDataScope(Long roleId);
```

---

## 七、超级管理员说明

**角色 ID：** 1  
**角色权限：** `admin`

**特殊权限：**
- 拥有所有菜单权限
- 拥有所有数据权限
- 不允许删除、停用、修改权限
