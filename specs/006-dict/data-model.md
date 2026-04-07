# 006-Dict 字典管理模块数据模型

## 1. 数据表结构

### 1.1 sys_dict_type 字典类型表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| dict_id | BIGINT | 20 | 否 | 自增 | 字典主键（PK） |
| dict_name | VARCHAR | 100 | 是 | '' | 字典名称 |
| dict_type | VARCHAR | 100 | 是 | '' | 字典类型标识 |
| status | CHAR | 1 | 是 | '0' | 状态（0 正常 1 停用） |
| create_by | VARCHAR | 64 | 是 | '' | 创建者 |
| create_time | DATETIME | - | 是 | NULL | 创建时间 |
| update_by | VARCHAR | 64 | 是 | '' | 更新者 |
| update_time | DATETIME | - | 是 | NULL | 更新时间 |
| remark | VARCHAR | 500 | 是 | NULL | 备注 |

**索引：**
- PRIMARY KEY (dict_id)
- UNIQUE (dict_type) - 字典类型唯一索引

**示例数据：**
```sql
insert into sys_dict_type values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', sysdate(), '', null, '用户性别列表');
insert into sys_dict_type values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', sysdate(), '', null, '菜单状态列表');
insert into sys_dict_type values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', sysdate(), '', null, '系统开关列表');
insert into sys_dict_type values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', sysdate(), '', null, '系统是否列表');
```

### 1.2 sys_dict_data 字典数据表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| dict_code | BIGINT | 20 | 否 | 自增 | 字典编码（PK） |
| dict_sort | INT | 4 | 是 | 0 | 字典排序 |
| dict_label | VARCHAR | 100 | 是 | '' | 字典标签（显示值） |
| dict_value | VARCHAR | 100 | 是 | '' | 字典键值（实际值） |
| dict_type | VARCHAR | 100 | 是 | '' | 字典类型（FK -> sys_dict_type.dict_type） |
| css_class | VARCHAR | 100 | 是 | NULL | 样式属性（其他样式扩展） |
| list_class | VARCHAR | 100 | 是 | NULL | 表格回显样式 |
| is_default | CHAR | 1 | 是 | 'N' | 是否默认（Y 是 N 否） |
| status | CHAR | 1 | 是 | '0' | 状态（0 正常 1 停用） |
| create_by | VARCHAR | 64 | 是 | '' | 创建者 |
| create_time | DATETIME | - | 是 | NULL | 创建时间 |
| update_by | VARCHAR | 64 | 是 | '' | 更新者 |
| update_time | DATETIME | - | 是 | NULL | 更新时间 |
| remark | VARCHAR | 500 | 是 | NULL | 备注 |

**索引：**
- PRIMARY KEY (dict_code)

**示例数据：**
```sql
insert into sys_dict_data values(1, 1, '男',       '1',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', sysdate(), '', null, '性别男');
insert into sys_dict_data values(2, 2, '女',       '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别女');
insert into sys_dict_data values(3, 3, '未知',     '3',       'sys_user_sex',        '',   '',        'N', '0', 'admin', sysdate(), '', null, '性别未知');
```

## 2. 实体类

### 2.1 SysDictType 实体类

**包路径：** `com.ruoyi.common.core.domain.entity`

**属性：**
```java
public class SysDictType extends BaseEntity {
    private Long dictId;        // 字典主键
    private String dictName;    // 字典名称
    private String dictType;    // 字典类型标识
    private String status;      // 状态（0 正常 1 停用）
    // 继承 BaseEntity 的 createBy, createTime, updateBy, updateTime, remark
}
```

**校验规则：**
- `dictName`: @NotBlank, @Size(min=0, max=100)
- `dictType`: @NotBlank, @Size(min=0, max=100), @Pattern(regexp="^[a-z][a-z0-9_]*$")
- `status`: 无特殊校验

### 2.2 SysDictData 实体类

**包路径：** `com.ruoyi.common.core.domain.entity`

**属性：**
```java
public class SysDictData extends BaseEntity {
    private Long dictCode;      // 字典编码
    private Long dictSort;      // 字典排序
    private String dictLabel;   // 字典标签
    private String dictValue;   // 字典键值
    private String dictType;    // 字典类型
    private String cssClass;    // 样式属性
    private String listClass;   // 表格回显样式
    private String isDefault;   // 是否默认（Y 是 N 否）
    private String status;      // 状态（0 正常 1 停用）
    // 继承 BaseEntity 的 createBy, createTime, updateBy, updateTime, remark
}
```

**校验规则：**
- `dictLabel`: @NotBlank, @Size(min=0, max=100)
- `dictValue`: @NotBlank, @Size(min=0, max=100)
- `dictType`: @NotBlank, @Size(min=0, max=100)
- `cssClass`: @Size(min=0, max=100)
- `isDefault`: 无特殊校验，通过 `getDefault()` 方法转换为 boolean
- `status`: 无特殊校验

## 3. 数据关系

```
sys_dict_type (字典类型表)
    │
    │ 1:N
    │ dict_type (逻辑外键)
    ▼
sys_dict_data (字典数据表)
```

- 一个字典类型可以对应多个字典数据
- 字典数据通过 `dict_type` 字段关联到字典类型
- 该关联为逻辑外键，数据库层面无强制外键约束

## 4. 缓存设计

### 4.1 缓存键格式
- 字典数据缓存键：`sys_dict_type:{dictType}`
- 示例：`sys_dict_type:sys_user_sex`

### 4.2 缓存内容
- 缓存值为 `List<SysDictData>`，包含该类型下的所有字典数据
- 仅缓存状态为正常（status='0'）的字典数据

### 4.3 缓存策略
- 系统启动时自动加载所有字典数据到缓存
- 字典数据变更时自动更新缓存
- 支持手动刷新缓存

## 5. 数据权限

- 字典类型和字典数据为系统基础数据
- 所有用户均可查询字典数据（用于下拉框等）
- 仅授权用户可进行增删改操作

## 6. 数据初始化

系统初始化时预置以下字典类型：
1. sys_user_sex - 用户性别
2. sys_show_hide - 菜单状态
3. sys_normal_disable - 系统开关
4. sys_job_status - 任务状态
5. sys_job_group - 任务分组
6. sys_yes_no - 系统是否
7. sys_notice_type - 通知类型
8. sys_notice_status - 通知状态
9. sys_oper_type - 操作类型
10. sys_common_status - 系统状态
