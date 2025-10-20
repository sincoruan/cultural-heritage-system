#!/bin/bash

# 文化遗产管理系统 - 项目打包脚本
# 使用方法: chmod +x package.sh && ./package.sh

set -e

echo "📦 文化遗产管理系统 - 项目打包脚本"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取当前目录
PROJECT_DIR=$(pwd)
PROJECT_NAME="cultural-heritage-system"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="${PROJECT_NAME}_${TIMESTAMP}"

echo -e "${BLUE}📁 项目目录: ${PROJECT_DIR}${NC}"
echo -e "${BLUE}📦 打包名称: ${PACKAGE_NAME}${NC}"

# 创建临时目录
TEMP_DIR="/tmp/${PACKAGE_NAME}"
echo -e "${BLUE}🔧 创建临时目录: ${TEMP_DIR}${NC}"
mkdir -p "${TEMP_DIR}"

# 复制项目文件
echo -e "${BLUE}📋 复制项目文件...${NC}"

# 复制主要文件
cp -r backend "${TEMP_DIR}/"
cp -r frontend "${TEMP_DIR}/"
cp -r database "${TEMP_DIR}/" 2>/dev/null || echo "database目录不存在，跳过"

# 复制配置文件
cp docker-compose.simple.yml "${TEMP_DIR}/"
cp deploy.sh "${TEMP_DIR}/"
cp README.md "${TEMP_DIR}/"
cp 部署指南.md "${TEMP_DIR}/" 2>/dev/null || echo "部署指南.md不存在，跳过"

# 复制其他重要文件
cp package.sh "${TEMP_DIR}/" 2>/dev/null || echo "package.sh不存在，跳过"
cp start.sh "${TEMP_DIR}/" 2>/dev/null || echo "start.sh不存在，跳过"

# 清理不必要的文件
echo -e "${BLUE}🧹 清理不必要的文件...${NC}"

# 清理前端node_modules
if [ -d "${TEMP_DIR}/frontend/node_modules" ]; then
    rm -rf "${TEMP_DIR}/frontend/node_modules"
    echo "清理 frontend/node_modules"
fi

# 清理后端target
if [ -d "${TEMP_DIR}/backend/target" ]; then
    rm -rf "${TEMP_DIR}/backend/target"
    echo "清理 backend/target"
fi

# 清理Git文件
find "${TEMP_DIR}" -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
find "${TEMP_DIR}" -name ".gitignore" -type f -delete 2>/dev/null || true

# 清理日志文件
find "${TEMP_DIR}" -name "*.log" -type f -delete 2>/dev/null || true

# 清理临时文件
find "${TEMP_DIR}" -name "*.tmp" -type f -delete 2>/dev/null || true
find "${TEMP_DIR}" -name "*.swp" -type f -delete 2>/dev/null || true

# 创建部署说明文件
echo -e "${BLUE}📝 创建部署说明...${NC}"
cat > "${TEMP_DIR}/部署说明.txt" << EOF
文化遗产管理系统 - 部署说明
================================

1. 系统要求：
   - Docker Desktop 或 Docker Engine
   - 8GB+ 内存
   - 10GB+ 磁盘空间

2. 快速部署：
   chmod +x deploy.sh
   ./deploy.sh

3. 手动部署：
   docker-compose -f docker-compose.simple.yml up -d

4. 访问地址：
   - 前端: http://localhost:5173
   - 后端: http://localhost:8080/api

5. 默认账户：
   - 管理员: admin / admin123
   - 普通用户: user1 / user123

6. 常用命令：
   - 查看状态: docker-compose -f docker-compose.simple.yml ps
   - 查看日志: docker-compose -f docker-compose.simple.yml logs
   - 停止服务: docker-compose -f docker-compose.simple.yml down

7. 技术支持：
   如遇问题，请查看README.md或部署指南.md
EOF

# 创建压缩包
echo -e "${BLUE}🗜️  创建压缩包...${NC}"
cd /tmp
tar -czf "${PACKAGE_NAME}.tar.gz" "${PACKAGE_NAME}/"
zip -r "${PACKAGE_NAME}.zip" "${PACKAGE_NAME}/" > /dev/null 2>&1

# 移动压缩包到项目目录
mv "${PACKAGE_NAME}.tar.gz" "${PROJECT_DIR}/"
mv "${PACKAGE_NAME}.zip" "${PROJECT_DIR}/"

# 清理临时目录
rm -rf "${TEMP_DIR}"

# 显示结果
echo -e "\n${GREEN}✅ 打包完成！${NC}"
echo "=================================="
echo -e "${BLUE}📦 生成的文件：${NC}"
echo "  - ${PACKAGE_NAME}.tar.gz"
echo "  - ${PACKAGE_NAME}.zip"
echo ""
echo -e "${BLUE}📁 文件位置：${NC}"
echo "  ${PROJECT_DIR}/${PACKAGE_NAME}.tar.gz"
echo "  ${PROJECT_DIR}/${PACKAGE_NAME}.zip"
echo ""
echo -e "${BLUE}📋 文件大小：${NC}"
ls -lh "${PROJECT_DIR}/${PACKAGE_NAME}".*

echo -e "\n${GREEN}🎉 项目打包完成！${NC}"
echo -e "${YELLOW}💡 提示：可以将压缩包发送给其他人进行部署${NC}"
