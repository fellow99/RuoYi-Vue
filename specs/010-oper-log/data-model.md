# 操作日志数据模型 (010-oper-log)

**模块编号：** 010  
**最后更新：** 2026-03-12

---

## 一、数据库表结构

### 1.1 表名：`sys_oper_log`

操作日志记录表

```sql
CREATE TABLE sys_oper_log (
  oper_id        BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  title          VARCHAR(50)   DEFAULT '' COMMENT '操作模块',
  business_type  INT(2)        DEFAULT 0 COMMENT '业务类型（0 其它 1 新增 2 修改 3 删除）',
  method         VARCHAR(100)  DEFAULT '' COMMENT '方法名称',
  request_method VARCHAR(10)   DEFAULT '' COMMENT '请求方式',
  operator_type  INT(1)        DEFAULT 0 COMMENT '操作类别（0 其它 1 后台用户 2 手机端用户）',
  oper_name      VARCHAR(50)   DEFAULT '' COMMENT '操作人员',
  dept_name      VARCHAR(50)   DEFAULT '' COMMENT '部门名称',
  oper_url       VARCHAR(255)  DEFAULT '' COMMENT '请求 URL',
  oper_ip        VARCHAR(128)  DEFAULT '' COMMENT '主机地址',
  oper_location  VARCHAR(255)  DEFAULT '' COMMENT '操作地点',
  oper_param     VARCHAR(2000) DEFAULT '' COMMENT '请求参数',
  json_result    VARCHAR(2000) DEFAULT '' COMMENT '返回参数',
  status         INT(1)        DEFAULT 0 COMMENT '操作状态（0 正常 1 异常）',
  error_msg      VARCHAR(2000) DEFAULT '' COMMENT '错误消息',
  oper_time      DATETIME      DEFAULT NULL COMMENT '操作时间',
  cost_time      BIGINT(20)    DEFAULT 0 COMMENT '消耗时间（毫秒）',
  PRIMARY KEY (oper_id),
  KEY idx_sys_oper_log_bt (business_type),
  KEY idx_sys_oper_log_s (status),
  KEY idx_sys_oper_log_ot (oper_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志记录';
```

---

## 二、字段详细说明

### 2.1 主键字段

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| oper_id | BIGINT | 20 | 是 | 日志主键，自增 |

### 2.2 业务字段

| 字段名 | 类型 | 长度 | 默认值 | 说明 |
|--------|------|------|--------|------|
| title | VARCHAR | 50 | '' | 操作模块/业务标题 |
| business_type | INT | 2 | 0 | 业务类型（见枚举） |
| method | VARCHAR | 100 | '' | 方法名称（类名。方法名） |
| request_method | VARCHAR | 10 | '' | 请求方式（GET/POST/PUT/DELETE） |
| operator_type | INT | 1 | 0 | 操作类别（WEB/MOBILE） |
| oper_name | VARCHAR | 50 | '' | 操作人员姓名 |
| dept_name | VARCHAR | 50 | '' | 部门名称 |
| oper_url | VARCHAR | 255 | '' | 请求的 URL 地址 |
| oper_ip | VARCHAR | 128 | '' | 操作 IP 地址 |
| oper_location | VARCHAR | 255 | '' | 操作地点（IP 解析） |
| oper_param | VARCHAR | 2000 | '' | 请求参数（JSON） |
| json_result | VARCHAR | 2000 | '' | 返回结果（JSON） |
| status | INT | 1 | 0 | 操作状态（0 成功 1 失败） |
| error_msg | VARCHAR | 2000 | '' | 错误消息（失败时） |
| oper_time | DATETIME | - | NULL | 操作时间 |
| cost_time | BIGINT | 20 | 0 | 消耗时间（毫秒） |

---

## 三、Java 实体类

### 3.1 类名：`SysOperLog`

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`

```java
public class SysOperLog extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 日志主键 */
    private Long operId;

    /** 操作模块 */
    private String title;

    /** 业务类型（0 其它 1 新增 2 修改 3 删除） */
    private Integer businessType;

    /** 业务类型数组（用于多条件查询） */
    private Integer[] businessTypes;

    /** 请求方法 */
    private String method;

    /** 请求方式 */
    private String requestMethod;

    /** 操作类别（0 其它 1 后台用户 2 手机端用户） */
    private Integer operatorType;

    /** 操作人员 */
    private String operName;

    /** 部门名称 */
    private String deptName;

    /** 请求 url */
    private String operUrl;

    /** 操作地址 */
    private String operIp;

    /** 操作地点 */
    private String operLocation;

    /** 请求参数 */
    private String operParam;

    /** 返回参数 */
    private String jsonResult;

    /** 操作状态（0 正常 1 异常） */
    private Integer status;

    /** 错误消息 */
    private String errorMsg;

    /** 操作时间 */
    private Date operTime;

    /** 消耗时间 */
    private Long costTime;
    
    // getter/setter 方法...
}
```

---

## 四、数据字典

### 4.1 业务类型 (sys_oper_type)

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 其他 | 其他操作 |
| 1 | 新增 | 新增数据操作 |
| 2 | 修改 | 修改数据操作 |
| 3 | 删除 | 删除数据操作 |
| 4 | 授权 | 权限分配操作 |
| 5 | 导出 | 数据导出操作 |
| 6 | 导入 | 数据导入操作 |
| 7 | 强退 | 强制退出操作 |
| 8 | 生成代码 | 代码生成操作 |
| 9 | 清空数据 | 清空数据操作 |

### 4.2 操作类别

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 其他 | 其他类别 |
| 1 | 后台用户 | Web 后台用户操作 |
| 2 | 手机端用户 | 移动端用户操作 |

### 4.3 操作状态 (sys_common_status)

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 成功 | 操作成功 |
| 1 | 失败 | 操作失败 |

---

## 五、索引设计

### 5.1 现有索引

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| PRIMARY | oper_id | 主键索引 | 主键自增 |
| idx_sys_oper_log_bt | business_type | 普通索引 | 按业务类型查询 |
| idx_sys_oper_log_s | status | 普通索引 | 按状态查询 |
| idx_sys_oper_log_ot | oper_time | 普通索引 | 按时间排序/查询 |

### 5.2 索引建议

- `oper_time` 字段建议作为主要查询条件
- 大数据量时可考虑按时间范围分区
- 可考虑添加 `oper_name` 索引优化人员查询

---

## 六、数据关系

### 6.1 外键关系

本表为日志表，无外键关联，保持数据独立性。

### 6.2 关联查询

| 关联表 | 关联字段 | 关联方式 | 说明 |
|--------|----------|----------|------|
| sys_user | oper_name | 左连接 | 查询用户详细信息 |
| sys_dept | dept_name | 左连接 | 查询部门详细信息 |

---

## 七、数据约束

### 7.1 长度约束

| 字段 | 最大长度 | 说明 |
|------|----------|------|
| title | 50 | 操作模块名称 |
| method | 100 | 方法名称 |
| oper_url | 255 | URL 地址 |
| oper_param | 2000 | 请求参数（超出截断） |
| json_result | 2000 | 返回结果（超出截断） |
| error_msg | 2000 | 错误消息（超出截断） |

### 7.2 默认值

| 字段 | 默认值 | 说明 |
|------|--------|------|
| business_type | 0 | 默认为其他 |
| operator_type | 0 | 默认为其他 |
| status | 0 | 默认为成功 |
| cost_time | 0 | 默认 0 毫秒 |

---

## 八、MyBatis 映射

### 8.1 Mapper 接口

**接口路径：** `com.ruoyi.system.mapper.SysOperLogMapper`

```java
public interface SysOperLogMapper {
    // 新增操作日志
    void insertOperlog(SysOperLog operLog);
    
    // 查询操作日志列表
    List<SysOperLog> selectOperLogList(SysOperLog operLog);
    
    // 查询操作日志详细
    SysOperLog selectOperLogById(Long operId);
    
    // 批量删除操作日志
    int deleteOperLogByIds(Long[] operIds);
    
    // 清空操作日志
    void cleanOperLog();
}
```

### 8.2 XML 映射

**文件路径：** `ruoyi-admin/src/main/resources/mybatis/system/SysOperLogMapper.xml`

主要 SQL 映射：
- `insertOperlog` - 插入日志记录
- `selectOperLogList` - 条件查询列表
- `selectOperLogById` - 按 ID 查询
- `deleteOperLogByIds` - 批量删除
- `cleanOperLog` - 清空表（TRUNCATE）

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
