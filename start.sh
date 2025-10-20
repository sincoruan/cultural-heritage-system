#!/bin/bash

# 文化遗产管理与展示系统 - 快速启动脚本

echo "========================================="
echo "  文化遗产管理与展示系统 - 启动脚本"
echo "========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查MySQL是否运行
echo -n "检查MySQL服务... "
if command -v mysql &> /dev/null; then
    if pgrep -x "mysqld" > /dev/null; then
        echo -e "${GREEN}✓${NC} MySQL正在运行"
    else
        echo -e "${RED}✗${NC} MySQL未运行"
        echo "请先启动MySQL: sudo systemctl start mysql"
        exit 1
    fi
else
    echo -e "${RED}✗${NC} MySQL未安装"
    exit 1
fi

# 检查Redis是否运行
echo -n "检查Redis服务... "
if command -v redis-cli &> /dev/null; then
    if pgrep -x "redis-server" > /dev/null; then
        echo -e "${GREEN}✓${NC} Redis正在运行"
    else
        echo -e "${YELLOW}!${NC} Redis未运行，正在启动..."
        redis-server &
        sleep 2
    fi
else
    echo -e "${YELLOW}!${NC} Redis未安装，系统将使用降级模式"
fi

# 检查数据库是否初始化
echo -n "检查数据库... "
DB_EXISTS=$(mysql -u root -e "SHOW DATABASES LIKE 'cultural_heritage';" 2>/dev/null | grep "cultural_heritage")
if [ -z "$DB_EXISTS" ]; then
    echo -e "${YELLOW}!${NC} 数据库未初始化"
    echo ""
    echo "是否现在初始化数据库？(y/n)"
    read -r INIT_DB
    if [ "$INIT_DB" = "y" ]; then
        echo "正在初始化数据库..."
        mysql -u root -p < database/init.sql
        mysql -u root -p < database/sample_data.sql
        echo -e "${GREEN}✓${NC} 数据库初始化完成"
    else
        echo "请手动初始化数据库后再启动系统"
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} 数据库已就绪"
fi

echo ""
echo "========================================="
echo "  启动后端服务..."
echo "========================================="

# 检查后端jar包是否存在
if [ ! -f "backend/target/cultural-heritage-backend.jar" ]; then
    echo "后端jar包不存在，正在编译..."
    cd backend
    mvn clean package -DskipTests
    cd ..
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗${NC} 后端编译失败"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} 后端编译完成"
fi

# 启动后端
cd backend
echo "正在启动后端服务..."
java -jar target/cultural-heritage-backend.jar > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
cd ..

# 等待后端启动
echo -n "等待后端服务启动"
for i in {1..30}; do
    if curl -s http://localhost:8080/api/actuator/health > /dev/null 2>&1; then
        echo ""
        echo -e "${GREEN}✓${NC} 后端服务启动成功 (PID: $BACKEND_PID)"
        break
    fi
    echo -n "."
    sleep 1
    if [ $i -eq 30 ]; then
        echo ""
        echo -e "${RED}✗${NC} 后端服务启动超时"
        echo "请查看日志: tail -f logs/backend.log"
        exit 1
    fi
done

echo ""
echo "========================================="
echo "  启动前端服务..."
echo "========================================="

# 检查node_modules是否存在
if [ ! -d "frontend/node_modules" ]; then
    echo "正在安装前端依赖..."
    cd frontend
    npm install
    cd ..
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗${NC} 前端依赖安装失败"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} 前端依赖安装完成"
fi

# 启动前端
cd frontend
echo "正在启动前端服务..."
npm run dev > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..

# 等待前端启动
echo -n "等待前端服务启动"
for i in {1..30}; do
    if curl -s http://localhost:5173 > /dev/null 2>&1; then
        echo ""
        echo -e "${GREEN}✓${NC} 前端服务启动成功 (PID: $FRONTEND_PID)"
        break
    fi
    echo -n "."
    sleep 1
    if [ $i -eq 30 ]; then
        echo ""
        echo -e "${YELLOW}!${NC} 前端服务启动可能较慢，请稍候..."
    fi
done

echo ""
echo "========================================="
echo "  系统启动完成！"
echo "========================================="
echo ""
echo "访问地址:"
echo "  前端地址: ${GREEN}http://localhost:5173${NC}"
echo "  后端API:  ${GREEN}http://localhost:8080/api${NC}"
echo "  接口文档: ${GREEN}http://localhost:8080/api/doc.html${NC}"
echo ""
echo "默认账号:"
echo "  管理员: admin / admin123"
echo "  用户: user / user123"
echo ""
echo "进程信息:"
echo "  后端PID: $BACKEND_PID"
echo "  前端PID: $FRONTEND_PID"
echo ""
echo "查看日志:"
echo "  后端: tail -f logs/backend.log"
echo "  前端: tail -f logs/frontend.log"
echo ""
echo "停止服务:"
echo "  kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "========================================="

