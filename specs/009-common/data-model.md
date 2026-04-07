# 009-Common 公共模块数据模型

## 1. 数据表结构

### 1.1 sys_oper_log 操作日志记录表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| oper_id | BIGINT | 20 | 否 | 自增 | 日志主键（PK） |
| title | VARCHAR | 50 | 是 | '' | 模块标题 |
| business_type | INT | 2 | 是 | 0 | 业务类型（0 其它 1 新增 2 修改 3 删除） |
| method | VARCHAR | 200 | 是 | '' | 方法名称 |
| request_method | VARCHAR | 10 | 是 | '' | 请求方式（GET/POST/PUT/DELETE） |
| operator_type | INT | 1 | 是 | 0 | 操作类别（0 其它 1 后台用户 2 手机端用户） |
| oper_name | VARCHAR | 50 | 是 | '' | 操作人员 |
| dept_name | VARCHAR | 50 | 是 | '' | 部门名称 |
| oper_url | VARCHAR | 255 | 是 | '' | 请求 URL |
| oper_ip | VARCHAR | 128 | 是 | '' | 主机地址 |
| oper_location | VARCHAR | 255 | 是 | '' | 操作地点 |
| oper_param | VARCHAR | 2000 | 是 | '' | 请求参数 |
| json_result | VARCHAR | 2000 | 是 | '' | 返回参数 |
| status | INT | 1 | 是 | 0 | 操作状态（0 正常 1 异常） |
| error_msg | VARCHAR | 2000 | 是 | '' | 错误消息 |
| oper_time | DATETIME | - | 是 | NULL | 操作时间 |
| cost_time | BIGINT | 20 | 是 | 0 | 消耗时间（毫秒） |

**索引：**
- PRIMARY KEY (oper_id)
- KEY idx_sys_oper_log_bt (business_type)
- KEY idx_sys_oper_log_s (status)
- KEY idx_sys_oper_log_ot (oper_time)

**示例数据：**
```sql
insert into sys_oper_log values(1, '用户管理', 1, 'com.ruoyi.web.controller.system.SysUserController.add()', 'POST', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网 IP', '{"id":1,"name":"test"}', '{}', 0, '', sysdate(), 10);
```

### 1.2 sys_logininfor 系统访问记录表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| info_id | BIGINT | 20 | 否 | 自增 | 访问 ID（PK） |
| user_name | VARCHAR | 50 | 是 | '' | 用户账号 |
| ipaddr | VARCHAR | 128 | 是 | '' | 登录 IP 地址 |
| login_location | VARCHAR | 255 | 是 | '' | 登录地点 |
| browser | VARCHAR | 50 | 是 | '' | 浏览器类型 |
| os | VARCHAR | 50 | 是 | '' | 操作系统 |
| status | CHAR | 1 | 是 | '0' | 登录状态（0 成功 1 失败） |
| msg | VARCHAR | 255 | 是 | '' | 提示消息 |
| login_time | DATETIME | - | 是 | NULL | 访问时间 |

**索引：**
- PRIMARY KEY (info_id)
- KEY idx_sys_logininfor_s (status)
- KEY idx_sys_logininfor_lt (login_time)

**示例数据：**
```sql
insert into sys_logininfor values(1, 'admin', '127.0.0.1', '内网 IP', 'Chrome', 'Windows', '0', '登录成功', sysdate());
insert into sys_logininfor values(2, 'test', '192.168.1.100', 'XX XX 省 XX 市', 'Firefox', 'Windows', '1', '密码错误', sysdate());
```

## 2. 实体类

### 2.1 SysOperLog 实体类

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`（仅继承部分字段，operTime 单独定义）

**属性：**
```java
public class SysOperLog extends BaseEntity {
    private Long operId;            // 日志主键
    private String title;           // 模块标题
    private Integer businessType;   // 业务类型
    private Integer[] businessTypes; // 业务类型数组（用于查询）
    private String method;          // 方法名称
    private String requestMethod;   // 请求方式
    private Integer operatorType;   // 操作类别
    private String operName;        // 操作人员
    private String deptName;        // 部门名称
    private String operUrl;         // 请求 URL
    private String operIp;          // 操作 IP
    private String operLocation;    // 操作地点
    private String operParam;       // 请求参数
    private String jsonResult;      // 返回参数
    private Integer status;         // 操作状态
    private String errorMsg;        // 错误消息
    private Date operTime;          // 操作时间
    private Long costTime;          // 消耗时间
}
```

**注意：** SysOperLog 不继承 BaseEntity 的 createTime，而是使用 operTime

### 2.2 SysLogininfor 实体类

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`（仅继承部分字段，loginTime 单独定义）

**属性：**
```java
public class SysLogininfor extends BaseEntity {
    private Long infoId;            // 访问 ID
    private String userName;        // 用户账号
    private String status;          // 登录状态
    private String ipaddr;          // 登录 IP 地址
    private String loginLocation;   // 登录地点
    private String browser;         // 浏览器类型
    private String os;              // 操作系统
    private String msg;             // 提示消息
    private Date loginTime;         // 访问时间
}
```

**注意：** SysLogininfor 不继承 BaseEntity 的 createTime，而是使用 loginTime

## 3. 服务层方法

### 3.1 ISysOperLogService 接口

```java
public interface ISysOperLogService {
    // 查询操作日志列表
    List<SysOperLog> selectOperLogList(SysOperLog operLog);
    
    // 批量删除操作日志
    int deleteOperLogByIds(Long[] operIds);
    
    // 清空操作日志
    void cleanOperLog();
}
```

### 3.2 ISysLogininforService 接口

```java
public interface ISysLogininforService {
    // 查询登录日志列表
    List<SysLogininfor> selectLogininforList(SysLogininfor logininfor);
    
    // 批量删除登录日志
    int deleteLogininforByIds(Long[] infoIds);
    
    // 清空登录日志
    void cleanLogininfor();
}
```

## 4. 数据关系

### 4.1 操作日志业务类型字典
- 字典类型：sys_oper_type
- 业务类型映射：
  - 0 - 其它
  - 1 - 新增
  - 2 - 修改
  - 3 - 删除
  - 4 - 授权
  - 5 - 导出
  - 6 - 导入
  - 7 - 强退
  - 8 - 生成代码
  - 9 - 清空数据

### 4.2 登录日志状态字典
- 字典类型：sys_common_status
- 状态映射：
  - 0 - 成功
  - 1 - 失败

## 5. 数据权限

- 日志数据为系统监控数据
- 查询日志需要相应权限
- 日志数据不支持修改，保证数据真实性
- 删除和清空操作需要高级权限

## 6. 数据初始化

### 6.1 操作类型字典数据
```sql
insert into sys_dict_data values(18, 1, '新增',     '1',       'sys_oper_type',     '',   'info',    'N', '0', 'admin', sysdate(), '', null, '新增操作');
insert into sys_dict_data values(19, 2, '修改',     '2',       'sys_oper_type',     '',   'info',    'N', '0', 'admin', sysdate(), '', null, '修改操作');
insert into sys_dict_data values(20, 3, '删除',     '3',       'sys_oper_type',     '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '删除操作');
insert into sys_dict_data values(21, 4, '授权',     '4',       'sys_oper_type',     '',   'primary', 'N', '0', 'admin', sysdate(), '', null, '授权操作');
insert into sys_dict_data values(22, 5, '导出',     '5',       'sys_oper_type',     '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导出操作');
insert into sys_dict_data values(23, 6, '导入',     '6',       'sys_oper_type',     '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '导入操作');
insert into sys_dict_data values(24, 7, '强退',     '7',       'sys_oper_type',     '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '强退操作');
insert into sys_dict_data values(25, 8, '生成代码', '8',       'sys_oper_type',     '',   'warning', 'N', '0', 'admin', sysdate(), '', null, '生成操作');
insert into sys_dict_data values(26, 9, '清空数据', '9',       'sys_oper_type',     '',   'danger',  'N', '0', 'admin', sysdate(), '', null, '清空操作');
```

## 7. 日志记录机制

### 7.1 AOP 切面记录
- 使用@Log 注解标记需要记录的操作
- AOP 切面拦截带有@Log 注解的方法
- 异步记录日志，不影响业务性能

### 7.2 日志注解
```java
@Log(title = "用户管理", businessType = BusinessType.INSERT)
@PostMapping
public AjaxResult add(@Validated @RequestBody SysUser user)
{
    // 业务逻辑
}
```

## 8. 在线用户数据

### 8.1 存储方式
- 在线用户信息存储在 Redis 中
- Key 格式：`online_tokens:{token}`
- Value：用户会话信息（JSON 格式）

### 8.2 数据结构
```json
{
  "tokenId": "uuid",
  "user": {
    "userId": 1,
    "userName": "admin",
    "deptName": "研发部门"
  },
  "ipaddr": "127.0.0.1",
  "loginTime": 1234567890000,
  "expireTime": 1234597890000
}
```
