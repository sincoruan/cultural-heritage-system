# Docker故障排除指南

## 🚨 常见错误及解决方案

### 1. Maven包装器错误

**错误信息：**
```
target backend: failed to solve: failed to compute cache key: failed to calculate checksum of ref stqc5lcjktnsfbrk85f1jynr5::n1dbt3gfrn24zr76c9tchtfxz: "/.mvn": not found
```

**原因：** Dockerfile中引用了不存在的`.mvn`目录

**解决方案：** 已修复，使用多阶段构建

### 2. 端口冲突

**错误信息：**
```
Error starting userland proxy: listen tcp 0.0.0.0:8080: bind: address already in use
```

**解决方案：**
```bash
# 检查端口占用
lsof -i :8080
lsof -i :5173
lsof -i :3306
lsof -i :6379

# 停止占用端口的进程
sudo kill -9 <PID>

# 或修改端口
# 编辑 docker-compose.simple.yml
ports:
  - "8081:8080"  # 改为8081端口
```

### 3. 数据库连接失败

**错误信息：**
```
Connection refused: no further information
```

**解决方案：**
```bash
# 检查MySQL容器状态
docker-compose -f docker-compose.simple.yml ps mysql

# 查看MySQL日志
docker-compose -f docker-compose.simple.yml logs mysql

# 重启MySQL
docker-compose -f docker-compose.simple.yml restart mysql
```

### 4. 前端构建失败

**错误信息：**
```
npm ERR! code ENOENT
npm ERR! syscall open
npm ERR! path /app/package.json
```

**解决方案：**
```bash
# 清理Docker缓存
docker system prune -a

# 重新构建
docker-compose -f docker-compose.simple.yml build --no-cache frontend
```

### 5. 权限问题

**错误信息：**
```
Permission denied: '/app/uploads'
```

**解决方案：**
```bash
# 创建上传目录并设置权限
mkdir -p uploads
chmod 755 uploads

# 或修改Dockerfile中的权限设置
```

## 🔧 调试命令

### 查看容器状态
```bash
# 查看所有容器
docker-compose -f docker-compose.simple.yml ps

# 查看特定容器日志
docker-compose -f docker-compose.simple.yml logs backend
docker-compose -f docker-compose.simple.yml logs frontend
docker-compose -f docker-compose.simple.yml logs mysql
docker-compose -f docker-compose.simple.yml logs redis
```

### 进入容器调试
```bash
# 进入后端容器
docker-compose -f docker-compose.simple.yml exec backend bash

# 进入前端容器
docker-compose -f docker-compose.simple.yml exec frontend sh

# 进入MySQL容器
docker-compose -f docker-compose.simple.yml exec mysql bash
```

### 检查网络连接
```bash
# 检查容器间网络
docker-compose -f docker-compose.simple.yml exec backend ping mysql
docker-compose -f docker-compose.simple.yml exec backend ping redis

# 检查端口映射
docker port heritage-backend
docker port heritage-frontend
```

## 🧹 清理和重置

### 完全重置
```bash
# 停止并删除所有容器
docker-compose -f docker-compose.simple.yml down -v

# 删除所有镜像
docker-compose -f docker-compose.simple.yml down --rmi all

# 清理Docker系统
docker system prune -a

# 重新启动
./docker-start.sh
```

### 部分重置
```bash
# 只重新构建后端
docker-compose -f docker-compose.simple.yml build --no-cache backend
docker-compose -f docker-compose.simple.yml up -d backend

# 只重新构建前端
docker-compose -f docker-compose.simple.yml build --no-cache frontend
docker-compose -f docker-compose.simple.yml up -d frontend
```

## 📊 性能优化

### 减少构建时间
```bash
# 使用Docker缓存
docker-compose -f docker-compose.simple.yml build

# 并行构建
docker-compose -f docker-compose.simple.yml build --parallel
```

### 监控资源使用
```bash
# 查看资源使用情况
docker stats

# 查看特定容器资源使用
docker stats heritage-backend heritage-frontend
```

## 🚀 生产环境建议

### 安全配置
```bash
# 修改默认密码
# 编辑 .env 文件
MYSQL_PASSWORD=your_strong_password
JWT_SECRET=your_jwt_secret_key
```

### 数据备份
```bash
# 备份数据库
docker-compose -f docker-compose.simple.yml exec mysql mysqldump -u heritage_user -p cultural_heritage > backup.sql

# 备份上传文件
tar -czf uploads_backup.tar.gz uploads/
```

### 日志管理
```bash
# 限制日志大小
# 在docker-compose.simple.yml中添加：
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

## 📝 最佳实践

1. **定期清理**：定期运行 `docker system prune` 清理未使用的资源
2. **监控日志**：定期查看容器日志，及时发现问题
3. **备份数据**：定期备份数据库和上传文件
4. **版本控制**：使用Git管理Docker配置文件
5. **环境隔离**：开发、测试、生产环境使用不同的配置文件

## 🆘 获取帮助

如果遇到其他问题：

1. 查看详细日志：`docker-compose -f docker-compose.simple.yml logs -f`
2. 检查容器状态：`docker-compose -f docker-compose.simple.yml ps`
3. 查看资源使用：`docker stats`
4. 清理并重试：`./docker-stop.sh && ./docker-start.sh`

---

**记住：大多数问题都可以通过清理和重新构建来解决！** 🛠️
