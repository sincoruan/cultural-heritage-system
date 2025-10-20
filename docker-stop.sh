#!/bin/bash

# 文化遗产管理与展示系统 - Docker停止脚本

echo "========================================="
echo "  文化遗产管理与展示系统 - Docker停止"
echo "========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 停止所有服务
echo "停止所有Docker服务..."
docker-compose -f docker-compose.simple.yml down

echo ""
echo "========================================="
echo "  所有Docker服务已停止"
echo "========================================="

# 显示容器状态
echo "当前容器状态:"
docker-compose -f docker-compose.simple.yml ps

echo ""
echo "如需完全清理，请运行:"
echo "  docker-compose down -v  # 删除数据卷"
echo "  docker system prune     # 清理未使用的镜像和容器"
