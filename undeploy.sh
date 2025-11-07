#!/bin/bash

# 文化遗产管理系统 - 卸载脚本
# 使用方法: chmod +x undeploy.sh && ./undeploy.sh

set -e

echo "🛑 文化遗产管理系统 - 卸载脚本"
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
    
    if [ -f "docker-compose.simple.yml" ]; then
        docker-compose -f docker-compose.simple.yml down
        echo -e "${GREEN}✅ 服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  docker-compose.simple.yml 文件不存在${NC}"
    fi
}

# 清理容器和镜像
clean_containers() {
    echo -e "${BLUE}🧹 清理容器和镜像...${NC}"
    
    # 停止并删除相关容器
    docker stop heritage-backend heritage-frontend heritage-mysql heritage-redis 2>/dev/null || true
    docker rm heritage-backend heritage-frontend heritage-mysql heritage-redis 2>/dev/null || true
    
    # 删除相关镜像
    docker rmi cultural-heritage-system-backend cultural-heritage-system-frontend 2>/dev/null || true
    
    echo -e "${GREEN}✅ 容器和镜像已清理${NC}"
}

# 清理数据卷
clean_volumes() {
    echo -e "${BLUE}🗑️  清理数据卷...${NC}"
    
    # 询问是否删除数据卷
    echo -e "${YELLOW}⚠️  这将删除所有数据，包括数据库数据！${NC}"
    read -p "是否删除数据卷？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker volume rm cultural-heritage-system_mysql_data cultural-heritage-system_redis_data 2>/dev/null || true
        echo -e "${GREEN}✅ 数据卷已删除${NC}"
    else
        echo -e "${BLUE}ℹ️  保留数据卷${NC}"
    fi
}

# 清理网络
clean_networks() {
    echo -e "${BLUE}🌐 清理网络...${NC}"
    
    docker network rm cultural-heritage-system_default 2>/dev/null || true
    echo -e "${GREEN}✅ 网络已清理${NC}"
}

# 清理上传文件
clean_uploads() {
    echo -e "${BLUE}📁 清理上传文件...${NC}"
    
    if [ -d "uploads" ]; then
        echo -e "${YELLOW}⚠️  这将删除所有上传的文件！${NC}"
        read -p "是否删除上传文件？(y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf uploads
            echo -e "${GREEN}✅ 上传文件已删除${NC}"
        else
            echo -e "${BLUE}ℹ️  保留上传文件${NC}"
        fi
    else
        echo -e "${BLUE}ℹ️  没有上传文件需要清理${NC}"
    fi
}

# 清理日志文件
clean_logs() {
    echo -e "${BLUE}📝 清理日志文件...${NC}"
    
    if [ -d "logs" ]; then
        rm -rf logs
        echo -e "${GREEN}✅ 日志文件已删除${NC}"
    else
        echo -e "${BLUE}ℹ️  没有日志文件需要清理${NC}"
    fi
}

# 显示清理结果
show_cleanup_result() {
    echo -e "\n${GREEN}🎉 卸载完成！${NC}"
    echo "=================================="
    echo -e "${BLUE}📊 清理结果：${NC}"
    echo "  • 服务已停止"
    echo "  • 容器已删除"
    echo "  • 镜像已删除"
    echo "  • 网络已清理"
    echo ""
    echo -e "${BLUE}💡 提示：${NC}"
    echo "  • 如需重新部署，请运行: ./deploy.sh"
    echo "  • 如需完全清理，请手动删除项目文件夹"
    echo ""
    echo -e "${GREEN}✨ 感谢使用文化遗产管理系统！${NC}"
}

# 主函数
main() {
    echo -e "${BLUE}开始卸载文化遗产管理系统...${NC}\n"
    
    stop_services
    clean_containers
    clean_volumes
    clean_networks
    clean_uploads
    clean_logs
    show_cleanup_result
}

# 错误处理
trap 'echo -e "${RED}❌ 卸载过程中出现错误！${NC}"; exit 1' ERR

# 执行主函数
main "$@"

