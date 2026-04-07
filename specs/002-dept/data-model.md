# 002-部门管理 - 数据模型

**模块编号：** 002  
**模块名称：** 部门管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 部门表 (sys_dept)

**表名：** `sys_dept`  
**说明：** 存储系统组织机构信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| dept_id | BIGINT | - | YES | - | 部门 ID（主键） |
| parent_id | BIGINT | - | NO | 0 | 父部门 ID |
| ancestors | VARCHAR | 50 | NO | - | 祖级列表 |
| dept_name | VARCHAR | 30 | YES | - | 部门名称 |
| order_num | INT | - | YES | 0 | 显示顺序 |
| leader | VARCHAR | 50 | NO | - | 负责人 |
| phone | VARCHAR | 11 | NO | - | 联系电话 |
| email | VARCHAR | 50 | NO | - | 邮箱 |
| status | CHAR | 1 | NO | 0 | 部门状态（0 正常 1 停用） |
| del_flag | CHAR | 1 | NO | 0 | 删除标志（0 代表存在 2 代表删除） |
| create_by | VARCHAR | 64 | NO | - | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | - | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |

**索引：**
- PRIMARY KEY (`dept_id`)
- KEY `idx_parent_id` (`parent_id`)
- KEY `idx_status` (`status`)
- KEY `idx_del_flag` (`del_flag`)

**约束：**
- 同级部门名称唯一（业务约束）

---

## 二、字段验证规则

### 2.1 SysDept 字段验证

| 字段 | 验证规则 | 错误提示 |
|------|---------|---------|
| deptName | @NotBlank, @Size(0,30) | 部门名称不能为空/长度不能超过 30 个字符 |
| orderNum | @NotNull | 显示顺序不能为空 |
| email | @Email, @Size(0,50) | 邮箱格式不正确/长度不能超过 50 个字符 |
| phone | @Size(0,11) | 联系电话长度不能超过 11 个字符 |

---

## 三、树形结构说明

### 3.1 祖级列表 (ancestors)

`ancestors` 字段存储从根节点到当前节点的所有祖先部门 ID，使用逗号分隔。

**示例：**
- 根部门：`"100"`
- 二级部门：`"100,101"`
- 三级部门：`"100,101,102"`

**用途：**
1. 快速查询所有子部门：`FIND_IN_SET(parent_id, ancestors)`
2. 判断部门层级关系
3. 数据权限 SQL 过滤

### 3.2 父子关系

```
sys_dept
├── 100 若依科技 (parent_id=0, ancestors="100")
│   ├── 101 深圳分公司 (parent_id=100, ancestors="100,101")
│   │   ├── 102 研发部门 (parent_id=101, ancestors="100,101,102")
│   │   └── 103 市场部门 (parent_id=101, ancestors="100,101,103")
│   └── 104 北京分公司 (parent_id=100, ancestors="100,104")
│       └── 105 人力资源部 (parent_id=104, ancestors="100,104,105")
```

---

## 四、数据状态说明

### 4.1 部门状态 (status)

| 值 | 说明 | 影响 |
|---|------|------|
| 0 | 正常 | 部门可用，用户可选择 |
| 1 | 停用 | 部门禁用，用户不可选择 |

### 4.2 删除标志 (delFlag)

| 值 | 说明 | 操作 |
|---|------|------|
| 0 | 存在 | 正常数据 |
| 2 | 删除 | 逻辑删除，查询时过滤 |

---

## 五、扩展字段说明

### 5.1 临时字段（非数据库字段）

以下字段用于数据传输和表单处理，不对应数据库字段：

| 字段名 | 类型 | 说明 |
|-------|------|------|
| parentName | String | 父部门名称（表单显示使用） |
| children | List<SysDept> | 子部门列表（树形结构使用） |

---

## 六、业务校验方法

### 6.1 部门名称唯一性校验

```java
// 校验部门名称是否唯一
boolean checkDeptNameUnique(SysDept dept);
```

**校验逻辑：**
1. 查询同级部门（parent_id 相同）
2. 排除自身（修改时）
3. 判断名称是否重复

### 6.2 子部门数量查询

```java
// 查询是否存在正常子部门
int selectNormalChildrenDeptById(Long deptId);
```

**用途：** 停用部门前检查

### 6.3 部门下用户数量查询

```java
// 查询部门是否存在用户
boolean checkDeptExistUser(Long deptId);
```

**用途：** 删除部门前检查

---

## 七、数据权限关联

部门表是数据权限的基础，通过 `dept_id` 字段关联：

1. **用户表**：`sys_user.dept_id` → `sys_dept.dept_id`
2. **角色数据范围**：`sys_role_dept` 关联表

数据范围类型：
- 1：全部数据权限
- 2：自定义数据权限（关联 `sys_role_dept`）
- 3：本部门数据权限
- 4：本部门及以下数据权限
- 5：仅本人数据权限
