-- ----------------------------
-- 数据库拓展整理脚本
-- ----------------------------

-- ----------------------------
-- 关闭验证码
-- ----------------------------
UPDATE sys_config SET config_value='false' 
WHERE config_key='sys.account.captchaEnabled';

-- ----------------------------
-- 整理数据
-- ----------------------------
UPDATE sys_user SET nick_name = '管理员', email = 'admin@admin.admin' WHERE (`user_id` = '1');
DELETE FROM sys_user WHERE (`user_id` = '2');
DELETE FROM sys_user_post WHERE (`user_id` = '2');
DELETE FROM sys_user_role WHERE (`user_id` = '2');
DELETE FROM sys_notice;
UPDATE sys_dept SET dept_name = '根机构', leader = '管理员' WHERE (`dept_id` = '100');
DELETE FROM sys_dept WHERE (`dept_id` > 100);
DELETE FROM sys_role_dept WHERE (`dept_id` > 100);

-- ----------------------------
-- 整理菜单
-- ----------------------------
DELETE FROM sys_menu WHERE menu_name = '若依官网';
