#!/bin/bash

# 文化遗产管理系统 - 快速停止脚本
# 使用方法: chmod +x stop.sh && ./stop.sh

echo "🛑 停止文化遗产管理系统..."

# 停止所有服务
docker-compose -f docker-compose.simple.yml down

echo "✅ 服务已停止"
echo "💡 如需完全卸载，请运行: ./undeploy.sh"