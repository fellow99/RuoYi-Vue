# 003-岗位管理 - 数据模型

**模块编号：** 003  
**模块名称：** 岗位管理  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 岗位表 (sys_post)

**表名：** `sys_post`  
**说明：** 存储系统岗位信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| post_id | BIGINT | - | YES | - | 岗位 ID（主键） |
| post_code | VARCHAR | 64 | YES | - | 岗位编码 |
| post_name | VARCHAR | 50 | YES | - | 岗位名称 |
| post_sort | INT | - | YES | 0 | 显示顺序 |
| status | CHAR | 1 | NO | 0 | 状态（0 正常 1 停用） |
| create_by | VARCHAR | 64 | NO | - | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | - | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |
| remark | VARCHAR | 500 | NO | - | 备注 |

**索引：**
- PRIMARY KEY (`post_id`)
- UNIQUE KEY `uk_post_code` (`post_code`)
- UNIQUE KEY `uk_post_name` (`post_name`)

**约束：**
- `post_code` 唯一
- `post_name` 唯一

---

## 二、关联表

### 2.1 用户岗位关联表 (sys_user_post)

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

## 三、字段验证规则

### 3.1 SysPost 字段验证

| 字段 | 验证规则 | 错误提示 |
|------|---------|---------|
| postCode | @NotBlank, @Size(0,64) | 岗位编码不能为空/长度不能超过 64 个字符 |
| postName | @NotBlank, @Size(0,50) | 岗位名称不能为空/长度不能超过 50 个字符 |
| postSort | @NotNull | 显示顺序不能为空 |

---

## 四、数据状态说明

### 4.1 岗位状态 (status)

| 值 | 说明 | 影响 |
|---|------|------|
| 0 | 正常 | 岗位可用，用户可选择 |
| 1 | 停用 | 岗位禁用，用户不可选择 |

---

## 五、扩展字段说明

### 5.1 临时字段（非数据库字段）

| 字段名 | 类型 | 说明 |
|-------|------|------|
| flag | boolean | 用户是否存在此岗位标识（默认 false） |

---

## 六、业务校验方法

### 6.1 岗位编码唯一性校验

```java
// 校验岗位编码是否唯一
boolean checkPostCodeUnique(SysPost post);
```

### 6.2 岗位名称唯一性校验

```java
// 校验岗位名称是否唯一
boolean checkPostNameUnique(SysPost post);
```

### 6.3 查询用户所属岗位

```java
// 根据用户 ID 查询岗位 ID 列表
List<Long> selectPostListByUserId(Long userId);

// 根据用户 ID 查询岗位列表
List<SysPost> selectPostsByUserId(Long userId);
```
