# 007-Config 参数管理模块数据模型

## 1. 数据表结构

### 1.1 sys_config 参数配置表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| config_id | INT | 5 | 否 | 自增 | 参数主键（PK） |
| config_name | VARCHAR | 100 | 是 | '' | 参数名称 |
| config_key | VARCHAR | 100 | 是 | '' | 参数键名 |
| config_value | VARCHAR | 500 | 是 | '' | 参数键值 |
| config_type | CHAR | 1 | 是 | 'N' | 系统内置（Y 是 N 否） |
| create_by | VARCHAR | 64 | 是 | '' | 创建者 |
| create_time | DATETIME | - | 是 | NULL | 创建时间 |
| update_by | VARCHAR | 64 | 是 | '' | 更新者 |
| update_time | DATETIME | - | 是 | NULL | 更新时间 |
| remark | VARCHAR | 500 | 是 | NULL | 备注 |

**索引：**
- PRIMARY KEY (config_id)

**示例数据：**
```sql
insert into sys_config values(1, '主框架页 - 默认皮肤样式名称',     'sys.index.skinName',               'skin-blue',     'Y', 'admin', sysdate(), '', null, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow' );
insert into sys_config values(2, '用户管理 - 账号初始密码',         'sys.user.initPassword',            '123456',        'Y', 'admin', sysdate(), '', null, '初始化密码 123456' );
insert into sys_config values(3, '主框架页 - 侧边栏主题',           'sys.index.sideTheme',              'theme-dark',    'Y', 'admin', sysdate(), '', null, '深色主题 theme-dark，浅色主题 theme-light' );
insert into sys_config values(4, '账号自助 - 验证码开关',           'sys.account.captchaEnabled',       'true',          'Y', 'admin', sysdate(), '', null, '是否开启验证码功能（true 开启，false 关闭）');
insert into sys_config values(5, '账号自助 - 是否开启用户注册功能', 'sys.account.registerUser',         'false',         'Y', 'admin', sysdate(), '', null, '是否开启注册用户功能（true 开启，false 关闭）');
insert into sys_config values(6, '用户登录 - 黑名单列表',           'sys.login.blackIPList',            '',              'Y', 'admin', sysdate(), '', null, '设置登录 IP 黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
```

## 2. 实体类

### 2.1 SysConfig 实体类

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`

**属性：**
```java
public class SysConfig extends BaseEntity {
    private Long configId;        // 参数主键
    private String configName;    // 参数名称
    private String configKey;     // 参数键名
    private String configValue;   // 参数键值
    private String configType;    // 系统内置（Y 是 N 否）
    // 继承 BaseEntity 的 createBy, createTime, updateBy, updateTime, remark
}
```

**校验规则：**
- `configName`: @NotBlank, @Size(min=0, max=100)
- `configKey`: @NotBlank, @Size(min=0, max=100)
- `configValue`: @NotBlank, @Size(min=0, max=500)
- `configType`: 无特殊校验

**方法：**
```java
// toString 方法包含所有字段
public String toString() {
    return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
        .append("configId", getConfigId())
        .append("configName", getConfigName())
        .append("configKey", getConfigKey())
        .append("configValue", getConfigValue())
        .append("configType", getConfigType())
        .append("createBy", getCreateBy())
        .append("createTime", getCreateTime())
        .append("updateBy", getUpdateBy())
        .append("updateTime", getUpdateTime())
        .append("remark", getRemark())
        .toString();
}
```

## 3. 缓存设计

### 3.1 缓存键格式
- 参数配置缓存键：`sys_config:{configKey}`
- 示例：`sys_config:sys.account.captchaEnabled`

### 3.2 缓存内容
- 缓存值为 `String` 类型，即参数的键值（configValue）
- 所有参数配置都会缓存

### 3.3 缓存策略
- 系统启动时自动加载所有参数配置到缓存（@PostConstruct init()）
- 新增参数时自动添加到缓存
- 修改参数时：
  - 如果键名变更，删除旧键名的缓存
  - 添加新键名的缓存
- 删除参数时自动删除对应缓存
- 支持手动刷新缓存（清空后重新加载）

### 3.4 缓存操作方法
```java
// 加载参数缓存数据
loadingConfigCache()

// 清空参数缓存数据
clearConfigCache()

// 重置参数缓存数据
resetConfigCache()

// 获取缓存键
getCacheKey(String configKey) -> "sys_config:" + configKey
```

## 4. 数据权限

- 参数配置为系统基础数据
- 查询参数值接口无权限限制（供系统内部使用）
- 增删改操作需要相应权限
- 内置参数（configType='Y'）不能删除

## 5. 数据初始化

系统初始化时预置以下参数配置：

| config_id | config_name | config_key | config_value | config_type |
|-----------|-------------|------------|--------------|-------------|
| 1 | 主框架页 - 默认皮肤样式名称 | sys.index.skinName | skin-blue | Y |
| 2 | 用户管理 - 账号初始密码 | sys.user.initPassword | 123456 | Y |
| 3 | 主框架页 - 侧边栏主题 | sys.index.sideTheme | theme-dark | Y |
| 4 | 账号自助 - 验证码开关 | sys.account.captchaEnabled | true | Y |
| 5 | 账号自助 - 是否开启用户注册功能 | sys.account.registerUser | false | Y |
| 6 | 用户登录 - 黑名单列表 | sys.login.blackIPList | (空) | Y |
| 7 | 用户管理 - 初始密码修改策略 | sys.account.initPasswordModify | 1 | Y |
| 8 | 用户管理 - 账号密码更新周期 | sys.account.passwordValidateDays | 0 | Y |

## 6. 服务层方法

### 6.1 ISysConfigService 接口

```java
public interface ISysConfigService {
    // 查询参数配置信息
    SysConfig selectConfigById(Long configId);
    
    // 根据键名查询参数配置信息
    String selectConfigByKey(String configKey);
    
    // 获取验证码开关
    boolean selectCaptchaEnabled();
    
    // 查询参数配置列表
    List<SysConfig> selectConfigList(SysConfig config);
    
    // 新增参数配置
    int insertConfig(SysConfig config);
    
    // 修改参数配置
    int updateConfig(SysConfig config);
    
    // 批量删除参数信息
    void deleteConfigByIds(Long[] configIds);
    
    // 加载参数缓存数据
    void loadingConfigCache();
    
    // 清空参数缓存数据
    void clearConfigCache();
    
    // 重置参数缓存数据
    void resetConfigCache();
    
    // 校验参数键名是否唯一
    boolean checkConfigKeyUnique(SysConfig config);
}
```

## 7. 业务逻辑

### 7.1 查询参数值流程
1. 首先从 Redis 缓存中获取
2. 如果缓存不存在，从数据库查询
3. 查询成功后写入缓存
4. 返回参数值

### 7.2 删除参数流程
1. 检查参数是否为内置参数（configType='Y'）
2. 如果是内置参数，抛出异常提示不能删除
3. 删除数据库记录
4. 删除缓存

### 7.3 修改参数流程
1. 校验参数键名唯一性
2. 检查键名是否变更
3. 如果键名变更，删除旧缓存
4. 更新数据库
5. 更新缓存
