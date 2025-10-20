-- 文化遗产管理与展示系统 - 数据库初始化脚本
-- 数据库：cultural_heritage
-- 字符集：utf8mb4

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS cultural_heritage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cultural_heritage;

-- 1. 用户信息表
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `dept_id` BIGINT DEFAULT NULL COMMENT '部门ID',
    `user_name` VARCHAR(30) NOT NULL COMMENT '用户账号',
    `nick_name` VARCHAR(30) NOT NULL COMMENT '用户昵称',
    `user_type` VARCHAR(2) DEFAULT '00' COMMENT '用户类型（00系统用户 01注册用户）',
    `email` VARCHAR(50) DEFAULT '' COMMENT '用户邮箱',
    `phone_number` VARCHAR(11) DEFAULT '' COMMENT '手机号码',
    `sex` CHAR(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
    `avatar` VARCHAR(100) DEFAULT '' COMMENT '头像地址',
    `password` VARCHAR(100) DEFAULT '' COMMENT '密码',
    `status` CHAR(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
    `del_flag` CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    `login_ip` VARCHAR(128) DEFAULT '' COMMENT '最后登录IP',
    `login_date` DATETIME DEFAULT NULL COMMENT '最后登录时间',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `idx_user_name` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';

-- 2. 角色信息表
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
    `role_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    `role_name` VARCHAR(30) NOT NULL COMMENT '角色名称',
    `role_key` VARCHAR(100) NOT NULL COMMENT '角色权限字符串',
    `role_sort` INT NOT NULL COMMENT '显示顺序',
    `data_scope` CHAR(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
    `menu_check_strictly` TINYINT(1) DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
    `dept_check_strictly` TINYINT(1) DEFAULT 1 COMMENT '部门树选择项是否关联显示',
    `status` CHAR(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
    `del_flag` CHAR(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';

-- 3. 用户和角色关联表
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    PRIMARY KEY (`user_id`, `role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和角色关联表';

-- 4. 搜索日志表
DROP TABLE IF EXISTS `sys_search_log`;
CREATE TABLE `sys_search_log` (
    `log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `log_name` VARCHAR(100) DEFAULT '' COMMENT '日志名称',
    `search_keyword` VARCHAR(200) DEFAULT '' COMMENT '搜索关键词',
    `search_type` VARCHAR(50) DEFAULT '' COMMENT '搜索类型',
    `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`log_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索日志表';

-- 5. 文化遗产信息表
DROP TABLE IF EXISTS `heritage_info`;
CREATE TABLE `heritage_info` (
    `heritage_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文化遗产ID',
    `heritage_name` VARCHAR(200) NOT NULL COMMENT '文化遗产名称',
    `category` VARCHAR(100) DEFAULT NULL COMMENT '类别',
    `description` TEXT COMMENT '文化遗产描述',
    `era` VARCHAR(100) DEFAULT NULL COMMENT '年代',
    `location` VARCHAR(200) DEFAULT NULL COMMENT '地点',
    `protection_level` VARCHAR(50) DEFAULT NULL COMMENT '保护等级',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态（0待审核 1已发布 2已下架）',
    `view_count` BIGINT DEFAULT 0 COMMENT '浏览量',
    `like_count` BIGINT DEFAULT 0 COMMENT '点赞数',
    `collect_count` BIGINT DEFAULT 0 COMMENT '收藏数',
    `comment_count` BIGINT DEFAULT 0 COMMENT '评论数',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    PRIMARY KEY (`heritage_id`),
    KEY `idx_category` (`category`),
    KEY `idx_era` (`era`),
    KEY `idx_location` (`location`),
    KEY `idx_status` (`status`),
    FULLTEXT KEY `idx_fulltext` (`heritage_name`, `description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产信息表';

-- 6. 文化遗产多媒体资源表
DROP TABLE IF EXISTS `heritage_media`;
CREATE TABLE `heritage_media` (
    `media_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '媒体ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `media_type` VARCHAR(20) NOT NULL COMMENT '媒体类型（image图片/video视频/3d模型）',
    `media_url` VARCHAR(500) NOT NULL COMMENT '媒体URL',
    `media_name` VARCHAR(200) DEFAULT NULL COMMENT '媒体名称',
    `file_size` BIGINT DEFAULT NULL COMMENT '文件大小（字节）',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`media_id`),
    KEY `idx_heritage_id` (`heritage_id`),
    CONSTRAINT `fk_media_heritage` FOREIGN KEY (`heritage_id`) REFERENCES `heritage_info` (`heritage_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产多媒体资源表';

-- 7. 点赞表
DROP TABLE IF EXISTS `heritage_like`;
CREATE TABLE `heritage_like` (
    `like_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `target_id` BIGINT NOT NULL COMMENT '目标ID（文化遗产ID或评论ID）',
    `target_type` VARCHAR(20) NOT NULL COMMENT '目标类型（heritage/comment）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`like_id`),
    UNIQUE KEY `uk_user_target` (`user_id`, `target_id`, `target_type`),
    KEY `idx_target` (`target_id`, `target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞表';

-- 8. 评论表
DROP TABLE IF EXISTS `heritage_comment`;
CREATE TABLE `heritage_comment` (
    `comment_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `parent_id` BIGINT DEFAULT NULL COMMENT '父评论ID',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1已删除）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`comment_id`),
    KEY `idx_heritage_id` (`heritage_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_parent_id` (`parent_id`),
    CONSTRAINT `fk_comment_heritage` FOREIGN KEY (`heritage_id`) REFERENCES `heritage_info` (`heritage_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 9. 收藏表
DROP TABLE IF EXISTS `heritage_collect`;
CREATE TABLE `heritage_collect` (
    `collect_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`collect_id`),
    UNIQUE KEY `uk_user_heritage` (`user_id`, `heritage_id`),
    KEY `idx_heritage_id` (`heritage_id`),
    CONSTRAINT `fk_collect_heritage` FOREIGN KEY (`heritage_id`) REFERENCES `heritage_info` (`heritage_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- 10. 浏览量统计表
DROP TABLE IF EXISTS `heritage_view_stats`;
CREATE TABLE `heritage_view_stats` (
    `stat_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `view_count` BIGINT DEFAULT 0 COMMENT '浏览量',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    PRIMARY KEY (`stat_id`),
    UNIQUE KEY `uk_heritage_id` (`heritage_id`),
    CONSTRAINT `fk_stats_heritage` FOREIGN KEY (`heritage_id`) REFERENCES `heritage_info` (`heritage_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='浏览量统计表';

-- 11. 公告信息表
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
    `notice_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID',
    `notice_title` VARCHAR(200) NOT NULL COMMENT '公告标题',
    `notice_type` CHAR(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
    `notice_content` TEXT COMMENT '公告内容',
    `status` CHAR(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(255) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告信息表';

-- 12. 分类信息表
DROP TABLE IF EXISTS `heritage_category`;
CREATE TABLE `heritage_category` (
    `category_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
    `category_name` VARCHAR(100) NOT NULL COMMENT '分类名称',
    `category_desc` VARCHAR(500) DEFAULT NULL COMMENT '分类描述',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `heritage_count` INT DEFAULT 0 COMMENT '关联文化遗产数量',
    PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类信息表';

-- 插入默认角色数据
INSERT INTO `sys_role` VALUES 
(1, '系统管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', NOW(), '', NOW(), '系统管理员'),
(2, '平台管理员', 'manager', 2, '2', 1, 1, '0', '0', 'admin', NOW(), '', NOW(), '平台管理员'),
(3, '普通用户', 'user', 3, '5', 1, 1, '0', '0', 'admin', NOW(), '', NOW(), '普通用户');

-- 插入默认用户数据（密码使用BCrypt加密，原始密码：admin123, manager123, user123）
INSERT INTO `sys_user` VALUES 
(1, NULL, 'admin', '系统管理员', '00', 'admin@heritage.com', '13800138000', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU.qQTgdRWm', '0', '0', '127.0.0.1', NOW(), 'admin', NOW(), '', NOW(), '系统管理员'),
(2, NULL, 'manager', '平台管理员', '00', 'manager@heritage.com', '13800138001', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU.qQTgdRWm', '0', '0', '127.0.0.1', NOW(), 'admin', NOW(), '', NOW(), '平台管理员'),
(3, NULL, 'user', '普通用户', '01', 'user@heritage.com', '13800138002', '0', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/TU.qQTgdRWm', '0', '0', '127.0.0.1', NOW(), 'admin', NOW(), '', NOW(), '普通用户');

-- 插入用户角色关联
INSERT INTO `sys_user_role` VALUES (1, 1), (2, 2), (3, 3);

-- 插入默认分类数据
INSERT INTO `heritage_category` VALUES 
(1, '物质文化遗产', '包括古遗址、古墓葬、古建筑、石窟寺、石刻、壁画等', 0, 1, 'admin', NOW(), 0),
(2, '非物质文化遗产', '包括传统技艺、民俗活动、表演艺术等', 0, 2, 'admin', NOW(), 0),
(3, '古建筑', '历史悠久的建筑物', 1, 1, 'admin', NOW(), 0),
(4, '古遗址', '古代人类活动遗迹', 1, 2, 'admin', NOW(), 0),
(5, '传统技艺', '世代相传的手工技艺', 2, 1, 'admin', NOW(), 0),
(6, '民俗活动', '传统民间风俗活动', 2, 2, 'admin', NOW(), 0);

-- 插入示例公告
INSERT INTO `sys_notice` VALUES 
(1, '欢迎使用文化遗产管理与展示系统', '1', '本系统致力于文化遗产的数字化保护与展示，欢迎广大用户使用！', '0', 'admin', NOW(), '', NOW(), '系统公告'),
(2, '系统维护通知', '2', '系统将于本周日凌晨2:00-4:00进行维护升级，期间可能无法访问，请提前做好准备。', '0', 'admin', NOW(), '', NOW(), '维护通知');

COMMIT;

