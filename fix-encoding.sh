#!/bin/bash

# 文化遗产管理系统 - 字符编码修复脚本
# 使用方法: chmod +x fix-encoding.sh && ./fix-encoding.sh

set -e

echo "🔧 文化遗产管理系统 - 字符编码修复脚本"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 修复数据库字符编码
fix_database_encoding() {
    echo -e "${BLUE}🔧 修复数据库字符编码...${NC}"
    
    # 重新创建数据库，使用正确的字符集
    docker-compose -f docker-compose.simple.yml exec mysql mysql -u root -proot123 -e "
    DROP DATABASE IF EXISTS cultural_heritage;
    CREATE DATABASE cultural_heritage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    USE cultural_heritage;
    
    -- 重新创建表结构
    CREATE TABLE \`sys_user\` (
        \`user_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
        \`user_name\` VARCHAR(30) NOT NULL COMMENT '用户账号',
        \`nick_name\` VARCHAR(30) NOT NULL COMMENT '用户昵称',
        \`password\` VARCHAR(100) DEFAULT '' COMMENT '密码',
        \`email\` VARCHAR(50) DEFAULT '' COMMENT '用户邮箱',
        \`phone_number\` VARCHAR(11) DEFAULT '' COMMENT '手机号码',
        \`status\` CHAR(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        \`update_time\` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
        PRIMARY KEY (\`user_id\`),
        UNIQUE KEY \`idx_user_name\` (\`user_name\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户信息表';
    
    CREATE TABLE \`sys_role\` (
        \`role_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
        \`role_name\` VARCHAR(30) NOT NULL COMMENT '角色名称',
        \`role_key\` VARCHAR(100) NOT NULL COMMENT '角色权限字符串',
        \`status\` CHAR(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        PRIMARY KEY (\`role_id\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色信息表';
    
    CREATE TABLE \`sys_user_role\` (
        \`user_id\` BIGINT NOT NULL COMMENT '用户ID',
        \`role_id\` BIGINT NOT NULL COMMENT '角色ID',
        PRIMARY KEY (\`user_id\`, \`role_id\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户和角色关联表';
    
    CREATE TABLE \`heritage_info\` (
        \`heritage_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文化遗产ID',
        \`heritage_name\` VARCHAR(100) NOT NULL COMMENT '文化遗产名称',
        \`category\` VARCHAR(50) NOT NULL COMMENT '分类',
        \`description\` TEXT COMMENT '描述',
        \`era\` VARCHAR(50) COMMENT '年代',
        \`location\` VARCHAR(100) COMMENT '地点',
        \`protection_level\` VARCHAR(50) COMMENT '保护级别',
        \`status\` CHAR(1) DEFAULT '1' COMMENT '状态（0草稿 1已发布 2已下线）',
        \`view_count\` INT DEFAULT 0 COMMENT '浏览量',
        \`like_count\` INT DEFAULT 0 COMMENT '点赞数',
        \`collect_count\` INT DEFAULT 0 COMMENT '收藏数',
        \`comment_count\` INT DEFAULT 0 COMMENT '评论数',
        \`create_by\` VARCHAR(64) DEFAULT '' COMMENT '创建者',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        \`update_time\` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
        PRIMARY KEY (\`heritage_id\`),
        KEY \`idx_category\` (\`category\`),
        KEY \`idx_status\` (\`status\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产信息表';
    
    CREATE TABLE \`heritage_media\` (
        \`media_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '媒体ID',
        \`heritage_id\` BIGINT NOT NULL COMMENT '文化遗产ID',
        \`media_type\` VARCHAR(20) NOT NULL COMMENT '媒体类型（image/video/3d）',
        \`media_url\` VARCHAR(500) NOT NULL COMMENT '媒体URL',
        \`media_name\` VARCHAR(100) COMMENT '媒体名称',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        PRIMARY KEY (\`media_id\`),
        KEY \`idx_heritage_id\` (\`heritage_id\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文化遗产多媒体资源表';
    
    CREATE TABLE \`heritage_comment\` (
        \`comment_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
        \`user_id\` BIGINT NOT NULL COMMENT '用户ID',
        \`heritage_id\` BIGINT NOT NULL COMMENT '文化遗产ID',
        \`content\` TEXT NOT NULL COMMENT '评论内容',
        \`like_count\` INT DEFAULT 0 COMMENT '点赞数',
        \`status\` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1删除）',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        PRIMARY KEY (\`comment_id\`),
        KEY \`idx_heritage_id\` (\`heritage_id\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';
    
    CREATE TABLE \`sys_notice\` (
        \`notice_id\` BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID',
        \`notice_title\` VARCHAR(100) NOT NULL COMMENT '公告标题',
        \`notice_type\` CHAR(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
        \`notice_content\` TEXT COMMENT '公告内容',
        \`status\` CHAR(1) DEFAULT '0' COMMENT '状态（0正常 1关闭）',
        \`create_by\` VARCHAR(64) DEFAULT '' COMMENT '创建者',
        \`create_time\` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
        PRIMARY KEY (\`notice_id\`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告信息表';
    "
    
    echo -e "${GREEN}✅ 数据库表结构已重新创建${NC}"
}

# 插入正确的示例数据
insert_sample_data() {
    echo -e "${BLUE}📊 插入示例数据...${NC}"
    
    docker-compose -f docker-compose.simple.yml exec mysql mysql -u root -proot123 cultural_heritage -e "
    -- 插入角色数据
    INSERT INTO \`sys_role\` (\`role_name\`, \`role_key\`, \`status\`) VALUES
    ('系统管理员', 'admin', '0'),
    ('平台管理员', 'manager', '0'),
    ('普通用户', 'user', '0');
    
    -- 插入用户数据
    INSERT INTO \`sys_user\` (\`user_name\`, \`nick_name\`, \`password\`, \`email\`, \`phone_number\`, \`status\`) VALUES
    ('admin', '系统管理员', '\$2a\$10\$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'admin@heritage.com', '13800138000', '0'),
    ('manager', '平台管理员', '\$2a\$10\$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'manager@heritage.com', '13800138001', '0'),
    ('user1', '普通用户', '\$2a\$10\$7JB720yubVSOfvVWb5XzCOYz6Vj8u4QJzP8JzP8JzP8JzP8JzP8JzP', 'user1@heritage.com', '13800138002', '0');
    
    -- 插入用户角色关联
    INSERT INTO \`sys_user_role\` (\`user_id\`, \`role_id\`) VALUES
    (1, 1), (2, 2), (3, 3);
    
    -- 插入文化遗产数据
    INSERT INTO \`heritage_info\` (\`heritage_name\`, \`category\`, \`description\`, \`era\`, \`location\`, \`protection_level\`, \`status\`, \`view_count\`, \`like_count\`, \`collect_count\`, \`comment_count\`, \`create_by\`) VALUES
    ('故宫博物院', '古建筑', '故宫博物院位于北京市中心，是中国明清两代的皇家宫殿，旧称紫禁城。故宫是世界上现存规模最大、保存最为完整的木质结构古建筑之一，被誉为世界五大宫之首。', '明清', '北京市东城区', '世界文化遗产', '1', 15280, 8520, 3200, 156, 'manager'),
    ('长城', '古建筑', '长城是中国古代的军事防御工程，是一道高大、坚固而连绵不断的长垣，用以限隔敌骑的行动。长城不是一道单纯孤立的城墙，而是以城墙为主体，同大量的城、障、亭、标相结合的防御体系。', '春秋战国至明清', '北京、河北、山西等', '世界文化遗产', '1', 28900, 12600, 5800, 289, 'manager'),
    ('兵马俑', '古遗址', '秦始皇兵马俑，位于陕西省西安市临潼区秦始皇陵以东1.5千米处的兵马俑坑内。兵马俑是古代墓葬雕塑的一个类别，制成兵马（战车、战马、士兵）形状的殉葬品。', '秦代', '陕西省西安市', '世界文化遗产', '1', 22100, 9800, 4200, 198, 'manager'),
    ('敦煌莫高窟', '石窟寺', '莫高窟，俗称千佛洞，坐落在河西走廊西端的敦煌。它始建于十六国的前秦时期，历经十六国、北朝、隋、唐、五代、西夏、元等历代的兴建，形成巨大的规模。', '十六国至元', '甘肃省敦煌市', '世界文化遗产', '1', 18700, 7900, 3600, 145, 'manager'),
    ('苏州园林', '古建筑', '苏州古典园林，亦称\"苏州园林\"，是位于江苏省苏州市境内的中国古典园林的总称。苏州古典园林溯源于春秋，发展于晋唐，繁荣于两宋，全盛于明清。', '春秋至明清', '江苏省苏州市', '世界文化遗产', '1', 13500, 5600, 2400, 98, 'manager'),
    ('龙门石窟', '石窟寺', '龙门石窟位于河南省洛阳市，是中国石刻艺术宝库之一，开凿于北魏孝文帝年间，之后历经东魏、西魏、北齐、隋、唐、五代、宋等朝代连续大规模营造达400余年之久。', '北魏至宋', '河南省洛阳市', '世界文化遗产', '1', 16200, 6800, 2900, 112, 'manager'),
    ('都江堰', '古建筑', '都江堰位于四川省成都市都江堰市城西，坐落在成都平原西部的岷江上，是由秦国蜀郡太守李冰及其子率众于公元前256年左右修建的并使用至今的大型水利工程。', '秦代', '四川省成都市', '世界文化遗产', '1', 12800, 5200, 2100, 87, 'manager'),
    ('西湖', '文化景观', '西湖，位于浙江省杭州市西湖区龙井路1号，杭州市区西部，景区总面积49平方千米，汇水面积为21.22平方千米，湖面面积为6.38平方千米。', '唐宋至今', '浙江省杭州市', '世界文化遗产', '1', 19800, 8600, 3800, 167, 'manager'),
    ('京剧', '传统技艺', '京剧，曾称平剧，中国五大戏曲剧种之一，场景布置注重写意，腔调以西皮、二黄为主，用胡琴和锣鼓等伴奏，被视为中国国粹，中国戏曲三鼎甲\"榜首\"。', '清代至今', '全国', '国家级非物质文化遗产', '1', 9600, 4200, 1800, 72, 'manager'),
    ('中国书法', '传统技艺', '中国书法是一门古老的汉字的书写艺术，从甲骨文、石鼓文、金文演变而为大篆、小篆、隶书，至定型于东汉、魏、晋的草书、楷书、行书等，书法一直散发着艺术的魅力。', '商周至今', '全国', '国家级非物质文化遗产', '1', 8900, 3800, 1600, 65, 'manager');
    
    -- 插入多媒体资源
    INSERT INTO \`heritage_media\` (\`heritage_id\`, \`media_type\`, \`media_url\`, \`media_name\`) VALUES
    (1, 'image', '/uploads/heritage/gugong_01.jpg', '故宫全景图'),
    (1, 'image', '/uploads/heritage/gugong_02.jpg', '太和殿'),
    (1, 'video', '/uploads/heritage/gugong_video.mp4', '故宫纪录片'),
    (2, 'image', '/uploads/heritage/greatwall_01.jpg', '八达岭长城'),
    (2, 'image', '/uploads/heritage/greatwall_02.jpg', '长城远景'),
    (2, 'video', '/uploads/heritage/greatwall_video.mp4', '长城航拍'),
    (3, 'image', '/uploads/heritage/terracotta_01.jpg', '兵马俑一号坑'),
    (3, 'image', '/uploads/heritage/terracotta_02.jpg', '兵马俑近景'),
    (3, '3d', '/uploads/heritage/terracotta_3d.obj', '兵马俑3D模型'),
    (4, 'image', '/uploads/heritage/mogao_01.jpg', '莫高窟外观'),
    (4, 'image', '/uploads/heritage/mogao_02.jpg', '洞窟壁画'),
    (4, 'video', '/uploads/heritage/mogao_video.mp4', '数字敦煌'),
    (5, 'image', '/uploads/heritage/suzhou_01.jpg', '拙政园'),
    (5, 'image', '/uploads/heritage/suzhou_02.jpg', '留园'),
    (6, 'image', '/uploads/heritage/longmen_01.jpg', '龙门石窟');
    
    -- 插入评论数据
    INSERT INTO \`heritage_comment\` (\`user_id\`, \`heritage_id\`, \`content\`, \`like_count\`) VALUES
    (3, 1, '故宫真是太壮观了！每次去都有新的发现，中华文明的瑰宝！', 15),
    (3, 1, '特别推荐去御花园，景色宜人，非常适合拍照。', 8),
    (3, 2, '长城不愧是世界奇迹，登上长城才能真正感受到古人的智慧和毅力。', 12),
    (3, 2, '八达岭长城是最经典的一段，建议春秋季节去，风景最美。', 6),
    (3, 3, '兵马俑的规模令人震撼，每一个陶俑都有独特的表情和姿态。', 18),
    (3, 4, '莫高窟的壁画艺术价值极高，是中华文化的重要载体。', 9),
    (3, 5, '苏州园林的精巧设计体现了中国古典园林的独特魅力。', 7);
    
    -- 插入公告数据
    INSERT INTO \`sys_notice\` (\`notice_title\`, \`notice_type\`, \`notice_content\`, \`status\`, \`create_by\`) VALUES
    ('欢迎使用文化遗产管理系统', '2', '欢迎使用文化遗产管理与展示系统！本系统致力于保护和传承中华优秀传统文化，通过数字化技术让更多人了解和认识我们的文化遗产。', '0', 'admin'),
    ('系统维护通知', '1', '系统将于每周日凌晨2:00-4:00进行例行维护，期间可能影响正常使用，请提前做好相关准备。', '0', 'admin'),
    ('新功能上线', '2', '系统新增了3D模型展示功能，支持更多类型的多媒体内容展示，为用户提供更丰富的浏览体验。', '0', 'manager');
    "
    
    echo -e "${GREEN}✅ 示例数据已插入${NC}"
}

# 重启后端服务
restart_backend() {
    echo -e "${BLUE}🔄 重启后端服务...${NC}"
    docker-compose -f docker-compose.simple.yml restart backend
    sleep 20
    echo -e "${GREEN}✅ 后端服务已重启${NC}"
}

# 测试API
test_api() {
    echo -e "${BLUE}🧪 测试API接口...${NC}"
    
    # 等待服务启动
    sleep 10
    
    # 测试API
    echo "测试文化遗产列表API..."
    curl -s "http://localhost:8080/api/api/heritage/list?page=0&size=1" | head -3
    
    echo -e "\n${GREEN}✅ API测试完成${NC}"
}

# 显示结果
show_result() {
    echo -e "\n${GREEN}🎉 字符编码修复完成！${NC}"
    echo "=========================================="
    echo -e "${BLUE}🌐 访问地址：${NC}"
    echo "  前端系统: http://localhost:5173"
    echo "  后端API:  http://localhost:8080/api"
    echo ""
    echo -e "${BLUE}📊 系统数据：${NC}"
    echo "  • 文化遗产数据: 10条"
    echo "  • 多媒体资源: 15条"
    echo "  • 评论数据: 7条"
    echo "  • 公告数据: 3条"
    echo ""
    echo -e "${GREEN}✨ 现在可以正常使用系统了！${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}开始修复字符编码问题...${NC}\n"
    
    fix_database_encoding
    insert_sample_data
    restart_backend
    test_api
    show_result
}

# 错误处理
trap 'echo -e "${RED}❌ 修复过程中出现错误！${NC}"; exit 1' ERR

# 执行主函数
main "$@"

