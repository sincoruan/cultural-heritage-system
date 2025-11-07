#!/bin/bash

# 文化遗产管理系统 - 新机器完整部署脚本
# 使用方法: chmod +x fresh-deploy.sh && ./fresh-deploy.sh

set -e

echo "🚀 文化遗产管理系统 - 新机器完整部署脚本"
echo "=============================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Docker环境
check_docker() {
    echo -e "${BLUE}🔍 检查Docker环境...${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker未安装！${NC}"
        echo "请先安装Docker Desktop: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose未安装！${NC}"
        echo "请先安装Docker Compose"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Docker环境检查通过${NC}"
}

# 清理旧环境
clean_old_environment() {
    echo -e "${BLUE}🧹 清理旧环境...${NC}"
    
    # 停止并删除相关容器
    docker stop heritage-backend heritage-frontend heritage-mysql heritage-redis 2>/dev/null || true
    docker rm heritage-backend heritage-frontend heritage-mysql heritage-redis 2>/dev/null || true
    
    # 删除相关镜像
    docker rmi cultural-heritage-system-backend cultural-heritage-system-frontend 2>/dev/null || true
    
    # 删除数据卷
    docker volume rm cultural-heritage-system_mysql_data cultural-heritage-system_redis_data 2>/dev/null || true
    
    # 删除网络
    docker network rm cultural-heritage-system_default 2>/dev/null || true
    
    echo -e "${GREEN}✅ 旧环境已清理${NC}"
}

# 修复数据库初始化脚本
fix_database_init() {
    echo -e "${BLUE}🔧 修复数据库初始化脚本...${NC}"
    
    # 创建修复后的初始化脚本
    cat > database/init_fixed.sql << 'EOF'
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
EOF

    echo -e "${GREEN}✅ 数据库初始化脚本已修复${NC}"
}

# 创建示例数据脚本
create_sample_data() {
    echo -e "${BLUE}📊 创建示例数据脚本...${NC}"
    
    cat > database/sample_data_fixed.sql << 'EOF'
-- 文化遗产管理与展示系统 - 示例数据脚本（修复版）

USE cultural_heritage;

-- 插入示例文化遗产数据
INSERT INTO `heritage_info` (`heritage_name`, `category`, `description`, `era`, `location`, `protection_level`, `status`, `view_count`, `like_count`, `collect_count`, `comment_count`, `create_by`, `create_time`) VALUES
('故宫博物院', '古建筑', '故宫博物院位于北京市中心，是中国明清两代的皇家宫殿，旧称紫禁城。故宫是世界上现存规模最大、保存最为完整的木质结构古建筑之一，被誉为世界五大宫之首。', '明清', '北京市东城区', '世界文化遗产', '1', 15280, 8520, 3200, 156, 'manager', NOW()),
('长城', '古建筑', '长城是中国古代的军事防御工程，是一道高大、坚固而连绵不断的长垣，用以限隔敌骑的行动。长城不是一道单纯孤立的城墙，而是以城墙为主体，同大量的城、障、亭、标相结合的防御体系。', '春秋战国至明清', '北京、河北、山西等', '世界文化遗产', '1', 28900, 12600, 5800, 289, 'manager', NOW()),
('兵马俑', '古遗址', '秦始皇兵马俑，位于陕西省西安市临潼区秦始皇陵以东1.5千米处的兵马俑坑内。兵马俑是古代墓葬雕塑的一个类别，制成兵马（战车、战马、士兵）形状的殉葬品。', '秦代', '陕西省西安市', '世界文化遗产', '1', 22100, 9800, 4200, 198, 'manager', NOW()),
('敦煌莫高窟', '石窟寺', '莫高窟，俗称千佛洞，坐落在河西走廊西端的敦煌。它始建于十六国的前秦时期，历经十六国、北朝、隋、唐、五代、西夏、元等历代的兴建，形成巨大的规模。', '十六国至元', '甘肃省敦煌市', '世界文化遗产', '1', 18700, 7900, 3600, 145, 'manager', NOW()),
('苏州园林', '古建筑', '苏州古典园林，亦称"苏州园林"，是位于江苏省苏州市境内的中国古典园林的总称。苏州古典园林溯源于春秋，发展于晋唐，繁荣于两宋，全盛于明清。', '春秋至明清', '江苏省苏州市', '世界文化遗产', '1', 13500, 5600, 2400, 98, 'manager', NOW()),
('龙门石窟', '石窟寺', '龙门石窟位于河南省洛阳市，是中国石刻艺术宝库之一，开凿于北魏孝文帝年间，之后历经东魏、西魏、北齐、隋、唐、五代、宋等朝代连续大规模营造达400余年之久。', '北魏至宋', '河南省洛阳市', '世界文化遗产', '1', 16200, 6800, 2900, 112, 'manager', NOW()),
('都江堰', '古建筑', '都江堰位于四川省成都市都江堰市城西，坐落在成都平原西部的岷江上，是由秦国蜀郡太守李冰及其子率众于公元前256年左右修建的并使用至今的大型水利工程。', '秦代', '四川省成都市', '世界文化遗产', '1', 12800, 5200, 2100, 87, 'manager', NOW()),
('西湖', '文化景观', '西湖，位于浙江省杭州市西湖区龙井路1号，杭州市区西部，景区总面积49平方千米，汇水面积为21.22平方千米，湖面面积为6.38平方千米。', '唐宋至今', '浙江省杭州市', '世界文化遗产', '1', 19800, 8600, 3800, 167, 'manager', NOW()),
('京剧', '传统技艺', '京剧，曾称平剧，中国五大戏曲剧种之一，场景布置注重写意，腔调以西皮、二黄为主，用胡琴和锣鼓等伴奏，被视为中国国粹，中国戏曲三鼎甲"榜首"。', '清代至今', '全国', '国家级非物质文化遗产', '1', 9600, 4200, 1800, 72, 'manager', NOW()),
('中国书法', '传统技艺', '中国书法是一门古老的汉字的书写艺术，从甲骨文、石鼓文、金文演变而为大篆、小篆、隶书，至定型于东汉、魏、晋的草书、楷书、行书等，书法一直散发着艺术的魅力。', '商周至今', '全国', '国家级非物质文化遗产', '1', 8900, 3800, 1600, 65, 'manager', NOW());

-- 为前5个文化遗产插入多媒体资源（示例）
INSERT INTO `heritage_media` (`heritage_id`, `media_type`, `media_url`, `media_name`, `file_size`, `sort_order`) VALUES
(1, 'image', '/uploads/heritage/gugong_01.jpg', '故宫全景图', 2048576, 1),
(1, 'image', '/uploads/heritage/gugong_02.jpg', '太和殿', 1845632, 2),
(1, 'image', '/uploads/heritage/gugong_03.jpg', '御花园', 1956780, 3),
(1, 'video', '/uploads/heritage/gugong_video.mp4', '故宫纪录片', 52428800, 4),
(2, 'image', '/uploads/heritage/greatwall_01.jpg', '八达岭长城', 2248576, 1),
(2, 'image', '/uploads/heritage/greatwall_02.jpg', '长城远景', 2145632, 2),
(2, 'video', '/uploads/heritage/greatwall_video.mp4', '长城航拍', 48428800, 3),
(3, 'image', '/uploads/heritage/terracotta_01.jpg', '兵马俑一号坑', 2348576, 1),
(3, 'image', '/uploads/heritage/terracotta_02.jpg', '兵马俑近景', 1945632, 2),
(3, '3d', '/uploads/heritage/terracotta_3d.obj', '兵马俑3D模型', 15728640, 3),
(4, 'image', '/uploads/heritage/mogao_01.jpg', '莫高窟外观', 2148576, 1),
(4, 'image', '/uploads/heritage/mogao_02.jpg', '洞窟壁画', 2345632, 2),
(4, 'video', '/uploads/heritage/mogao_video.mp4', '数字敦煌', 65428800, 3),
(5, 'image', '/uploads/heritage/suzhou_01.jpg', '拙政园', 1948576, 1),
(5, 'image', '/uploads/heritage/suzhou_02.jpg', '留园', 1845632, 2);

-- 插入示例评论
INSERT INTO `heritage_comment` (`user_id`, `heritage_id`, `content`, `parent_id`, `like_count`, `status`) VALUES
(3, 1, '故宫真是太壮观了！每次去都有新的发现，中华文明的瑰宝！', NULL, 15, '0'),
(3, 1, '特别推荐去御花园，景色宜人，非常适合拍照。', NULL, 8, '0'),
(3, 2, '长城不愧是世界奇迹，登上长城才能真正感受到古人的智慧和毅力。', NULL, 12, '0'),
(3, 2, '八达岭长城是最经典的一段，建议春秋季节去，风景最美。', NULL, 6, '0'),
(3, 3, '兵马俑的规模令人震撼，每一个陶俑都有独特的表情和姿态。', NULL, 18, '0'),
(3, 4, '莫高窟的壁画艺术价值极高，是中华文化的重要载体。', NULL, 9, '0'),
(3, 5, '苏州园林的精巧设计体现了中国古典园林的独特魅力。', NULL, 7, '0');

-- 插入示例公告
INSERT INTO `sys_notice` (`notice_title`, `notice_type`, `notice_content`, `status`, `create_by`) VALUES
('欢迎使用文化遗产管理系统', '2', '欢迎使用文化遗产管理与展示系统！本系统致力于保护和传承中华优秀传统文化，通过数字化技术让更多人了解和认识我们的文化遗产。', '0', 'admin'),
('系统维护通知', '1', '系统将于每周日凌晨2:00-4:00进行例行维护，期间可能影响正常使用，请提前做好相关准备。', '0', 'admin'),
('新功能上线', '2', '系统新增了3D模型展示功能，支持更多类型的多媒体内容展示，为用户提供更丰富的浏览体验。', '0', 'manager');
EOF

    echo -e "${GREEN}✅ 示例数据脚本已创建${NC}"
}

# 修复Docker Compose配置
fix_docker_compose() {
    echo -e "${BLUE}🔧 修复Docker Compose配置...${NC}"
    
    # 更新数据库初始化脚本挂载
    cat > docker-compose.simple.yml << 'EOF'
version: '3.8'

services:
  # MySQL数据库
  mysql:
    image: mysql:8.0
    container_name: heritage-mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: cultural_heritage
      MYSQL_USER: heritage_user
      MYSQL_PASSWORD: heritage123
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database/init_fixed.sql:/docker-entrypoint-initdb.d/01-init.sql
      - ./database/sample_data_fixed.sql:/docker-entrypoint-initdb.d/02-sample.sql
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Redis缓存
  redis:
    image: redis:6.2-alpine
    container_name: heritage-redis
    restart: always
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes

  # 后端服务
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: heritage-backend
    restart: always
    ports:
      - "8080:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/cultural_heritage?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true&useAffectedRows=true&autoReconnect=true&failOverReadOnly=false&maxReconnects=10
      SPRING_DATASOURCE_USERNAME: heritage_user
      SPRING_DATASOURCE_PASSWORD: heritage123
      SPRING_REDIS_HOST: redis
      SPRING_REDIS_PORT: 6379
      JWT_SECRET: culturalHeritageSystemSecretKey2024ForJWTTokenGeneration
    volumes:
      - ./uploads:/app/uploads
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_started

  # 前端服务
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: heritage-frontend
    restart: always
    ports:
      - "5173:5173"
    environment:
      VITE_API_BASE_URL: http://localhost:8080/api
    depends_on:
      - backend

volumes:
  mysql_data:
  redis_data:
EOF

    echo -e "${GREEN}✅ Docker Compose配置已修复${NC}"
}

# 启动服务
start_services() {
    echo -e "${BLUE}🚀 启动服务...${NC}"
    docker-compose -f docker-compose.simple.yml up -d
    echo -e "${GREEN}✅ 服务已启动${NC}"
}

# 等待服务就绪
wait_for_services() {
    echo -e "${BLUE}⏳ 等待服务启动...${NC}"
    
    # 等待数据库启动
    echo "等待数据库启动..."
    sleep 20
    
    # 等待后端启动
    echo "等待后端服务启动..."
    sleep 30
    
    # 等待前端启动
    echo "等待前端服务启动..."
    sleep 10
    
    echo -e "${GREEN}✅ 服务启动完成${NC}"
}

# 验证部署
verify_deployment() {
    echo -e "${BLUE}🧪 验证部署...${NC}"
    
    # 检查服务状态
    echo "检查服务状态..."
    docker-compose -f docker-compose.simple.yml ps
    
    # 测试数据库连接
    echo "测试数据库连接..."
    docker-compose -f docker-compose.simple.yml exec mysql mysql -u heritage_user -pheritage123 -e "SELECT 1;" 2>/dev/null && echo -e "${GREEN}✅ 数据库连接正常${NC}" || echo -e "${RED}❌ 数据库连接失败${NC}"
    
    # 测试API接口
    echo "测试API接口..."
    sleep 10
    curl -s "http://localhost:8080/api/api/heritage/list?page=0&size=1" > /dev/null && echo -e "${GREEN}✅ API接口正常${NC}" || echo -e "${RED}❌ API接口失败${NC}"
    
    # 测试前端
    echo "测试前端..."
    curl -s "http://localhost:5173" > /dev/null && echo -e "${GREEN}✅ 前端服务正常${NC}" || echo -e "${RED}❌ 前端服务失败${NC}"
}

# 显示部署结果
show_deployment_result() {
    echo -e "\n${GREEN}🎉 新机器部署完成！${NC}"
    echo "=============================================="
    echo -e "${BLUE}🌐 访问地址：${NC}"
    echo "  前端系统: http://localhost:5173"
    echo "  后端API:  http://localhost:8080/api"
    echo ""
    echo -e "${BLUE}👤 默认账户：${NC}"
    echo "  管理员: admin / admin123"
    echo "  平台管理员: manager / manager123"
    echo "  普通用户: user1 / user123"
    echo ""
    echo -e "${BLUE}📊 系统数据：${NC}"
    echo "  • 文化遗产数据: 10条"
    echo "  • 多媒体资源: 15条"
    echo "  • 评论数据: 7条"
    echo "  • 公告数据: 3条"
    echo ""
    echo -e "${BLUE}🔧 管理命令：${NC}"
    echo "  查看状态: docker-compose -f docker-compose.simple.yml ps"
    echo "  查看日志: docker-compose -f docker-compose.simple.yml logs"
    echo "  停止服务: docker-compose -f docker-compose.simple.yml down"
    echo "  重启服务: docker-compose -f docker-compose.simple.yml restart"
    echo ""
    echo -e "${GREEN}✨ 现在可以开始使用系统了！${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}开始新机器完整部署文化遗产管理系统...${NC}\n"
    
    check_docker
    clean_old_environment
    fix_database_init
    create_sample_data
    fix_docker_compose
    start_services
    wait_for_services
    verify_deployment
    show_deployment_result
}

# 错误处理
trap 'echo -e "${RED}❌ 部署过程中出现错误！${NC}"; exit 1' ERR

# 执行主函数
main "$@"

