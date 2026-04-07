# 017-代码生成 - 数据模型

**模块编号：** 017  
**模块名称：** 代码生成  
**版本：** 3.9.1  
**最后更新：** 2026-03-12

---

## 一、核心数据表

### 1.1 代码生成业务表 (gen_table)

**表名：** `gen_table`  
**说明：** 存储代码生成的表配置信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| table_id | BIGINT | 20 | YES | - | 编号（主键，自增） |
| table_name | VARCHAR | 200 | YES | '' | 表名称 |
| table_comment | VARCHAR | 500 | YES | '' | 表描述 |
| sub_table_name | VARCHAR | 64 | NO | NULL | 关联子表的表名 |
| sub_table_fk_name | VARCHAR | 64 | NO | NULL | 子表关联的外键名 |
| class_name | VARCHAR | 100 | YES | '' | 实体类名称（首字母大写） |
| tpl_category | VARCHAR | 200 | YES | 'crud' | 使用的模板（crud/tree/sub） |
| tpl_web_type | VARCHAR | 30 | YES | '' | 前端模板类型（element-ui/element-plus/element-plus-typescript） |
| package_name | VARCHAR | 100 | YES | - | 生成包路径 |
| module_name | VARCHAR | 30 | YES | - | 生成模块名 |
| business_name | VARCHAR | 30 | YES | - | 生成业务名 |
| function_name | VARCHAR | 50 | YES | - | 生成功能名 |
| function_author | VARCHAR | 50 | YES | - | 生成功能作者 |
| gen_type | CHAR | 1 | YES | '0' | 生成代码方式（0=ZIP 压缩包/1=自定义路径） |
| gen_path | VARCHAR | 200 | YES | '/' | 生成路径（不填默认项目路径） |
| options | VARCHAR | 1000 | NO | NULL | 其它生成选项（JSON 格式） |
| create_by | VARCHAR | 64 | NO | '' | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | '' | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |
| remark | VARCHAR | 500 | NO | NULL | 备注 |

**索引：**
- PRIMARY KEY (`table_id`)
- KEY `idx_table_name` (`table_name`)

**约束：**
- `table_name` 业务唯一

**JSON 选项字段 (options) 结构：**
```json
{
  "treeCode": "parent_id",      // 树编码字段
  "treeName": "dept_name",      // 树名称字段
  "treeParentCode": "parent_id", // 树父编码字段
  "parentMenuId": "100"          // 上级菜单 ID
}
```

---

### 1.2 代码生成业务表字段 (gen_table_column)

**表名：** `gen_table_column`  
**说明：** 存储代码生成的列配置信息

| 字段名 | 类型 | 长度 | 必填 | 默认值 | 说明 |
|-------|------|------|------|--------|------|
| column_id | BIGINT | 20 | YES | - | 编号（主键，自增） |
| table_id | BIGINT | 20 | YES | - | 归属表编号（外键） |
| column_name | VARCHAR | 200 | YES | - | 列名称 |
| column_comment | VARCHAR | 500 | YES | - | 列描述 |
| column_type | VARCHAR | 100 | YES | - | 列类型（数据库类型） |
| java_type | VARCHAR | 500 | YES | - | JAVA 类型 |
| java_field | VARCHAR | 200 | YES | - | JAVA 字段名（驼峰命名） |
| is_pk | CHAR | 1 | NO | NULL | 是否主键（1=是） |
| is_increment | CHAR | 1 | NO | NULL | 是否自增（1=是） |
| is_required | CHAR | 1 | NO | NULL | 是否必填（1=是） |
| is_insert | CHAR | 1 | NO | NULL | 是否为插入字段（1=是） |
| is_edit | CHAR | 1 | NO | NULL | 是否编辑字段（1=是） |
| is_list | CHAR | 1 | NO | NULL | 是否列表字段（1=是） |
| is_query | CHAR | 1 | NO | NULL | 是否查询字段（1=是） |
| query_type | VARCHAR | 200 | YES | 'EQ' | 查询方式（EQ/NE/GT/LT/LIKE/BETWEEN） |
| html_type | VARCHAR | 200 | YES | - | 显示类型（input/textarea/select/checkbox/radio/datetime/image/upload/editor） |
| dict_type | VARCHAR | 200 | YES | '' | 字典类型 |
| sort | INT | - | YES | - | 排序 |
| create_by | VARCHAR | 64 | NO | '' | 创建者 |
| create_time | DATETIME | - | NO | NULL | 创建时间 |
| update_by | VARCHAR | 64 | NO | '' | 更新者 |
| update_time | DATETIME | - | NO | NULL | 更新时间 |

**索引：**
- PRIMARY KEY (`column_id`)
- KEY `idx_table_id` (`table_id`)
- KEY `idx_column_name` (`column_name`)

**约束：**
- 外键：`table_id` 关联 `gen_table.table_id`

---

## 二、字段类型映射规则

### 2.1 数据库类型到 Java 类型

| 数据库类型 | Java 类型 | 示例 |
|-----------|----------|------|
| varchar(n) | String | user_name |
| char(n) | String | sex |
| text | String | description |
| longtext | String | content |
| int(n) | Integer | age |
| integer | Integer | count |
| bigint(n) | Long | id |
| decimal(n,d) | BigDecimal | price |
| numeric(n,d) | BigDecimal | amount |
| datetime | Date | create_time |
| timestamp | Date | update_time |
| date | Date | birthday |
| tinyint(1) | Boolean | deleted |
| tinyint(n) | Integer | status |
| smallint(n) | Integer | sort |

### 2.2 字段命名转换

| 数据库字段 | Java 字段 | 说明 |
|-----------|----------|------|
| user_name | userName | 下划线转驼峰 |
| dept_id | deptId | 下划线转驼峰 |
| create_time | createTime | 下划线转驼峰 |

---

## 三、实体类关系

### 3.1 GenTable 实体

```java
public class GenTable extends BaseEntity {
    private Long tableId;              // 编号
    private String tableName;          // 表名称
    private String tableComment;       // 表描述
    private String subTableName;       // 关联子表的表名
    private String subTableFkName;     // 子表关联的外键名
    private String className;          // 实体类名称
    private String tplCategory;        // 模板类型
    private String tplWebType;         // 前端模板类型
    private String packageName;        // 包路径
    private String moduleName;         // 模块名
    private String businessName;       // 业务名
    private String functionName;       // 功能名
    private String functionAuthor;     // 作者
    private String genType;            // 生成方式
    private String genPath;            // 生成路径
    private String options;            // 其它选项（JSON）
    
    // 关联对象
    private GenTableColumn pkColumn;   // 主键列
    private GenTable subTable;         // 子表
    private List<GenTableColumn> columns; // 列列表
    
    // 树表字段
    private String treeCode;           // 树编码字段
    private String treeParentCode;     // 树父编码字段
    private String treeName;           // 树名称字段
    private Long parentMenuId;         // 上级菜单 ID
    private String parentMenuName;     // 上级菜单名称
}
```

### 3.2 GenTableColumn 实体

```java
public class GenTableColumn extends BaseEntity {
    private Long columnId;             // 编号
    private Long tableId;              // 归属表编号
    private String columnName;         // 列名称
    private String columnComment;      // 列描述
    private String columnType;         // 列类型
    private String javaType;           // JAVA 类型
    private String javaField;          // JAVA 字段名
    
    private String isPk;               // 是否主键
    private String isIncrement;        // 是否自增
    private String isRequired;         // 是否必填
    private String isInsert;           // 是否插入字段
    private String isEdit;             // 是否编辑字段
    private String isList;             // 是否列表字段
    private String isQuery;            // 是否查询字段
    
    private String queryType;          // 查询方式
    private String htmlType;           // 显示类型
    private String dictType;           // 字典类型
    private Integer sort;              // 排序
}
```

---

## 四、数据关系图

```
┌─────────────────────┐
│   gen_table         │
│─────────────────────│
│ PK table_id         │
│    table_name       │
│    class_name       │
│    tpl_category     │
│    tpl_web_type     │
│    package_name     │
│    module_name      │
│    business_name    │
│    function_name    │
│    function_author  │
│    gen_type         │
│    gen_path         │
│    options          │
└─────────┬───────────┘
          │ 1:N
          │
          ▼
┌─────────────────────┐
│ gen_table_column    │
│─────────────────────│
│ PK column_id        │
│ FK table_id         │
│    column_name      │
│    column_comment   │
│    column_type      │
│    java_type        │
│    java_field       │
│    is_pk            │
│    is_increment     │
│    is_required      │
│    is_insert        │
│    is_edit          │
│    is_list          │
│    is_query         │
│    query_type       │
│    html_type        │
│    dict_type        │
│    sort             │
└─────────────────────┘
```

---

## 五、模板选项配置

### 5.1 CRUD 单表模板

无需额外配置，使用默认配置即可。

### 5.2 树表模板

需要在 `options` 字段配置：
```json
{
  "treeCode": "parent_id",
  "treeName": "dept_name",
  "treeParentCode": "parent_id",
  "parentMenuId": "100"
}
```

### 5.3 主子表模板

需要在表配置中设置：
- `subTableName`: 子表表名
- `subTableFkName`: 子表关联的外键名

子表配置类似，但不需要重复配置 `options`。
