# 文化遗产管理与展示系统 - 部署文档

## 一、环境准备

### 1.1 服务器要求

- **操作系统**: Linux (Ubuntu 20.04+ / CentOS 7+) 或 Windows Server
- **CPU**: 2核及以上
- **内存**: 4GB及以上
- **磁盘**: 50GB及以上

### 1.2 软件环境

| 软件 | 版本要求 | 说明 |
|------|----------|------|
| JDK | 11+ | 后端运行环境 |
| MySQL | 8.0+ | 数据库 |
| Redis | 6.0+ | 缓存数据库 |
| Node.js | 16+ | 前端构建工具 |
| Nginx | 1.18+ | Web服务器（可选） |

## 二、环境安装

### 2.1 安装JDK 11

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install openjdk-11-jdk
java -version
```

**CentOS/RHEL**:
```bash
sudo yum install java-11-openjdk-devel
java -version
```

### 2.2 安装MySQL 8.0

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
sudo mysql_secure_installation
```

**CentOS/RHEL**:
```bash
sudo yum install mysql-server
sudo systemctl start mysqld
sudo systemctl enable mysqld
# 获取临时密码
sudo grep 'temporary password' /var/log/mysqld.log
# 修改密码
mysql_secure_installation
```

### 2.3 安装Redis

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install redis-server
sudo systemctl start redis
sudo systemctl enable redis
```

**CentOS/RHEL**:
```bash
sudo yum install redis
sudo systemctl start redis
sudo systemctl enable redis
```

### 2.4 安装Node.js

```bash
# 使用nvm安装
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 16
nvm use 16
node -v
npm -v
```

### 2.5 安装Nginx（可选）

**Ubuntu/Debian**:
```bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## 三、数据库配置

### 3.1 创建数据库

```bash
# 登录MySQL
mysql -u root -p

# 创建数据库
CREATE DATABASE cultural_heritage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 创建用户并授权
CREATE USER 'heritage_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON cultural_heritage.* TO 'heritage_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3.2 导入数据库脚本

```bash
cd cultural-heritage-system/database
mysql -u heritage_user -p cultural_heritage < init.sql
mysql -u heritage_user -p cultural_heritage < sample_data.sql
```

### 3.3 配置Redis

编辑 `/etc/redis/redis.conf`:

```bash
# 设置密码（可选）
requirepass your_redis_password

# 允许远程访问（可选，注意安全）
# bind 0.0.0.0

# 设置最大内存
maxmemory 256mb
maxmemory-policy allkeys-lru

# 持久化配置
save 900 1
save 300 10
save 60 10000
```

重启Redis:
```bash
sudo systemctl restart redis
```

## 四、后端部署

### 4.1 修改配置文件

编辑 `backend/src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/cultural_heritage?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=Asia/Shanghai
    username: heritage_user
    password: your_password
  
  redis:
    host: localhost
    port: 6379
    password: your_redis_password

jwt:
  secret: your_jwt_secret_key_at_least_256_bits
  
file:
  upload:
    base-path: /var/www/uploads/
```

### 4.2 编译打包

```bash
cd backend
mvn clean package -DskipTests
```

生成的jar包位于 `backend/target/cultural-heritage-backend.jar`

### 4.3 创建上传目录

```bash
sudo mkdir -p /var/www/uploads
sudo chown -R $USER:$USER /var/www/uploads
sudo chmod -R 755 /var/www/uploads
```

### 4.4 创建系统服务

创建文件 `/etc/systemd/system/heritage-backend.service`:

```ini
[Unit]
Description=Cultural Heritage Backend Service
After=network.target mysql.service redis.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/heritage/backend
ExecStart=/usr/bin/java -jar /opt/heritage/backend/cultural-heritage-backend.jar
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

部署jar包:
```bash
sudo mkdir -p /opt/heritage/backend
sudo cp backend/target/cultural-heritage-backend.jar /opt/heritage/backend/
sudo chown -R www-data:www-data /opt/heritage
```

启动服务:
```bash
sudo systemctl daemon-reload
sudo systemctl start heritage-backend
sudo systemctl enable heritage-backend
sudo systemctl status heritage-backend
```

查看日志:
```bash
sudo journalctl -u heritage-backend -f
```

## 五、前端部署

### 5.1 修改配置

创建 `frontend/.env.production`:

```bash
VITE_API_BASE_URL=http://your-domain.com/api
```

### 5.2 构建前端

```bash
cd frontend
npm install
npm run build
```

生成的文件位于 `frontend/dist`

### 5.3 部署到Nginx

```bash
# 复制构建文件
sudo mkdir -p /var/www/heritage
sudo cp -r frontend/dist/* /var/www/heritage/
sudo chown -R www-data:www-data /var/www/heritage
```

创建Nginx配置文件 `/etc/nginx/sites-available/heritage`:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态文件
    location / {
        root /var/www/heritage;
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # 后端API代理
    location /api/ {
        proxy_pass http://localhost:8080/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket支持（如果需要）
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # 上传文件访问
    location /uploads/ {
        alias /var/www/uploads/;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }

    # Gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
}
```

启用站点并重启Nginx:
```bash
sudo ln -s /etc/nginx/sites-available/heritage /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## 六、HTTPS配置（推荐）

### 6.1 使用Let's Encrypt免费证书

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
sudo systemctl reload nginx
```

### 6.2 自动续期

Certbot会自动配置续期，也可以手动测试:
```bash
sudo certbot renew --dry-run
```

## 七、安全加固

### 7.1 防火墙配置

```bash
# Ubuntu UFW
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 7.2 MySQL安全配置

```sql
-- 删除匿名用户
DELETE FROM mysql.user WHERE User='';

-- 禁止root远程登录
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- 刷新权限
FLUSH PRIVILEGES;
```

### 7.3 Redis安全配置

```bash
# 编辑 /etc/redis/redis.conf
requirepass strong_password
bind 127.0.0.1
protected-mode yes
```

## 八、备份策略

### 8.1 数据库备份

创建备份脚本 `/opt/heritage/backup.sh`:

```bash
#!/bin/bash
BACKUP_DIR="/opt/heritage/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="cultural_heritage"
DB_USER="heritage_user"
DB_PASS="your_password"

mkdir -p $BACKUP_DIR

# 备份数据库
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/db_$DATE.sql.gz

# 备份上传文件
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz /var/www/uploads

# 删除7天前的备份
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

设置定时任务:
```bash
chmod +x /opt/heritage/backup.sh
crontab -e

# 每天凌晨2点执行备份
0 2 * * * /opt/heritage/backup.sh >> /var/log/heritage_backup.log 2>&1
```

### 8.2 恢复备份

```bash
# 恢复数据库
gunzip < db_backup.sql.gz | mysql -u heritage_user -p cultural_heritage

# 恢复上传文件
tar -xzf uploads_backup.tar.gz -C /
```

## 九、监控与日志

### 9.1 查看后端日志

```bash
# 查看服务日志
sudo journalctl -u heritage-backend -f

# 查看应用日志
tail -f /opt/heritage/backend/logs/heritage-system.log
```

### 9.2 查看Nginx日志

```bash
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### 9.3 系统监控

安装监控工具:
```bash
sudo apt install htop iotop nethogs
```

## 十、常见问题

### 10.1 后端无法启动

- 检查Java版本: `java -version`
- 检查端口占用: `netstat -tlnp | grep 8080`
- 查看日志: `sudo journalctl -u heritage-backend -n 100`

### 10.2 数据库连接失败

- 检查MySQL状态: `sudo systemctl status mysql`
- 测试连接: `mysql -u heritage_user -p`
- 检查防火墙规则

### 10.3 文件上传失败

- 检查目录权限: `ls -la /var/www/uploads`
- 检查磁盘空间: `df -h`
- 检查Nginx配置中的client_max_body_size

### 10.4 Redis连接失败

- 检查Redis状态: `sudo systemctl status redis`
- 测试连接: `redis-cli ping`
- 检查配置文件中的密码设置

## 十一、性能优化

### 11.1 JVM参数优化

修改 `/etc/systemd/system/heritage-backend.service`:

```ini
ExecStart=/usr/bin/java -Xms512m -Xmx1024m -XX:+UseG1GC -jar /opt/heritage/backend/cultural-heritage-backend.jar
```

### 11.2 MySQL优化

编辑 `/etc/mysql/mysql.conf.d/mysqld.cnf`:

```ini
[mysqld]
max_connections = 200
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
query_cache_size = 0
```

### 11.3 Nginx优化

```nginx
worker_processes auto;
worker_connections 2048;

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 50M;
}
```

## 十二、更新部署

### 12.1 后端更新

```bash
# 停止服务
sudo systemctl stop heritage-backend

# 备份当前版本
sudo cp /opt/heritage/backend/cultural-heritage-backend.jar /opt/heritage/backend/cultural-heritage-backend.jar.bak

# 部署新版本
sudo cp backend/target/cultural-heritage-backend.jar /opt/heritage/backend/

# 启动服务
sudo systemctl start heritage-backend

# 检查状态
sudo systemctl status heritage-backend
```

### 12.2 前端更新

```bash
# 构建新版本
cd frontend
npm run build

# 备份当前版本
sudo mv /var/www/heritage /var/www/heritage.bak

# 部署新版本
sudo mkdir /var/www/heritage
sudo cp -r dist/* /var/www/heritage/
sudo chown -R www-data:www-data /var/www/heritage

# 清除Nginx缓存
sudo systemctl reload nginx
```

## 十三、联系方式

如遇到部署问题，请联系技术支持。

---

**注意**: 请根据实际情况修改文档中的域名、密码等信息。

