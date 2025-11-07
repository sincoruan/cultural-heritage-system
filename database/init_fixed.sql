-- 文化遗产管理与展示系统 - 修复版数据库初始化脚本
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

-- 3. 用户角色关联表
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    PRIMARY KEY (`user_id`, `role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和角色关联表';

-- 4. 文化遗产信息表
DROP TABLE IF EXISTS `heritage_info`;
CREATE TABLE `heritage_info` (
    `heritage_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文化遗产ID',
    `heritage_name` VARCHAR(100) NOT NULL COMMENT '文化遗产名称',
    `category` VARCHAR(50) NOT NULL COMMENT '分类',
    `description` TEXT COMMENT '描述',
    `era` VARCHAR(50) COMMENT '年代',
    `location` VARCHAR(100) COMMENT '地点',
    `protection_level` VARCHAR(50) COMMENT '保护级别',
    `status` CHAR(1) DEFAULT '1' COMMENT '状态（0草稿 1已发布 2已下线）',
    `view_count` INT DEFAULT 0 COMMENT '浏览量',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `collect_count` INT DEFAULT 0 COMMENT '收藏数',
    `comment_count` INT DEFAULT 0 COMMENT '评论数',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`heritage_id`),
    KEY `idx_category` (`category`),
    KEY `idx_status` (`status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产信息表';

-- 5. 文化遗产多媒体资源表
DROP TABLE IF EXISTS `heritage_media`;
CREATE TABLE `heritage_media` (
    `media_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '媒体ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `media_type` VARCHAR(20) NOT NULL COMMENT '媒体类型（image/video/3d）',
    `media_url` VARCHAR(500) NOT NULL COMMENT '媒体URL',
    `media_name` VARCHAR(100) COMMENT '媒体名称',
    `file_size` BIGINT DEFAULT 0 COMMENT '文件大小（字节）',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`media_id`),
    KEY `idx_heritage_id` (`heritage_id`),
    KEY `idx_media_type` (`media_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产多媒体资源表';

-- 6. 评论表
DROP TABLE IF EXISTS `heritage_comment`;
CREATE TABLE `heritage_comment` (
    `comment_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `content` TEXT NOT NULL COMMENT '评论内容',
    `parent_id` BIGINT DEFAULT NULL COMMENT '父评论ID',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1删除）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`comment_id`),
    KEY `idx_heritage_id` (`heritage_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';

-- 7. 点赞表
DROP TABLE IF EXISTS `heritage_like`;
CREATE TABLE `heritage_like` (
    `like_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `target_id` BIGINT NOT NULL COMMENT '目标ID',
    `target_type` VARCHAR(20) NOT NULL COMMENT '目标类型（heritage/comment）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`like_id`),
    UNIQUE KEY `idx_user_target` (`user_id`, `target_id`, `target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞表';

-- 8. 收藏表
DROP TABLE IF EXISTS `heritage_collect`;
CREATE TABLE `heritage_collect` (
    `collect_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`collect_id`),
    UNIQUE KEY `idx_user_heritage` (`user_id`, `heritage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- 9. 浏览量统计表
DROP TABLE IF EXISTS `heritage_view_stats`;
CREATE TABLE `heritage_view_stats` (
    `stats_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `heritage_id` BIGINT NOT NULL COMMENT '文化遗产ID',
    `view_date` DATE NOT NULL COMMENT '浏览日期',
    `view_count` INT DEFAULT 0 COMMENT '浏览量',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`stats_id`),
    UNIQUE KEY `idx_heritage_date` (`heritage_id`, `view_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='浏览量统计表';

-- 10. 公告信息表
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
    `notice_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID',
    `notice_title` VARCHAR(100) NOT NULL COMMENT '公告标题',
    `notice_type` CHAR(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
    `notice_content` TEXT COMMENT '公告内容',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1关闭）',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告信息表';

-- 11. 分类信息表
DROP TABLE IF EXISTS `heritage_category`;
CREATE TABLE `heritage_category` (
    `category_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
    `category_name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `status` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类信息表';

-- 12. 搜索日志表
DROP TABLE IF EXISTS `sys_search_log`;
CREATE TABLE `sys_search_log` (
    `log_id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
    `search_keyword` VARCHAR(100) NOT NULL COMMENT '搜索关键词',
    `search_type` VARCHAR(20) DEFAULT 'heritage' COMMENT '搜索类型',
    `search_count` INT DEFAULT 1 COMMENT '搜索次数',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`log_id`),
    KEY `idx_keyword` (`search_keyword`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='搜索日志表';

-- 插入默认角色数据
INSERT INTO `sys_role` (`role_name`, `role_key`, `role_sort`, `status`, `remark`) VALUES
('系统管理员', 'admin', 1, '0', '系统管理员'),
('平台管理员', 'manager', 2, '0', '平台管理员'),
('普通用户', 'user', 3, '0', '普通用户');

-- 插入默认用户数据
INSERT INTO `sys_user` (`user_name`, `nick_name`, `password`, `email`, `phone_number`, `status`, `create_by`) VALUES
('admin', '系统管理员', '$2a$10$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'admin@heritage.com', '13800138000', '0', 'system'),
('manager', '平台管理员', '$2a$10$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'manager@heritage.com', '13800138001', '0', 'system'),
('user1', '普通用户', '$2a$10$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'user1@heritage.com', '13800138002', '0', 'system');

-- 插入用户角色关联数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1), -- admin -> 系统管理员
(2, 2), -- manager -> 平台管理员
(3, 3); -- user1 -> 普通用户
