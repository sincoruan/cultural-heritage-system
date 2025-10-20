# Docker使用说明

## 🐳 Docker方式启动项目

### 为什么使用Docker？

1. **环境一致性**：确保开发、测试、生产环境完全一致
2. **快速部署**：无需安装JDK、Node.js、MySQL、Redis等环境
3. **隔离性**：不污染本地环境，避免版本冲突
4. **可移植性**：在任何支持Docker的系统上都能运行
5. **一键启动**：所有服务自动启动和配置

### 前置要求

- Docker 20.0+
- Docker Compose 2.0+

### 安装Docker

#### macOS
```bash
# 使用Homebrew安装
brew install --cask docker

# 或下载Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### Windows
```bash
# 下载Docker Desktop
# https://www.docker.com/products/docker-desktop
```

#### Linux (Ubuntu)
```bash
# 安装Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 快速启动

#### 1. 一键启动（推荐）
```bash
# 进入项目目录
cd cultural-heritage-system

# 运行Docker启动脚本
./docker-start.sh
```

#### 2. 手动启动
```bash
# 构建并启动所有服务
docker-compose up --build -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 服务说明

| 服务 | 端口 | 说明 |
|------|------|------|
| MySQL | 3306 | 数据库服务 |
| Redis | 6379 | 缓存服务 |
| Backend | 8080 | SpringBoot后端API |
| Frontend | 5173 | Vue3前端应用 |
| Nginx | 80 | 反向代理（可选） |

### 访问地址

- **前端应用**: http://localhost:5173
- **后端API**: http://localhost:8080/api
- **接口文档**: http://localhost:8080/api/doc.html
- **MySQL数据库**: localhost:3306
- **Redis缓存**: localhost:6379

### 默认账号

- **系统管理员**: admin / admin123
- **平台管理员**: manager / manager123
- **普通用户**: user / user123

## 🔧 Docker命令

### 基本操作

```bash
# 启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 重启所有服务
docker-compose restart

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 服务管理

```bash
# 启动特定服务
docker-compose up -d mysql redis

# 停止特定服务
docker-compose stop backend

# 重启特定服务
docker-compose restart frontend

# 查看服务资源使用
docker stats
```

### 数据管理

```bash
# 备份数据库
docker-compose exec mysql mysqldump -u heritage_user -p cultural_heritage > backup.sql

# 恢复数据库
docker-compose exec -T mysql mysql -u heritage_user -p cultural_heritage < backup.sql

# 进入MySQL命令行
docker-compose exec mysql mysql -u heritage_user -p

# 进入Redis命令行
docker-compose exec redis redis-cli
```

### 开发调试

```bash
# 进入后端容器
docker-compose exec backend bash

# 进入前端容器
docker-compose exec frontend sh

# 查看容器内部文件
docker-compose exec backend ls -la /app

# 实时查看后端日志
docker-compose logs -f backend

# 实时查看前端日志
docker-compose logs -f frontend
```

## 🗂️ 数据持久化

### 数据卷说明

| 数据卷 | 说明 | 位置 |
|--------|------|------|
| mysql_data | MySQL数据 | /var/lib/mysql |
| redis_data | Redis数据 | /data |
| uploads | 上传文件 | ./uploads |

### 数据备份

```bash
# 备份MySQL数据
docker-compose exec mysql mysqldump -u heritage_user -p cultural_heritage > mysql_backup.sql

# 备份上传文件
tar -czf uploads_backup.tar.gz uploads/

# 备份Redis数据
docker-compose exec redis redis-cli --rdb /data/dump.rdb
```

### 数据恢复

```bash
# 恢复MySQL数据
docker-compose exec -T mysql mysql -u heritage_user -p cultural_heritage < mysql_backup.sql

# 恢复上传文件
tar -xzf uploads_backup.tar.gz

# 恢复Redis数据
docker-compose exec redis redis-cli --rdb /data/dump.rdb
```

## 🔍 故障排查

### 常见问题

#### 1. 端口冲突
```bash
# 检查端口占用
netstat -tlnp | grep :8080
netstat -tlnp | grep :5173

# 修改端口（编辑docker-compose.yml）
ports:
  - "8081:8080"  # 改为8081端口
```

#### 2. 服务启动失败
```bash
# 查看详细日志
docker-compose logs backend
docker-compose logs frontend

# 检查服务状态
docker-compose ps

# 重启服务
docker-compose restart backend
```

#### 3. 数据库连接失败
```bash
# 检查MySQL是否启动
docker-compose exec mysql mysql -u heritage_user -p

# 检查数据库是否存在
docker-compose exec mysql mysql -u heritage_user -p -e "SHOW DATABASES;"
```

#### 4. 前端无法访问后端
```bash
# 检查后端是否启动
curl http://localhost:8080/api/actuator/health

# 检查网络连接
docker-compose exec frontend ping backend
```

### 日志查看

```bash
# 查看所有服务日志
docker-compose logs

# 实时查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql
docker-compose logs -f redis

# 查看最近100行日志
docker-compose logs --tail=100 backend
```

## 🧹 清理操作

### 停止和清理

```bash
# 停止所有服务
docker-compose down

# 停止并删除数据卷（⚠️ 会删除所有数据）
docker-compose down -v

# 停止并删除镜像
docker-compose down --rmi all

# 清理未使用的资源
docker system prune

# 清理所有资源（⚠️ 危险操作）
docker system prune -a
```

### 重置项目

```bash
# 完全重置项目
docker-compose down -v
docker-compose up --build -d

# 重新初始化数据库
docker-compose exec mysql mysql -u heritage_user -p cultural_heritage < database/init.sql
docker-compose exec mysql mysql -u heritage_user -p cultural_heritage < database/sample_data.sql
```

## 📊 性能监控

### 资源使用情况

```bash
# 查看容器资源使用
docker stats

# 查看特定容器资源使用
docker stats heritage-backend heritage-frontend

# 查看磁盘使用
docker system df
```

### 健康检查

```bash
# 检查后端健康状态
curl http://localhost:8080/api/actuator/health

# 检查前端是否可访问
curl http://localhost:5173

# 检查数据库连接
docker-compose exec mysql mysql -u heritage_user -p -e "SELECT 1;"

# 检查Redis连接
docker-compose exec redis redis-cli ping
```

## 🚀 生产环境部署

### 生产环境配置

```bash
# 使用生产环境配置
docker-compose -f docker-compose.prod.yml up -d

# 设置环境变量
export MYSQL_PASSWORD=your_strong_password
export JWT_SECRET=your_jwt_secret_key
```

### 安全配置

```bash
# 修改默认密码
# 编辑 .env 文件
MYSQL_PASSWORD=your_strong_password
JWT_SECRET=your_jwt_secret_key

# 限制网络访问
# 编辑 docker-compose.yml，移除端口映射
```

## 📝 开发建议

### 开发环境

```bash
# 开发时使用热重载
docker-compose -f docker-compose.dev.yml up -d

# 查看实时日志
docker-compose logs -f backend frontend
```

### 调试技巧

```bash
# 进入容器调试
docker-compose exec backend bash
docker-compose exec frontend sh

# 查看容器内部文件
docker-compose exec backend ls -la /app
docker-compose exec frontend ls -la /app

# 修改代码后重启服务
docker-compose restart backend
```

## 🎯 总结

Docker方式启动项目的优势：

1. **简单易用**：一条命令启动所有服务
2. **环境隔离**：不污染本地环境
3. **一致性**：开发、测试、生产环境完全一致
4. **可移植性**：在任何支持Docker的系统上都能运行
5. **易于维护**：统一的服务管理和监控

推荐使用Docker方式启动项目，特别是对于：
- 新手开发者
- 不想安装复杂环境的用户
- 需要快速演示项目的场景
- 团队协作开发

---

**开始使用Docker启动项目吧！** 🚀

```bash
./docker-start.sh
```
