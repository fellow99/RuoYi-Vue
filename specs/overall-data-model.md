# 数据模型文档 (overall-data-model.md)

**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据实体

### 1.1 实体分类

系统核心数据实体分为以下几类：

| 分类 | 实体 | 说明 |
|------|------|------|
| 用户相关 | SysUser | 用户信息 |
| 角色相关 | SysRole | 角色信息 |
| 菜单相关 | SysMenu | 菜单权限 |
| 部门相关 | SysDept | 部门信息 |
| 岗位相关 | SysPost | 岗位信息 |
| 字典相关 | SysDictType, SysDictData | 字典类型、字典数据 |
| 参数相关 | SysConfig | 参数配置 |
| 日志相关 | SysOperLog, SysLogininfor | 操作日志、登录日志 |
| 通知相关 | SysNotice | 通知公告 |
| 任务相关 | SysJob | 定时任务 |

---

## 二、实体关系

### 2.1 实体关系图 (ERD)

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  SysUser    │       │  SysRole    │       │  SysMenu    │
│  (用户)      │       │  (角色)      │       │  (菜单)      │
└──────┬──────┘       └──────┬──────┘       └──────┬──────┘
       │                    │                    │
       │                    │                    │
       ▼                    ▼                    ▼
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  SysDept    │       │  SysPost    │       │  SysDict    │
│  (部门)      │       │  (岗位)      │       │  (字典)      │
└─────────────┘       └─────────────┘       └─────────────┘
```

### 2.2 用户关系

```
SysUser (用户)
    │
    ├── belongs_to → SysDept (部门)
    │                 多对一，一个用户属于一个部门
    │
    ├── belongs_to → SysPost (岗位)
    │                 多对多，一个用户可担任多个岗位
    │                 关联表：sys_user_post
    │
    └── belongs_to → SysRole (角色)
                      多对多，一个用户可拥有多个角色
                      关联表：sys_user_role
```

### 2.3 角色关系

```
SysRole (角色)
    │
    ├── has_many → SysUser (用户)
    │              多对多，一个角色可分配给多个用户
    │              关联表：sys_user_role
    │
    └── has_many → SysMenu (菜单)
                   多对多，一个角色可拥有多个菜单权限
                   关联表：sys_role_menu
```

### 2.4 菜单关系

```
SysMenu (菜单)
    │
    ├── self_referencing → SysMenu (父菜单)
    │                       自关联，树形结构
    │                       parent_id 指向父菜单
    │
    └── has_many → SysRole (角色)
                   多对多，一个菜单可分配给多个角色
                   关联表：sys_role_menu
```

### 2.5 部门关系

```
SysDept (部门)
    │
    ├── self_referencing → SysDept (父部门)
    │                       自关联，树形结构
    │                       parent_id 指向父部门
    │
    └── has_many → SysUser (用户)
                   一对多，一个部门有多个用户
```

---

## 三、数据库表结构概览

### 3.1 用户相关表

#### sys_user (用户信息表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| user_id | BIGINT | - | 是 | 自增 | 用户 ID |
| dept_id | BIGINT | - | 否 | - | 部门 ID |
| user_name | VARCHAR | 30 | 是 | - | 用户账号 |
| nick_name | VARCHAR | 30 | 是 | - | 用户昵称 |
| user_type | VARCHAR | 2 | 否 | 00 | 用户类型 |
| email | VARCHAR | 50 | 否 | - | 用户邮箱 |
| phonenumber | VARCHAR | 11 | 否 | - | 手机号码 |
| sex | CHAR | 1 | 否 | 0 | 用户性别 |
| avatar | VARCHAR | 100 | 否 | - | 头像地址 |
| password | VARCHAR | 100 | 否 | - | 密码 |
| status | CHAR | 1 | 否 | 0 | 帐号状态 |
| del_flag | TINYINT | 1 | 否 | 0 | 删除标志 |
| login_ip | VARCHAR | 128 | 否 | - | 最后登录 IP |
| login_date | DATETIME | - | 否 | - | 最后登录时间 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (user_id)
- UNIQUE (user_name)
- INDEX (dept_id)
- INDEX (status)
- INDEX (create_time)

#### sys_user_role (用户和角色关联表)

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| user_id | BIGINT | - | 是 | 用户 ID |
| role_id | BIGINT | - | 是 | 角色 ID |

**索引：**
- PRIMARY KEY (user_id, role_id)

#### sys_user_post (用户与岗位关联表)

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| user_id | BIGINT | - | 是 | 用户 ID |
| post_id | BIGINT | - | 是 | 岗位 ID |

**索引：**
- PRIMARY KEY (user_id, post_id)

### 3.2 角色相关表

#### sys_role (角色信息表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| role_id | BIGINT | - | 是 | 自增 | 角色 ID |
| role_name | VARCHAR | 30 | 是 | - | 角色名称 |
| role_key | VARCHAR | 100 | 是 | - | 角色权限字符串 |
| role_sort | INT | - | 是 | - | 显示顺序 |
| data_scope | CHAR | 1 | 否 | 1 | 数据范围 |
| menu_check_strictly | TINYINT | 1 | 否 | 1 | 菜单树选择项是否关联显示 |
| dept_check_strictly | TINYINT | 1 | 否 | 1 | 部门树选择项是否关联显示 |
| status | CHAR | 1 | 是 | - | 角色状态 |
| del_flag | TINYINT | 1 | 否 | 0 | 删除标志 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (role_id)
- UNIQUE (role_key)
- INDEX (status)
- INDEX (create_time)

#### sys_role_menu (角色和菜单关联表)

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| role_id | BIGINT | - | 是 | 角色 ID |
| menu_id | BIGINT | - | 是 | 菜单 ID |

**索引：**
- PRIMARY KEY (role_id, menu_id)

### 3.3 菜单相关表

#### sys_menu (菜单权限表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| menu_id | BIGINT | - | 是 | 自增 | 菜单 ID |
| menu_name | VARCHAR | 50 | 是 | - | 菜单名称 |
| parent_id | BIGINT | - | 否 | 0 | 父菜单 ID |
| order_num | INT | - | 否 | 0 | 显示顺序 |
| path | VARCHAR | 200 | 否 | - | 路由地址 |
| component | VARCHAR | 255 | 否 | - | 组件路径 |
| query | VARCHAR | 255 | 否 | - | 路由参数 |
| is_frame | INT | - | 否 | 1 | 是否为外链 |
| is_cache | INT | - | 否 | 0 | 是否缓存 |
| menu_type | CHAR | 1 | 否 | - | 菜单类型 |
| visible | CHAR | 1 | 否 | 0 | 菜单状态 |
| status | CHAR | 1 | 否 | 0 | 菜单状态 |
| perms | VARCHAR | 100 | 否 | - | 权限标识 |
| icon | VARCHAR | 100 | 否 | # | 菜单图标 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (menu_id)
- INDEX (parent_id)
- INDEX (status)
- INDEX (create_time)

### 3.4 部门相关表

#### sys_dept (部门表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| dept_id | BIGINT | - | 是 | 自增 | 部门 ID |
| parent_id | BIGINT | - | 否 | 0 | 父部门 ID |
| ancestors | VARCHAR | 50 | 否 | - | 祖级列表 |
| dept_name | VARCHAR | 30 | 是 | - | 部门名称 |
| order_num | INT | - | 否 | 0 | 显示顺序 |
| leader | VARCHAR | 50 | 否 | - | 负责人 |
| phone | VARCHAR | 11 | 否 | - | 联系电话 |
| email | VARCHAR | 50 | 否 | - | 邮箱 |
| status | CHAR | 1 | 否 | 0 | 部门状态 |
| del_flag | TINYINT | 1 | 否 | 0 | 删除标志 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |

**索引：**
- PRIMARY KEY (dept_id)
- INDEX (parent_id)
- INDEX (status)
- INDEX (create_time)

### 3.5 岗位相关表

#### sys_post (岗位信息表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| post_id | BIGINT | - | 是 | 自增 | 岗位 ID |
| post_code | VARCHAR | 64 | 是 | - | 岗位编码 |
| post_name | VARCHAR | 50 | 是 | - | 岗位名称 |
| post_sort | INT | - | 是 | - | 显示顺序 |
| status | CHAR | 1 | 是 | - | 状态 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (post_id)
- UNIQUE (post_code)
- INDEX (status)

### 3.6 字典相关表

#### sys_dict_type (字典类型表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| dict_id | BIGINT | - | 是 | 自增 | 字典主键 |
| dict_name | VARCHAR | 100 | 是 | - | 字典名称 |
| dict_type | VARCHAR | 100 | 是 | - | 字典类型 |
| status | CHAR | 1 | 否 | 0 | 状态 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (dict_id)
- UNIQUE (dict_type)

#### sys_dict_data (字典数据表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| dict_code | BIGINT | - | 是 | 自增 | 字典编码 |
| dict_sort | INT | - | 否 | 0 | 字典排序 |
| dict_label | VARCHAR | 100 | 是 | - | 字典标签 |
| dict_value | VARCHAR | 100 | 是 | - | 字典键值 |
| dict_type | VARCHAR | 100 | 是 | - | 字典类型 |
| css_class | VARCHAR | 100 | 否 | - | 样式属性 |
| list_class | VARCHAR | 100 | 否 | - | 表格回显样式 |
| is_default | CHAR | 1 | 否 | N | 是否默认 |
| status | CHAR | 1 | 否 | 0 | 状态 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (dict_code)
- INDEX (dict_type)
- INDEX (status)

### 3.7 参数相关表

#### sys_config (参数配置表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| config_id | BIGINT | - | 是 | 自增 | 参数主键 |
| config_name | VARCHAR | 100 | 是 | - | 参数名称 |
| config_key | VARCHAR | 100 | 是 | - | 参数键名 |
| config_value | VARCHAR | 500 | 是 | - | 参数键值 |
| config_type | CHAR | 1 | 否 | N | 系统内置 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (config_id)
- UNIQUE (config_key)

### 3.8 日志相关表

#### sys_oper_log (操作日志记录)

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| oper_id | BIGINT | - | 是 | 日志主键 |
| title | VARCHAR | 50 | 否 | 模块标题 |
| business_type | INT | - | 否 | 业务类型 |
| method | VARCHAR | 100 | 否 | 方法名称 |
| request_method | VARCHAR | 10 | 否 | 请求方式 |
| operator_type | INT | - | 否 | 操作类别 |
| oper_name | VARCHAR | 50 | 否 | 操作人员 |
| dept_name | VARCHAR | 50 | 否 | 部门名称 |
| oper_url | VARCHAR | 255 | 否 | 请求 URL |
| oper_ip | VARCHAR | 128 | 否 | 主机地址 |
| oper_location | VARCHAR | 255 | 否 | 操作地点 |
| oper_param | VARCHAR | 2000 | 否 | 请求参数 |
| json_result | VARCHAR | 2000 | 否 | 返回参数 |
| status | INT | - | 否 | 操作状态 |
| error_msg | VARCHAR | 2000 | 否 | 错误消息 |
| oper_time | DATETIME | - | 否 | 操作时间 |
| cost_time | BIGINT | - | 否 | 消耗时间 |

**索引：**
- PRIMARY KEY (oper_id)
- INDEX (business_type)
- INDEX (status)
- INDEX (oper_time)

#### sys_logininfor (系统访问记录)

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| info_id | BIGINT | - | 是 | 访问主键 |
| user_name | VARCHAR | 50 | 否 | 用户账号 |
| status | CHAR | 1 | 否 | 登录状态 |
| ipaddr | VARCHAR | 128 | 否 | 登录 IP 地址 |
| login_location | VARCHAR | 255 | 否 | 登录地点 |
| browser | VARCHAR | 50 | 否 | 浏览器 |
| os | VARCHAR | 50 | 否 | 操作系统 |
| msg | VARCHAR | 255 | 否 | 提示消息 |
| login_time | DATETIME | - | 否 | 访问时间 |

**索引：**
- PRIMARY KEY (info_id)
- INDEX (user_name)
- INDEX (status)
- INDEX (login_time)

### 3.9 通知相关表

#### sys_notice (通知公告表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| notice_id | BIGINT | - | 是 | 自增 | 公告 ID |
| notice_title | VARCHAR | 50 | 是 | - | 公告标题 |
| notice_type | CHAR | 1 | 是 | - | 公告类型 |
| notice_content | LONGTEXT | - | 否 | - | 公告内容 |
| status | CHAR | 1 | 否 | 0 | 公告状态 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 255 | 否 | - | 备注 |

**索引：**
- PRIMARY KEY (notice_id)
- INDEX (status)
- INDEX (create_time)

### 3.10 任务相关表

#### sys_job (定时任务调度表)

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|--------|------|------|------|--------|------|
| job_id | BIGINT | - | 是 | 自增 | 任务 ID |
| job_name | VARCHAR | 64 | 是 | - | 任务名称 |
| job_group | VARCHAR | 64 | 是 | - | 任务组名 |
| invoke_target | VARCHAR | 500 | 是 | - | 调用目标字符串 |
| cron_expression | VARCHAR | 255 | 否 | - | cron 执行表达式 |
| misfire_policy | VARCHAR | 20 | 否 | 3 | 计划执行错误策略 |
| concurrent | CHAR | 1 | 否 | 1 | 是否并发执行 |
| status | CHAR | 1 | 否 | 0 | 状态 |
| create_by | VARCHAR | 64 | 否 | - | 创建者 |
| create_time | DATETIME | - | 否 | - | 创建时间 |
| update_by | VARCHAR | 64 | 否 | - | 更新者 |
| update_time | DATETIME | - | 否 | - | 更新时间 |
| remark | VARCHAR | 500 | 否 | - | 备注信息 |

**索引：**
- PRIMARY KEY (job_id)
- INDEX (job_name)
- INDEX (job_group)
- INDEX (status)

---

## 四、实体类结构

### 4.1 基类实体

#### BaseEntity (基础实体)

```java
public class BaseEntity implements Serializable {
    private static final long serialVersionUID = 1L;
    
    /** 搜索值 */
    private String searchValue;
    
    /** 创建者 */
    private String createBy;
    
    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;
    
    /** 更新者 */
    private String updateBy;
    
    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;
    
    /** 备注 */
    private String remark;
    
    /** 请求参数 */
    private Map<String, Object> params;
}
```

### 4.2 用户实体

#### SysUser

```java
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_user")
public class SysUser extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    /** 用户 ID */
    @TableId(type = IdType.AUTO)
    private Long userId;
    
    /** 部门 ID */
    private Long deptId;
    
    /** 用户账号 */
    private String userName;
    
    /** 用户昵称 */
    private String nickName;
    
    /** 用户类型 */
    private String userType;
    
    /** 用户邮箱 */
    private String email;
    
    /** 手机号码 */
    private String phonenumber;
    
    /** 用户性别 */
    private String sex;
    
    /** 用户头像 */
    private String avatar;
    
    /** 密码 */
    private String password;
    
    /** 帐号状态 */
    private String status;
    
    /** 删除标志 */
    private String delFlag;
    
    /** 最后登录 IP */
    private String loginIp;
    
    /** 最后登录时间 */
    private Date loginDate;
    
    /** 部门对象 */
    @TableField(exist = false)
    private SysDept dept;
    
    /** 角色对象 */
    @TableField(exist = false)
    private List<SysRole> roles;
    
    /** 角色组 */
    @TableField(exist = false)
    private Long[] roleIds;
    
    /** 岗位组 */
    @TableField(exist = false)
    private Long[] postIds;
}
```

### 4.3 角色实体

#### SysRole

```java
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("sys_role")
public class SysRole extends BaseEntity {
    
    private static final long serialVersionUID = 1L;
    
    /** 角色 ID */
    @TableId(type = IdType.AUTO)
    private Long roleId;
    
    /** 角色名称 */
    private String roleName;
    
    /** 角色权限字符串 */
    private String roleKey;
    
    /** 显示顺序 */
    private Integer roleSort;
    
    /** 数据范围 */
    private String dataScope;
    
    /** 菜单树选择项是否关联显示 */
    private Boolean menuCheckStrictly;
    
    /** 部门树选择项是否关联显示 */
    private Boolean deptCheckStrictly;
    
    /** 角色状态 */
    private String status;
    
    /** 删除标志 */
    private String delFlag;
    
    /** 菜单组 */
    @TableField(exist = false)
    private Long[] menuIds;
}
```

---

## 五、数据字典

### 5.1 系统内置字典

| 字典类型 | 字典名称 | 说明 |
|----------|----------|------|
| sys_user_sex | 用户性别 | 0=男，1=女，2=未知 |
| sys_normal_disable | 系统开关 | 0=正常，1=停用 |
| sys_job_status | 任务状态 | 0=正常，1=暂停 |
| sys_job_group | 任务组名 | default=系统默认 |
| sys_yes_no | 系统是否 | 0=否，1=是 |
| sys_notice_type | 公告类型 | 1=通知，2=公告 |
| sys_notice_status | 公告状态 | 0=正常，1=关闭 |
| sys_oper_type | 操作类型 | 1=新增，2=修改，3=删除 |
| sys_common_status | 通用状态 | 0=正常，1=异常 |

### 5.2 状态枚举

#### 用户状态

```java
public enum UserStatus {
    OK("0", "正常"),
    DISABLE("1", "停用"),
    DELETED("2", "删除");
}
```

#### 菜单类型

```java
public enum MenuType {
    M("M", "目录"),
    C("C", "菜单"),
    F("F", "按钮");
}
```

#### 数据范围

```java
public enum DataScope {
    DATA_SCOPE_ALL("1", "全部数据权限"),
    DATA_SCOPE_CUSTOM("2", "自定数据权限"),
    DATA_SCOPE_DEPT("3", "本部门数据权限"),
    DATA_SCOPE_DEPT_AND_CHILD("4", "本部门及以下数据权限"),
    DATA_SCOPE_SELF("5", "仅本人数据权限");
}
```

---

## 六、数据关系总结

### 6.1 一对一关系

| 表 A | 表 B | 说明 |
|------|------|------|
| sys_user | sys_dept | 用户 - 部门（多对一） |

### 6.2 一对多关系

| 表 A | 表 B | 说明 |
|------|------|------|
| sys_dept | sys_user | 部门 - 用户 |
| sys_menu | sys_menu | 菜单 - 子菜单（自关联） |
| sys_dept | sys_dept | 部门 - 子部门（自关联） |

### 6.3 多对多关系

| 表 A | 表 B | 关联表 | 说明 |
|------|------|--------|------|
| sys_user | sys_role | sys_user_role | 用户 - 角色 |
| sys_user | sys_post | sys_user_post | 用户 - 岗位 |
| sys_role | sys_menu | sys_role_menu | 角色 - 菜单 |

---

**文档版本：** 1.0  
**维护者：** 开发团队  
**最后更新：** 2026-03-12
