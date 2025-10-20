# 文化遗产管理与展示系统 - API接口文档

## 基本信息

- **Base URL**: `http://localhost:8080/api`
- **Content-Type**: `application/json`
- **Authorization**: `Bearer {token}` (除登录注册接口外,其他接口需要在Header中携带Token)

## 响应格式

所有接口统一返回格式：

```json
{
  "code": 200,
  "message": "操作成功",
  "data": {},
  "timestamp": 1234567890
}
```

状态码说明：
- 200: 成功
- 400: 请求参数错误
- 401: 未授权
- 403: 禁止访问
- 404: 资源未找到
- 500: 服务器内部错误

## 一、认证接口

### 1.1 用户注册

**接口地址**: `POST /auth/register`

**请求参数**:
```json
{
  "userName": "testuser",
  "password": "123456",
  "confirmPassword": "123456",
  "nickName": "测试用户",
  "email": "test@example.com",
  "phoneNumber": "13800138000"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "注册成功",
  "data": null,
  "timestamp": 1234567890
}
```

### 1.2 用户登录

**接口地址**: `POST /auth/login`

**请求参数**:
```json
{
  "userName": "testuser",
  "password": "123456"
}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzUxMiJ9...",
    "tokenType": "Bearer",
    "userInfo": {
      "userId": 1,
      "userName": "testuser",
      "nickName": "测试用户",
      "email": "test@example.com",
      "phoneNumber": "13800138000",
      "avatar": "",
      "roles": ["user"]
    }
  },
  "timestamp": 1234567890
}
```

### 1.3 获取验证码

**接口地址**: `GET /auth/captcha`

**响应示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "captchaKey": "uuid-key",
    "captchaImage": "data:image/png;base64,..."
  },
  "timestamp": 1234567890
}
```

## 二、用户接口

### 2.1 获取当前用户信息

**接口地址**: `GET /user/info`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "userId": 1,
    "userName": "testuser",
    "nickName": "测试用户",
    "email": "test@example.com",
    "phoneNumber": "13800138000",
    "avatar": "/uploads/avatar/user1.jpg",
    "roles": ["user"],
    "createTime": "2024-01-01 12:00:00"
  },
  "timestamp": 1234567890
}
```

### 2.2 更新用户信息

**接口地址**: `PUT /user/update`

**请求参数**:
```json
{
  "nickName": "新昵称",
  "email": "newemail@example.com",
  "phoneNumber": "13900139000"
}
```

### 2.3 修改密码

**接口地址**: `PUT /user/change-password`

**请求参数**:
```json
{
  "oldPassword": "123456",
  "newPassword": "654321"
}
```

## 三、文化遗产接口

### 3.1 获取文化遗产列表

**接口地址**: `GET /heritage/list`

**请求参数**:
- page: 页码（从1开始）
- size: 每页数量
- keyword: 搜索关键词（可选）
- category: 分类（可选）
- era: 年代（可选）
- location: 地点（可选）

**响应示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "records": [
      {
        "heritageId": 1,
        "heritageName": "故宫博物院",
        "category": "古建筑",
        "description": "故宫博物院位于北京市中心...",
        "era": "明清",
        "location": "北京市东城区",
        "protectionLevel": "世界文化遗产",
        "viewCount": 15280,
        "likeCount": 8520,
        "collectCount": 3200,
        "commentCount": 156,
        "createTime": "2024-01-01 12:00:00"
      }
    ],
    "total": 100,
    "current": 1,
    "size": 10,
    "pages": 10
  },
  "timestamp": 1234567890
}
```

### 3.2 获取文化遗产详情

**接口地址**: `GET /heritage/{id}`

**响应示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "heritageId": 1,
    "heritageName": "故宫博物院",
    "category": "古建筑",
    "description": "故宫博物院位于北京市中心...",
    "era": "明清",
    "location": "北京市东城区",
    "protectionLevel": "世界文化遗产",
    "viewCount": 15280,
    "likeCount": 8520,
    "collectCount": 3200,
    "commentCount": 156,
    "mediaList": [
      {
        "mediaId": 1,
        "mediaType": "image",
        "mediaUrl": "/uploads/heritage/gugong_01.jpg",
        "mediaName": "故宫全景图"
      }
    ],
    "createTime": "2024-01-01 12:00:00"
  },
  "timestamp": 1234567890
}
```

### 3.3 添加文化遗产（需要管理员权限）

**接口地址**: `POST /heritage/add`

**请求参数**:
```json
{
  "heritageName": "新文化遗产",
  "category": "古建筑",
  "description": "详细描述...",
  "era": "明清",
  "location": "北京市",
  "protectionLevel": "国家级"
}
```

### 3.4 更新文化遗产（需要管理员权限）

**接口地址**: `PUT /heritage/update/{id}`

**请求参数**: 同添加接口

### 3.5 删除文化遗产（需要管理员权限）

**接口地址**: `DELETE /heritage/delete/{id}`

### 3.6 增加浏览量

**接口地址**: `POST /heritage/{id}/view`

## 四、多媒体资源接口

### 4.1 上传媒体文件

**接口地址**: `POST /media/upload`

**请求类型**: `multipart/form-data`

**请求参数**:
- file: 文件
- heritageId: 文化遗产ID
- mediaType: 媒体类型（image/video/3d）

### 4.2 获取媒体列表

**接口地址**: `GET /media/list/{heritageId}`

## 五、评论接口

### 5.1 获取评论列表

**接口地址**: `GET /comment/list/{heritageId}`

**请求参数**:
- page: 页码
- size: 每页数量

### 5.2 添加评论

**接口地址**: `POST /comment/add`

**请求参数**:
```json
{
  "heritageId": 1,
  "content": "评论内容",
  "parentId": null
}
```

### 5.3 删除评论

**接口地址**: `DELETE /comment/delete/{id}`

## 六、点赞接口

### 6.1 切换点赞状态

**接口地址**: `POST /like/toggle`

**请求参数**:
```json
{
  "targetId": 1,
  "targetType": "heritage"
}
```

### 6.2 检查点赞状态

**接口地址**: `GET /like/check`

**请求参数**:
- targetId: 目标ID
- targetType: 目标类型（heritage/comment）

## 七、收藏接口

### 7.1 切换收藏状态

**接口地址**: `POST /collect/toggle`

**请求参数**:
```json
{
  "heritageId": 1
}
```

### 7.2 获取我的收藏列表

**接口地址**: `GET /collect/my-list`

**请求参数**:
- page: 页码
- size: 每页数量

## 八、公告接口

### 8.1 获取公告列表

**接口地址**: `GET /notice/list`

**请求参数**:
- page: 页码
- size: 每页数量
- status: 状态（可选）

### 8.2 获取公告详情

**接口地址**: `GET /notice/{id}`

### 8.3 添加公告（需要管理员权限）

**接口地址**: `POST /notice/add`

**请求参数**:
```json
{
  "noticeTitle": "公告标题",
  "noticeType": "1",
  "noticeContent": "公告内容"
}
```

## 九、系统监控接口（需要管理员权限）

### 9.1 获取系统统计数据

**接口地址**: `GET /monitor/stats`

**响应示例**:
```json
{
  "code": 200,
  "message": "获取成功",
  "data": {
    "userCount": 1000,
    "heritageCount": 200,
    "commentCount": 5000,
    "viewCount": 50000
  },
  "timestamp": 1234567890
}
```

### 9.2 获取在线用户列表

**接口地址**: `GET /monitor/online-users`

## 十、搜索日志接口

### 10.1 记录搜索日志

**接口地址**: `POST /search/log`

**请求参数**:
```json
{
  "searchKeyword": "故宫",
  "searchType": "heritage"
}
```

### 10.2 获取热门搜索词

**接口地址**: `GET /search/hot-keywords`

---

## 错误码说明

| 错误码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权，需要登录 |
| 403 | 禁止访问，权限不足 |
| 404 | 资源未找到 |
| 500 | 服务器内部错误 |

## 注意事项

1. 所有时间格式统一为：`yyyy-MM-dd HH:mm:ss`
2. 分页参数 page 从 1 开始
3. 文件上传大小限制为 50MB
4. Token 有效期为 7 天
5. 需要管理员权限的接口，普通用户调用会返回 403

