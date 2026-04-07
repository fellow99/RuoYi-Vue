# 008-Notice 通知公告模块数据模型

## 1. 数据表结构

### 1.1 sys_notice 通知公告表

| 字段名 | 类型 | 长度 | 允许 NULL | 默认值 | 说明 |
|--------|------|------|---------|--------|------|
| notice_id | BIGINT | 20 | 否 | 自增 | 公告 ID（PK） |
| notice_title | VARCHAR | 50 | 是 | '' | 公告标题 |
| notice_type | CHAR | 1 | 是 | '' | 公告类型（1 通知 2 公告） |
| notice_content | LONGTEXT | - | 是 | NULL | 公告内容（富文本） |
| status | CHAR | 1 | 是 | '0' | 公告状态（0 正常 1 关闭） |
| create_by | VARCHAR | 64 | 是 | '' | 创建者 |
| create_time | DATETIME | - | 是 | NULL | 创建时间 |
| update_by | VARCHAR | 64 | 是 | '' | 更新者 |
| update_time | DATETIME | - | 是 | NULL | 更新时间 |
| remark | VARCHAR | 500 | 是 | NULL | 备注 |

**索引：**
- PRIMARY KEY (notice_id)

**示例数据：**
```sql
insert into sys_notice values(1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', '新版本内容...', '0', 'admin', sysdate(), '', null, '管理员');
insert into sys_notice values(2, '维护通知：2018-07-01 若依系统凌晨维护', '1', '维护内容...', '0', 'admin', sysdate(), '', null, '管理员');
```

## 2. 实体类

### 2.1 SysNotice 实体类

**包路径：** `com.ruoyi.system.domain`

**继承：** `BaseEntity`

**属性：**
```java
public class SysNotice extends BaseEntity {
    private Long noticeId;          // 公告 ID
    private String noticeTitle;     // 公告标题
    private String noticeType;      // 公告类型（1 通知 2 公告）
    private String noticeContent;   // 公告内容
    private String status;          // 公告状态（0 正常 1 关闭）
    // 继承 BaseEntity 的 createBy, createTime, updateBy, updateTime, remark
}
```

**校验规则：**
- `noticeTitle`: @Xss, @NotBlank, @Size(min=0, max=50)
- `noticeType`: 无特殊校验
- `noticeContent`: 无特殊校验
- `status`: 无特殊校验

**XSS 防护：**
```java
@Xss(message = "公告标题不能包含脚本字符")
public String getNoticeTitle() {
    return noticeTitle;
}
```

**方法：**
```java
// toString 方法包含所有字段
public String toString() {
    return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
        .append("noticeId", getNoticeId())
        .append("noticeTitle", getNoticeTitle())
        .append("noticeType", getNoticeType())
        .append("noticeContent", getNoticeContent())
        .append("status", getStatus())
        .append("createBy", getCreateBy())
        .append("createTime", getCreateTime())
        .append("updateBy", getUpdateBy())
        .append("updateTime", getUpdateTime())
        .append("remark", getRemark())
        .toString();
}
```

## 3. 服务层方法

### 3.1 ISysNoticeService 接口

```java
public interface ISysNoticeService {
    // 查询公告信息
    SysNotice selectNoticeById(Long noticeId);
    
    // 查询公告列表
    List<SysNotice> selectNoticeList(SysNotice notice);
    
    // 新增公告
    int insertNotice(SysNotice notice);
    
    // 修改公告
    int updateNotice(SysNotice notice);
    
    // 删除公告
    int deleteNoticeByIds(Long[] noticeIds);
}
```

## 4. 数据关系

### 4.1 关联字典
- 公告类型：sys_notice_type（1 通知 2 公告）
- 公告状态：sys_notice_status（0 正常 1 关闭）

### 4.2 字典数据示例
```sql
-- 公告类型
insert into sys_dict_data values(14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', sysdate(), '', null, '通知');
insert into sys_dict_data values(15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', sysdate(), '', null, '公告');

-- 公告状态
insert into sys_dict_data values(16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', sysdate(), '', null, '正常状态');
insert into sys_dict_data values(17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', sysdate(), '', null, '关闭状态');
```

## 5. 数据权限

- 通知公告为系统公共数据
- 所有用户均可查询通知公告列表和详情
- 仅授权用户可进行增删改操作

## 6. 数据初始化

系统初始化时预置以下通知公告：

| notice_id | notice_title | notice_type | notice_content | status |
|-----------|--------------|-------------|----------------|--------|
| 1 | 温馨提醒：2018-07-01 若依新版本发布啦 | 2 (公告) | 新版本内容... | 0 (正常) |
| 2 | 维护通知：2018-07-01 若依系统凌晨维护 | 1 (通知) | 维护内容... | 0 (正常) |

## 7. 富文本内容

### 7.1 内容格式
- 公告内容使用 HTML 格式存储
- 支持常见的富文本格式：标题、段落、列表、表格、图片等
- 内容长度理论上无限制（LONGTEXT）

### 7.2 内容安全
- 前端富文本编辑器需要进行 XSS 过滤
- 后端 `@Xss` 注解对标题进行过滤
- 建议对内容也进行 XSS 过滤处理

## 8. 业务逻辑

### 8.1 查询公告列表
1. 支持按标题模糊查询
2. 支持按类型筛选
3. 支持按状态筛选
4. 支持分页查询

### 8.2 新增公告
1. 校验标题非空且长度不超过 50
2. 对标题进行 XSS 过滤
3. 设置创建人为当前用户
4. 设置创建时间为当前时间
5. 插入数据库

### 8.3 修改公告
1. 校验标题非空且长度不超过 50
2. 对标题进行 XSS 过滤
3. 设置更新人为当前用户
4. 设置更新时间为当前时间
5. 更新数据库

### 8.4 删除公告
1. 支持批量删除
2. 直接删除数据库记录
