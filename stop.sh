#!/bin/bash

# 文化遗产管理与展示系统 - 停止脚本

echo "========================================="
echo "  文化遗产管理与展示系统 - 停止服务"
echo "========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 停止后端服务
echo -n "停止后端服务... "
BACKEND_PID=$(pgrep -f "cultural-heritage-backend.jar")
if [ -n "$BACKEND_PID" ]; then
    kill $BACKEND_PID
    sleep 2
    # 如果还在运行，强制终止
    if ps -p $BACKEND_PID > /dev/null; then
        kill -9 $BACKEND_PID
    fi
    echo -e "${GREEN}✓${NC} 后端服务已停止"
else
    echo -e "${YELLOW}!${NC} 后端服务未运行"
fi

# 停止前端服务
echo -n "停止前端服务... "
FRONTEND_PID=$(lsof -ti:5173)
if [ -n "$FRONTEND_PID" ]; then
    kill $FRONTEND_PID
    sleep 1
    # 如果还在运行，强制终止
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        kill -9 $FRONTEND_PID
    fi
    echo -e "${GREEN}✓${NC} 前端服务已停止"
else
    echo -e "${YELLOW}!${NC} 前端服务未运行"
fi

echo ""
echo "========================================="
echo "  所有服务已停止"
echo "========================================="

