# 定时任务数据模型 (013-job)

**模块编号：** 013  
**最后更新：** 2026-03-12

---

## 一、数据库表结构

### 1.1 表名：`sys_job`

定时任务调度表

```sql
CREATE TABLE sys_job (
  job_id          BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '任务 ID',
  job_name        VARCHAR(64)   DEFAULT '' COMMENT '任务名称',
  job_group       VARCHAR(64)   DEFAULT 'DEFAULT' COMMENT '任务组名',
  invoke_target   VARCHAR(500)  DEFAULT '' COMMENT '调用目标字符串',
  cron_expression VARCHAR(255)  DEFAULT '' COMMENT 'cron 执行表达式',
  misfire_policy  VARCHAR(20)   DEFAULT '3' COMMENT '计划策略（1 立即 2 执行一次 3 放弃）',
  concurrent      CHAR(1)       DEFAULT '1' COMMENT '是否并发（0 允许 1 禁止）',
  status          CHAR(1)       DEFAULT '0' COMMENT '任务状态（0 正常 1 暂停）',
  create_by       VARCHAR(64)   DEFAULT '' COMMENT '创建者',
  create_time     DATETIME      DEFAULT NULL COMMENT '创建时间',
  update_by       VARCHAR(64)   DEFAULT '' COMMENT '更新者',
  update_time     DATETIME      DEFAULT NULL COMMENT '更新时间',
  remark          VARCHAR(500)  DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (job_id, job_name, job_group)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='定时任务调度表';
```

### 1.2 表名：`sys_job_log`

定时任务调度日志表

```sql
CREATE TABLE sys_job_log (
  job_log_id     BIGINT(20)   NOT NULL AUTO_INCREMENT COMMENT '任务日志 ID',
  job_name       VARCHAR(64)   DEFAULT '' COMMENT '任务名称',
  job_group      VARCHAR(64)   DEFAULT '' COMMENT '任务组名',
  invoke_target  VARCHAR(500)  DEFAULT '' COMMENT '调用目标字符串',
  job_message    VARCHAR(500)  DEFAULT '' COMMENT '日志信息',
  status         CHAR(1)       DEFAULT '0' COMMENT '执行状态（0 正常 1 失败）',
  exception_info VARCHAR(2000) DEFAULT '' COMMENT '异常信息',
  start_time     DATETIME      DEFAULT NULL COMMENT '开始时间',
  stop_time      DATETIME      DEFAULT NULL COMMENT '停止时间',
  create_time    DATETIME      DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (job_log_id),
  KEY idx_sys_job_log_s (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='定时任务调度日志表';
```

---

## 二、Java 实体类

### 2.1 任务类：`SysJob`

**包路径：** `com.ruoyi.quartz.domain`

**继承：** `BaseEntity`

```java
public class SysJob extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 任务 ID */
    private Long jobId;

    /** 任务名称 */
    private String jobName;

    /** 任务组名 */
    private String jobGroup;

    /** 调用目标字符串 */
    private String invokeTarget;

    /** cron 执行表达式 */
    private String cronExpression;

    /** cron 计划策略 */
    private String misfirePolicy = ScheduleConstants.MISFIRE_DEFAULT;

    /** 是否并发执行（0 允许 1 禁止） */
    private String concurrent;

    /** 任务状态（0 正常 1 暂停） */
    private String status;
    
    // getter/setter 方法...
    
    /**
     * 下次执行时间（计算字段）
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getNextValidTime() {
        if (StringUtils.isNotEmpty(cronExpression)) {
            return CronUtils.getNextExecution(cronExpression);
        }
        return null;
    }
}
```

### 2.2 任务日志类：`SysJobLog`

**包路径：** `com.ruoyi.quartz.domain`

**继承：** `BaseEntity`

```java
public class SysJobLog extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** ID */
    private Long jobLogId;

    /** 任务名称 */
    private String jobName;

    /** 任务组名 */
    private String jobGroup;

    /** 调用目标字符串 */
    private String invokeTarget;

    /** 日志信息 */
    private String jobMessage;

    /** 执行状态（0 正常 1 失败） */
    private String status;

    /** 异常信息 */
    private String exceptionInfo;

    /** 开始时间 */
    private Date startTime;

    /** 停止时间 */
    private Date stopTime;
    
    // getter/setter 方法...
}
```

---

## 三、字段详细说明

### 3.1 sys_job 字段

| 字段名 | 类型 | 长度 | 默认值 | 说明 |
|--------|------|------|--------|------|
| job_id | BIGINT | 20 | - | 任务 ID，自增主键 |
| job_name | VARCHAR | 64 | '' | 任务名称 |
| job_group | VARCHAR | 64 | 'DEFAULT' | 任务组名 |
| invoke_target | VARCHAR | 500 | '' | 调用目标字符串 |
| cron_expression | VARCHAR | 255 | '' | Cron 表达式 |
| misfire_policy | VARCHAR | 20 | '3' | 错过执行策略 |
| concurrent | CHAR | 1 | '1' | 并发策略 |
| status | CHAR | 1 | '0' | 任务状态 |
| create_by | VARCHAR | 64 | '' | 创建者 |
| create_time | DATETIME | - | NULL | 创建时间 |
| update_by | VARCHAR | 64 | '' | 更新者 |
| update_time | DATETIME | - | NULL | 更新时间 |
| remark | VARCHAR | 500 | '' | 备注 |

### 3.2 sys_job_log 字段

| 字段名 | 类型 | 长度 | 默认值 | 说明 |
|--------|------|------|--------|------|
| job_log_id | BIGINT | 20 | - | 日志 ID，自增主键 |
| job_name | VARCHAR | 64 | '' | 任务名称 |
| job_group | VARCHAR | 64 | '' | 任务组名 |
| invoke_target | VARCHAR | 500 | '' | 调用目标 |
| job_message | VARCHAR | 500 | '' | 日志信息 |
| status | CHAR | 1 | '0' | 执行状态 |
| exception_info | VARCHAR | 2000 | '' | 异常信息 |
| start_time | DATETIME | - | NULL | 开始时间 |
| stop_time | DATETIME | - | NULL | 停止时间 |
| create_time | DATETIME | - | NULL | 创建时间 |

---

## 四、数据字典

### 4.1 任务组名 (sys_job_group)

| 值 | 标签 | 说明 |
|----|------|------|
| DEFAULT | 默认组 | 系统默认组 |
| SYSTEM | 系统组 | 系统任务组 |

### 4.2 任务状态 (sys_job_status)

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 正常 | 任务正常执行 |
| 1 | 暂停 | 任务暂停 |

### 4.3 执行状态

| 值 | 标签 | 说明 |
|----|------|------|
| 0 | 正常 | 执行成功 |
| 1 | 失败 | 执行失败 |

---

## 五、MyBatis 映射

### 5.1 Mapper 接口

**接口路径：** `com.ruoyi.quartz.mapper.SysJobMapper`

```java
public interface SysJobMapper {
    // 查询定时任务列表
    List<SysJob> selectJobList(SysJob job);
    
    // 查询所有定时任务
    List<SysJob> selectJobAll();
    
    // 查询定时任务详细
    SysJob selectJobById(Long jobId);
    
    // 删除定时任务
    int deleteJobById(Long jobId);
    
    // 批量删除定时任务
    int deleteJobByIds(Long[] jobIds);
    
    // 更新定时任务
    int updateJob(SysJob job);
    
    // 新增定时任务
    int insertJob(SysJob job);
}
```

### 5.2 日志 Mapper 接口

**接口路径：** `com.ruoyi.quartz.mapper.SysJobLogMapper`

```java
public interface SysJobLogMapper {
    // 新增任务日志
    void insertJobLog(SysJobLog jobLog);
    
    // 查询任务日志列表
    List<SysJobLog> selectJobLogList(SysJobLog jobLog);
    
    // 批量删除任务日志
    int deleteJobLogByIds(Long[] jobLogIds);
    
    // 清空任务日志
    void cleanJobLog();
}
```

---

## 六、服务层接口

### 6.1 任务 Service

**接口路径：** `com.ruoyi.quartz.service.ISysJobService`

```java
public interface ISysJobService {
    // 查询定时任务列表
    List<SysJob> selectJobList(SysJob job);
    
    // 查询定时任务详细
    SysJob selectJobById(Long jobId);
    
    // 新增任务
    int insertJob(SysJob job);
    
    // 更新任务
    int updateJob(SysJob job);
    
    // 删除任务
    int deleteJob(SysJob job);
    
    // 批量删除任务
    void deleteJobByIds(Long[] jobIds);
    
    // 任务状态变更
    int changeStatus(SysJob job);
    
    // 立即执行一次
    boolean run(SysJob job);
    
    // 校验 Cron 表达式
    boolean checkCronExpressionIsValid(String cronExpression);
}
```

---

## 七、Quartz 集成

### 7.1 调度器配置

**配置类：** `com.ruoyi.quartz.config.ScheduleConfig`

```java
@Configuration
public class ScheduleConfig {
    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();
        // 配置数据源等
        return factory;
    }
}
```

### 7.2 任务执行类

**抽象类：** `com.ruoyi.quartz.util.AbstractQuartzJob`

```java
public abstract class AbstractQuartzJob implements Job {
    @Override
    public void execute(JobExecutionContext context) {
        // 执行任务逻辑
    }
}
```

### 7.3 调度工具类

**工具类：** `com.ruoyi.quartz.util.ScheduleUtils`

主要方法：
- `createScheduleJob` - 创建任务
- `getJobKey` - 获取 JobKey
- `whiteList` - 白名单校验

---

**文档版本：** 1.0  
**创建日期：** 2026-03-12
