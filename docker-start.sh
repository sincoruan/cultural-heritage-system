#!/bin/bash

# 文化遗产管理与展示系统 - Docker启动脚本

echo "========================================="
echo "  文化遗产管理与展示系统 - Docker启动"
echo "========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Docker是否安装
echo -n "检查Docker... "
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker已安装"
else
    echo -e "${RED}✗${NC} Docker未安装"
    echo "请先安装Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查Docker Compose是否安装
echo -n "检查Docker Compose... "
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker Compose已安装"
else
    echo -e "${RED}✗${NC} Docker Compose未安装"
    echo "请先安装Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# 检查Docker是否运行
echo -n "检查Docker服务... "
if docker info &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker服务正在运行"
else
    echo -e "${RED}✗${NC} Docker服务未运行"
    echo "请先启动Docker服务"
    exit 1
fi

echo ""
echo "========================================="
echo "  构建和启动服务..."
echo "========================================="

# 停止现有容器（如果有）
echo "停止现有容器..."
docker-compose -f docker-compose.simple.yml down

# 构建并启动服务
echo "构建和启动所有服务..."
docker-compose -f docker-compose.simple.yml up --build -d

# 等待服务启动
echo ""
echo -n "等待服务启动"
for i in {1..60}; do
    if curl -s http://localhost:8080/api/actuator/health > /dev/null 2>&1; then
        echo ""
        echo -e "${GREEN}✓${NC} 后端服务启动成功"
        break
    fi
    echo -n "."
    sleep 2
    if [ $i -eq 60 ]; then
        echo ""
        echo -e "${YELLOW}!${NC} 后端服务启动较慢，请稍候..."
    fi
done

# 检查前端服务
echo -n "检查前端服务... "
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} 前端服务启动成功"
else
    echo -e "${YELLOW}!${NC} 前端服务可能还在启动中..."
fi

echo ""
echo "========================================="
echo "  🎉 系统启动完成！"
echo "========================================="
echo ""
echo -e "${BLUE}访问地址:${NC}"
echo "  前端地址: ${GREEN}http://localhost:5173${NC}"
echo "  后端API:  ${GREEN}http://localhost:8080/api${NC}"
echo "  接口文档: ${GREEN}http://localhost:8080/api/doc.html${NC}"
echo ""
echo -e "${BLUE}默认账号:${NC}"
echo "  管理员: admin / admin123"
echo "  用户: user / user123"
echo ""
echo -e "${BLUE}Docker命令:${NC}"
echo "  查看日志: docker-compose logs -f"
echo "  停止服务: docker-compose down"
echo "  重启服务: docker-compose restart"
echo "  查看状态: docker-compose ps"
echo ""
echo "========================================="

# 显示容器状态
echo "容器状态:"
docker-compose -f docker-compose.simple.yml ps
