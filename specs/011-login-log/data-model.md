# 登录日志数据模型 (011-login-log)

**模块编号：** 011  
**最后更新：** 2026-03-12

---

## 一、数据库表结构

### 1.1 表名：`sys_logininfor`

系统访问记录表

```sql
CREATE TABLE sys_logininfor (
  info_id        BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '访问 ID',
  user_name      VARCHAR(50)   DEFAULT '' COMMENT '用户账号',
  status         CHAR(1)       DEFAULT '0' COMMENT '登录状态 0 成功 1 失败',
  ipaddr         VARCHAR(128)  DEFAULT '' COMMENT '登录 IP 地址',
  login_location VARCHAR(255)  DEFAULT '' COMMENT '登录地点',
  browser        VARCHAR(50)   DEFAULT '' COMMENT '浏览器',
  os             VARCHAR(50)   DEFAULT '' COMMENT '操作系统',
  msg            VARCHAR(255)  DEFAULT '' COMMENT '提示消息',
  login_time     DATETIME      DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (info_id),
  KEY idx_sys_logininfor_s (status),
  KEY idx_sys_logininfor_lt (login_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统访问记录';
```

---

## 二、字段详细说明

### 2.1 主键字段

| 字段名 | 类型 | 长度 | 必填 | 说明 |
|--------|------|------|------|------|
| info_id | BIGINT | 20 | 是 | 访问 ID，自增主键 |

### 2.2 业务字段

| 字段名 | 类型 | 长度 | 默认值 | 说明 |
|--------|------|------|--------|------|
| user_name | VARCHAR | 50 | '' | 用户账号 |
| status | CHAR | 1 | '0' | 登录状态（0 成功 1 失败） |
| ipaddr | VARCHAR | 128 | '' | 登录 IP 地址 |
| login_location | VARCHAR | 255 | '' | 登录地点（IP 解析） |
| browser | VARCHAR | 50 | '' | 浏览器类型 |
| os | VARCHAR | 50 | '' | 操作系统 |
| msg | VARCHAR | 255 | '' | 提示消息/错误信息 |
| login_time | DATETIME | - | NULL | 访问时间 |

---

## 三、Java 实体类

### 3.1 类名：`SysLogininfor`

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`

```java
public class SysLogininfor extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long infoId;

    /** 用户账号 */
    private String userName;

    /** 登录状态 0 成功 1 失败 */
    private String status;

    /** 登录 IP 地址 */
    private String ipaddr;

    /** 登录地点 */
    private String loginLocation;

    /** 浏览器类型 */
    private String browser;

    /** 操作系统 */
    private String os;

    /** 提示消息 */
    private String msg;

    /** 访问时间 */
    private Date loginTime;
    
    // getter/setter 方法...
}
```

---

## 四、数据字典

### 4.1 登录状态 (sys_common_status)

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 成功 | 登录成功 |
| 1 | 失败 | 登录失败 |

---

## 五、索引设计

### 5.1 现有索引

| 索引名 | 字段 | 类型 | 说明 |
|--------|------|------|------|
| PRIMARY | info_id | 主键索引 | 主键自增 |
| idx_sys_logininfor_s | status | 普通索引 | 按状态查询 |
| idx_sys_logininfor_lt | login_time | 普通索引 | 按时间排序/查询 |

### 5.2 索引建议

- `login_time` 字段作为主要查询条件
- 大数据量时可考虑按时间范围分区
- 可考虑添加 `user_name` 索引优化用户查询
- 可考虑添加 `ipaddr` 索引优化 IP 查询

---

## 六、数据关系

### 6.1 外键关系

本表为日志表，无外键关联，保持数据独立性。

### 6.2 关联查询

| 关联表 | 关联字段 | 关联方式 | 说明 |
|--------|----------|----------|------|
| sys_user | user_name | 左连接 | 查询用户详细信息 |

---

## 七、数据约束

### 7.1 长度约束

| 字段 | 最大长度 | 说明 |
|------|----------|------|
| user_name | 50 | 用户账号 |
| ipaddr | 128 | IP 地址（支持 IPv6） |
| login_location | 255 | 登录地点 |
| browser | 50 | 浏览器类型 |
| os | 50 | 操作系统 |
| msg | 255 | 提示消息 |

### 7.2 默认值

| 字段 | 默认值 | 说明 |
|------|--------|------|
| status | '0' | 默认为成功 |

---

## 八、MyBatis 映射

### 8.1 Mapper 接口

**接口路径：** `com.ruoyi.system.mapper.SysLogininforMapper`

```java
public interface SysLogininforMapper {
    // 新增系统登录日志
    void insertLogininfor(SysLogininfor logininfor);
    
    // 查询系统登录日志集合
    List<SysLogininfor> selectLogininforList(SysLogininfor logininfor);
    
    // 批量删除系统登录日志
    int deleteLogininforByIds(Long[] infoIds);
    
    // 清空系统登录日志
    void cleanLogininfor();
}
```

### 8.2 XML 映射

**文件路径：** `ruoyi-admin/src/main/resources/mybatis/system/SysLogininforMapper.xml`

主要 SQL 映射：
- `insertLogininfor` - 插入登录日志
- `selectLogininforList` - 条件查询列表
- `deleteLogininforByIds` - 批量删除
- `cleanLogininfor` - 清空表（TRUNCATE）

---

## 九、服务层接口

### 9.1 Service 接口

**接口路径：** `com.ruoyi.system.service.ISysLogininforService`

```java
public interface ISysLogininforService {
    // 新增系统登录日志
    void insertLogininfor(SysLogininfor logininfor);
    
    // 查询系统登录日志集合
    List<SysLogininfor> selectLogininforList(SysLogininfor logininfor);
    
    // 批量删除系统登录日志
    int deleteLogininforByIds(Long[] infoIds);
    
    // 清空系统登录日志
    void cleanLogininfor();
}
```

### 9.2 Service 实现

**实现路径：** `com.ruoyi.system.service.impl.SysLogininforServiceImpl`

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
