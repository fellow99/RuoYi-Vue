# 001-用户管理 - 数据模型

**模块编号：** 001  
**模块名称：** 用户管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 用户表 (sys_user)

**表名：** `sys_user`  
**说明：** 存储系统用户基本信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| user_id | BIGINT | - | YES | - | 用户 ID（主键） |
| dept_id | BIGINT | - | NO | NULL | 部门 ID |
| user_name | VARCHAR | 30 | YES | - | 用户账号 |
| nick_name | VARCHAR | 30 | YES | - | 用户昵称 |
| email | VARCHAR | 50 | NO | - | 用户邮箱 |
| phonenumber | VARCHAR | 11 | NO | - | 手机号码 |
| sex | CHAR | 1 | NO | 0 | 性别（0 男 1 女 2 未知） |
| avatar | VARCHAR | 100 | NO | - | 头像地址 |
| password | VARCHAR | 100 | NO | - | 密码（BCrypt 加密） |
| status | CHAR | 1 | NO | 0 | 帐号状态（0 正常 1 停用） |
| del_flag | CHAR | 1 | NO | 0 | 删除标志（0 代表存在 2 代表删除） |
| login_ip | VARCHAR | 128 | NO | - | 最后登录 IP |
| login_date | DATETIME | - | NO | NULL | 最后登录时间 |
| pwd_update_date | DATETIME | - | NO | NULL | 密码最后更新时间 |
| create_by | VARCHAR | 64 | NO | - | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | - | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |
| remark | VARCHAR | 500 | NO | - | 备注 |

**索引：**
- PRIMARY KEY (`user_id`)
- UNIQUE KEY `uk_user_name` (`user_name`)
- KEY `idx_dept_id` (`dept_id`)
- KEY `idx_status` (`status`)
- KEY `idx_del_flag` (`del_flag`)

**约束：**
- `user_name` 唯一
- `phonenumber` 业务唯一
- `email` 业务唯一

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

### 2.2 用户岗位关联表 (sys_user_post)

**表名：** `sys_user_post`  
**说明：** 用户与岗位的多对多关联关系

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|-------|------|------|------|------|
| user_id | BIGINT | - | YES | 用户 ID（主键） |
| post_id | BIGINT | - | YES | 岗位 ID（主键） |

**索引：**
- PRIMARY KEY (`user_id`, `post_id`)
- KEY `idx_post_id` (`post_id`)

---

## 三、关联实体

### 3.1 部门实体 (SysDept)

用户表通过 `dept_id` 关联部门实体，详见 [002-dept/data-model.md](../002-dept/data-model.md)

**关联字段：**
- `dept` - 部门对象（包含部门名称、负责人等信息）

---

### 3.2 角色实体 (SysRole)

用户通过 `sys_user_role` 关联表与角色建立多对多关系，详见 [005-role/data-model.md](../005-role/data-model.md)

**关联字段：**
- `roles` - 角色对象列表
- `roleIds` - 角色 ID 数组（表单使用）

---

### 3.3 岗位实体 (SysPost)

用户通过 `sys_user_post` 关联表与岗位建立多对多关系，详见 [003-post/data-model.md](../003-post/data-model.md)

**关联字段：**
- `postIds` - 岗位 ID 数组（表单使用）

---

## 四、数据模型类图

```
┌─────────────────┐       ┌──────────────────┐
│    SysUser      │       │    SysDept       │
├─────────────────┤       ├──────────────────┤
│ - userId        │──────▶│ - deptId         │
│ - deptId        │       │ - deptName       │
│ - userName      │       │ - leader         │
│ - nickName      │       │ - status         │
│ - email         │       └──────────────────┘
│ - phonenumber   │
│ - sex           │       ┌──────────────────┐
│ - avatar        │       │    SysRole       │
│ - password      │       ├──────────────────┤
│ - status        │       │ - roleId         │
│ - delFlag       │       │ - roleName       │
│ - loginIp       │       │ - roleKey        │
│ - loginDate     │       │ - dataScope      │
│ - pwdUpdateDate │       │ - status         │
└────────┬────────┘       └──────────────────┘
         │
         │ N:N
         │
         ▼
┌──────────────────┐       ┌──────────────────┐
│  SysUserRole     │       │    SysPost       │
├──────────────────┤       ├──────────────────┤
│ - userId         │       │ - postId         │
│ - roleId         │       │ - postCode       │
└──────────────────┘       │ - postName       │
                           │ - postSort       │
                           │ - status         │
                           └──────────────────┘
```

---

## 五、字段验证规则

### 5.1 SysUser 字段验证

| 字段 | 验证规则 | 错误提示 |
|------|---------|---------|
| userName | @NotBlank, @Size(0,30), @Xss | 用户账号不能为空/长度不能超过 30 个字符/不能包含脚本字符 |
| nickName | @Size(0,30), @Xss | 用户昵称长度不能超过 30 个字符/不能包含脚本字符 |
| email | @Email, @Size(0,50) | 邮箱格式不正确/长度不能超过 50 个字符 |
| phonenumber | @Size(0,11) | 手机号码长度不能超过 11 个字符 |

### 5.2 业务唯一性校验

```java
// 校验用户名称是否唯一
SysUser checkUserNameUnique(String userName);

// 校验手机号码是否唯一
SysUser checkPhoneUnique(String phonenumber);

// 校验 email 是否唯一
SysUser checkEmailUnique(String email);
```

---

## 六、数据状态说明

### 6.1 用户状态 (status)

| 值 | 说明 | 影响 |
|---|------|------|
| 0 | 正常 | 可正常登录系统 |
| 1 | 停用 | 禁止登录，保留历史数据 |

### 6.2 删除标志 (delFlag)

| 值 | 说明 | 操作 |
|---|------|------|
| 0 | 存在 | 正常数据 |
| 2 | 删除 | 逻辑删除，查询时过滤 |

### 6.3 性别 (sex)

| 值 | 说明 |
|---|------|
| 0 | 男 |
| 1 | 女 |
| 2 | 未知 |

---

## 七、扩展字段说明

### 7.1 临时字段（非数据库字段）

以下字段用于数据传输和表单处理，不对应数据库字段：

| 字段名 | 类型 | 说明 |
|-------|------|------|
| dept | SysDept | 部门对象（查询时关联） |
| roles | List<SysRole> | 角色对象列表（查询时关联） |
| roleIds | Long[] | 角色 ID 数组（表单提交使用） |
| postIds | Long[] | 岗位 ID 数组（表单提交使用） |
| roleId | Long | 单个角色 ID（特殊场景使用） |

---

## 八、数据权限字段

用户表支持数据权限过滤，通过以下字段实现：

- `dept_id` - 部门 ID：用于部门数据范围过滤
- `create_by` - 创建者：用于仅本人数据权限过滤

数据范围通过 `@DataScope` 注解自动注入 SQL 过滤条件。
