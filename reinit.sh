#!/bin/bash

# 文化遗产管理系统 - 重新初始化脚本
# 使用方法: chmod +x reinit.sh && ./reinit.sh

set -e

echo "🔄 文化遗产管理系统 - 重新初始化脚本"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 停止所有服务
stop_services() {
    echo -e "${BLUE}🛑 停止所有服务...${NC}"
    docker-compose -f docker-compose.simple.yml down
    echo -e "${GREEN}✅ 服务已停止${NC}"
}

# 清理数据卷
clean_volumes() {
    echo -e "${BLUE}🗑️  清理数据卷...${NC}"
    docker volume rm cultural-heritage-system_mysql_data cultural-heritage-system_redis_data 2>/dev/null || true
    echo -e "${GREEN}✅ 数据卷已清理${NC}"
}

# 修复数据库连接配置
fix_database_config() {
    echo -e "${BLUE}🔧 修复数据库连接配置...${NC}"
    
    # 创建简化的数据库连接字符串
    cat > backend/src/main/resources/application-simple.yml << 'EOF'
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: cultural-heritage-system
  
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://mysql:3306/cultural_heritage?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: heritage_user
    password: heritage123
    hikari:
      minimum-idle: 5
      maximum-pool-size: 20
      auto-commit: true
      idle-timeout: 600000
      pool-name: HeritageHikariCP
      max-lifetime: 1800000
      connection-timeout: 30000

  jpa:
    database-platform: org.hibernate.dialect.MySQL8Dialect
    show-sql: true
    hibernate:
      ddl-auto: none
    properties:
      hibernate:
        format_sql: true
        use_sql_comments: true

  redis:
    host: redis
    port: 6379
    password:
    database: 0
    timeout: 3000

  servlet:
    multipart:
      enabled: true
      max-file-size: 50MB
      max-request-size: 100MB

  jackson:
    time-zone: GMT+8
    date-format: yyyy-MM-dd HH:mm:ss

logging:
  level:
    root: INFO
    com.heritage: DEBUG
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"

jwt:
  secret: culturalHeritageSystemSecretKey2024ForJWTTokenGeneration
  expiration: 604800
  tokenHead: "Bearer "
  tokenHeader: Authorization

file:
  upload:
    path: /app/uploads
    url-prefix: /uploads
    max-file-size: 100MB
    base-path: ./uploads/
    allowed-extensions: jpg,jpeg,png,gif,bmp,mp4,avi,mov,3ds,obj,fbx,pdf,doc,docx
EOF

    echo -e "${GREEN}✅ 数据库配置已修复${NC}"
}

# 重新启动服务
restart_services() {
    echo -e "${BLUE}🚀 重新启动服务...${NC}"
    docker-compose -f docker-compose.simple.yml up -d
    echo -e "${GREEN}✅ 服务已启动${NC}"
}

# 等待服务就绪
wait_for_services() {
    echo -e "${BLUE}⏳ 等待服务启动...${NC}"
    sleep 30
    echo -e "${GREEN}✅ 等待完成${NC}"
}

# 测试服务
test_services() {
    echo -e "${BLUE}🧪 测试服务...${NC}"
    
    # 测试数据库连接
    echo "测试数据库连接..."
    docker-compose -f docker-compose.simple.yml exec mysql mysql -u heritage_user -pheritage123 -e "SELECT 1;" 2>/dev/null && echo -e "${GREEN}✅ 数据库连接正常${NC}" || echo -e "${RED}❌ 数据库连接失败${NC}"
    
    # 测试API
    echo "测试API接口..."
    sleep 10
    curl -s "http://localhost:8080/api/api/heritage/list?page=0&size=1" > /dev/null && echo -e "${GREEN}✅ API接口正常${NC}" || echo -e "${RED}❌ API接口失败${NC}"
}

# 显示结果
show_result() {
    echo -e "\n${GREEN}🎉 重新初始化完成！${NC}"
    echo "=================================="
    echo -e "${BLUE}🌐 访问地址：${NC}"
    echo "  前端系统: http://localhost:5173"
    echo "  后端API:  http://localhost:8080/api"
    echo ""
    echo -e "${BLUE}👤 默认账户：${NC}"
    echo "  管理员: admin / admin123"
    echo "  普通用户: user1 / user123"
    echo ""
    echo -e "${GREEN}✨ 现在可以正常使用系统了！${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}开始重新初始化文化遗产管理系统...${NC}\n"
    
    stop_services
    clean_volumes
    fix_database_config
    restart_services
    wait_for_services
    test_services
    show_result
}

# 错误处理
trap 'echo -e "${RED}❌ 重新初始化过程中出现错误！${NC}"; exit 1' ERR

# 执行主函数
main "$@"

