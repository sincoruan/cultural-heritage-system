# 文化遗产管理与展示系统

## 📖 项目简介

这是一个基于SpringBoot + Vue3的文化遗产管理与展示系统，支持文化遗产的数字化管理、多媒体展示、用户互动等功能。

## ✨ 主要功能

- 🏛️ **文化遗产管理**: 文化遗产信息的增删改查
- 🖼️ **多媒体展示**: 支持图片、视频、3D模型、全景展示
- 👥 **用户管理**: 用户注册、登录、角色权限管理
- 💬 **互动功能**: 评论、点赞、收藏功能
- 📊 **系统监控**: 实时监控系统状态和性能
- 📢 **公告管理**: 系统公告发布和管理

## 🚀 快速开始

### 方式一：一键部署（推荐）

```bash
# 1. 给脚本执行权限
chmod +x deploy.sh

# 2. 运行一键部署脚本
./deploy.sh
```

### 方式二：手动部署

```bash
# 1. 启动所有服务
docker-compose -f docker-compose.simple.yml up -d

# 2. 等待服务启动（约1-2分钟）
# 3. 访问系统
```

## 🌐 访问地址

- **前端系统**: http://localhost:5173
- **后端API**: http://localhost:8080/api

## 👤 默认账户

| 角色 | 用户名 | 密码 | 说明 |
|------|--------|------|------|
| 系统管理员 | admin | admin123 | 拥有所有权限 |
| 普通用户 | user1 | user123 | 基础功能权限 |

## 📋 系统要求

- **操作系统**: Windows 10+, macOS 10.14+, Ubuntu 18.04+
- **内存**: 建议8GB以上
- **磁盘**: 建议10GB以上可用空间
- **Docker**: Docker Desktop 或 Docker Engine
- **Docker Compose**: 版本2.0+

## 🛠️ 技术栈

### 后端
- **框架**: Spring Boot 2.7+
- **数据库**: MySQL 8.0
- **缓存**: Redis 6.0
- **安全**: Spring Security + JWT
- **构建**: Maven

### 前端
- **框架**: Vue 3
- **UI库**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router
- **构建**: Vite

### 部署
- **容器化**: Docker + Docker Compose
- **反向代理**: Nginx
- **进程管理**: Docker

## 📁 项目结构

```
cultural-heritage-system/
├── backend/                 # 后端代码
│   ├── src/main/java/      # Java源码
│   ├── src/main/resources/ # 配置文件
│   └── Dockerfile          # 后端Docker配置
├── frontend/               # 前端代码
│   ├── src/                # Vue源码
│   ├── public/             # 静态资源
│   └── Dockerfile          # 前端Docker配置
├── database/               # 数据库脚本
├── docker-compose.simple.yml # Docker编排文件
├── deploy.sh              # 一键部署脚本
└── README.md              # 项目说明
```

## 🔧 常用命令

### 服务管理
```bash
# 查看服务状态
docker-compose -f docker-compose.simple.yml ps

# 查看服务日志
docker-compose -f docker-compose.simple.yml logs

# 重启服务
docker-compose -f docker-compose.simple.yml restart

# 停止服务
docker-compose -f docker-compose.simple.yml down

# 重新构建并启动
docker-compose -f docker-compose.simple.yml up -d --build
```

### 数据库管理
```bash
# 连接数据库
docker-compose -f docker-compose.simple.yml exec mysql mysql -u heritage_user -p cultural_heritage

# 备份数据库
docker-compose -f docker-compose.simple.yml exec mysql mysqldump -u heritage_user -p cultural_heritage > backup.sql
```

## 🐛 故障排除

### 常见问题

#### 1. 端口被占用
```bash
# 检查端口占用
netstat -tulpn | grep :5173
netstat -tulpn | grep :8080

# 修改端口（编辑docker-compose.simple.yml）
```

#### 2. 服务启动失败
```bash
# 查看详细日志
docker-compose -f docker-compose.simple.yml logs backend
docker-compose -f docker-compose.simple.yml logs frontend
```

#### 3. 数据库连接失败
```bash
# 重启数据库
docker-compose -f docker-compose.simple.yml restart mysql

# 检查数据库状态
docker-compose -f docker-compose.simple.yml logs mysql
```

#### 4. 前端无法访问
```bash
# 重启前端服务
docker-compose -f docker-compose.simple.yml restart frontend

# 检查Nginx配置
docker-compose -f docker-compose.simple.yml exec frontend nginx -t
```

## 📦 项目打包

### 创建部署包
```bash
# 创建压缩包（排除不必要的文件）
tar -czf cultural-heritage-system.tar.gz \
  --exclude=node_modules \
  --exclude=target \
  --exclude=.git \
  --exclude=*.log \
  cultural-heritage-system/
```

### 分发部署
1. 将项目文件夹或压缩包发送给其他人
2. 接收方解压并运行 `./deploy.sh`
3. 等待部署完成即可使用

## 🔄 更新升级

```bash
# 1. 停止服务
docker-compose -f docker-compose.simple.yml down

# 2. 更新代码
git pull  # 或替换项目文件

# 3. 重新构建并启动
docker-compose -f docker-compose.simple.yml up -d --build
```

## 📞 技术支持

如果遇到问题，请提供以下信息：
- 操作系统版本
- Docker版本
- 错误日志
- 具体操作步骤

## 📄 许可证

本项目采用 MIT 许可证，详见 LICENSE 文件。

---

**🎉 感谢使用文化遗产管理与展示系统！**