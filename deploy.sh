#!/bin/bash

# 文化遗产管理系统 - 一键部署脚本
# 使用方法: chmod +x deploy.sh && ./deploy.sh

set -e

echo "🚀 文化遗产管理系统 - 一键部署脚本"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Docker是否安装
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

# 检查系统资源
check_resources() {
    echo -e "${BLUE}🔍 检查系统资源...${NC}"
    
    # 检查内存
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        MEMORY=$(sysctl -n hw.memsize)
        MEMORY_GB=$((MEMORY / 1024 / 1024 / 1024))
    else
        # Linux
        MEMORY=$(free -g | awk '/^Mem:/{print $2}')
        MEMORY_GB=$MEMORY
    fi
    
    if [ $MEMORY_GB -lt 4 ]; then
        echo -e "${YELLOW}⚠️  系统内存不足4GB，建议至少8GB内存${NC}"
    fi
    
    # 检查磁盘空间
    DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ $DISK_SPACE -lt 5 ]; then
        echo -e "${YELLOW}⚠️  磁盘空间不足5GB，建议至少10GB空间${NC}"
    fi
    
    echo -e "${GREEN}✅ 系统资源检查完成${NC}"
}

# 停止现有服务
stop_existing() {
    echo -e "${BLUE}🛑 停止现有服务...${NC}"
    
    if [ -f "docker-compose.simple.yml" ]; then
        docker-compose -f docker-compose.simple.yml down 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ 现有服务已停止${NC}"
}

# 启动服务
start_services() {
    echo -e "${BLUE}🚀 启动文化遗产管理系统...${NC}"
    
    # 启动所有服务
    docker-compose -f docker-compose.simple.yml up -d
    
    echo -e "${GREEN}✅ 服务启动完成${NC}"
}

# 等待服务就绪
wait_for_services() {
    echo -e "${BLUE}⏳ 等待服务启动...${NC}"
    
    # 等待数据库启动
    echo "等待数据库启动..."
    sleep 15
    
    # 等待后端启动
    echo "等待后端服务启动..."
    sleep 20
    
    # 等待前端启动
    echo "等待前端服务启动..."
    sleep 10
    
    echo -e "${GREEN}✅ 服务启动完成${NC}"
}

# 检查服务状态
check_services() {
    echo -e "${BLUE}🔍 检查服务状态...${NC}"
    
    # 检查容器状态
    echo "容器状态："
    docker-compose -f docker-compose.simple.yml ps
    
    # 检查端口
    echo -e "\n端口检查："
    
    # 检查前端端口
    if curl -s http://localhost:5173 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 前端服务正常 (http://localhost:5173)${NC}"
    else
        echo -e "${RED}❌ 前端服务异常${NC}"
    fi
    
    # 检查后端端口
    if curl -s http://localhost:8080/api/actuator/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 后端服务正常 (http://localhost:8080)${NC}"
    else
        echo -e "${YELLOW}⚠️  后端服务可能还在启动中${NC}"
    fi
}

# 显示访问信息
show_access_info() {
    echo -e "\n${GREEN}🎉 部署完成！${NC}"
    echo "=================================="
    echo -e "${BLUE}🌐 访问地址：${NC}"
    echo "  前端系统: http://localhost:5173"
    echo "  后端API:  http://localhost:8080/api"
    echo ""
    echo -e "${BLUE}👤 默认账户：${NC}"
    echo "  管理员: admin / admin123"
    echo "  普通用户: user1 / user123"
    echo ""
    echo -e "${BLUE}📋 功能说明：${NC}"
    echo "  • 文化遗产浏览和管理"
    echo "  • 多媒体展示（图片、视频、3D模型）"
    echo "  • 用户互动（评论、点赞、收藏）"
    echo "  • 系统监控和管理"
    echo ""
    echo -e "${BLUE}🔧 管理命令：${NC}"
    echo "  查看状态: docker-compose -f docker-compose.simple.yml ps"
    echo "  查看日志: docker-compose -f docker-compose.simple.yml logs"
    echo "  停止服务: docker-compose -f docker-compose.simple.yml down"
    echo "  重启服务: docker-compose -f docker-compose.simple.yml restart"
    echo ""
    echo -e "${GREEN}🎯 现在可以开始使用系统了！${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}开始部署文化遗产管理系统...${NC}\n"
    
    check_docker
    check_resources
    stop_existing
    start_services
    wait_for_services
    check_services
    show_access_info
}

# 错误处理
trap 'echo -e "${RED}❌ 部署过程中出现错误！${NC}"; exit 1' ERR

# 执行主函数
main "$@"
