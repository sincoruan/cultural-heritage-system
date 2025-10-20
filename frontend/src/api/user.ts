import request from '@/utils/request'

// 用户接口类型定义
export interface User {
  userId?: number
  userName: string
  nickName: string
  email: string
  phoneNumber?: string
  password?: string
  roles?: string[]
  status?: string
  createTime?: string
  updateTime?: string
}

export interface LoginRequest {
  userName: string
  password: string
}

export interface RegisterRequest {
  userName: string
  nickName: string
  email: string
  password: string
  phoneNumber?: string
}

export interface LoginResponse {
  token: string
  tokenType: string
  userInfo: User
}

/**
 * 用户登录
 */
export function login(data: LoginRequest) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

/**
 * 用户注册
 */
export function register(data: RegisterRequest) {
  return request({
    url: '/auth/register',
    method: 'post',
    data
  })
}

/**
 * 获取用户信息
 */
export function getUserInfo() {
  return request({
    url: '/auth/userinfo',
    method: 'get'
  })
}

export interface UserListParams {
  page: number
  size: number
  keyword?: string
  userType?: string
}

/**
 * 获取用户列表
 */
export function getUserList(params: UserListParams) {
  return request({
    url: '/admin/user/list',
    method: 'get',
    params
  })
}

/**
 * 获取用户详情
 */
export function getUserDetail(userId: number) {
  return request({
    url: `/admin/user/${userId}`,
    method: 'get'
  })
}

/**
 * 创建用户
 */
export function createUser(user: User) {
  return request({
    url: '/admin/user/create',
    method: 'post',
    data: user
  })
}

/**
 * 更新用户
 */
export function updateUser(user: User) {
  return request({
    url: `/admin/user/${user.userId}`,
    method: 'put',
    data: user
  })
}

/**
 * 删除用户
 */
export function deleteUser(userId: number) {
  return request({
    url: `/admin/user/${userId}`,
    method: 'delete'
  })
}

/**
 * 重置用户密码
 */
export function resetUserPassword(userId: number) {
  return request({
    url: `/admin/user/${userId}/reset-password`,
    method: 'post'
  })
}

/**
 * 切换用户状态
 */
export function toggleUserStatus(userId: number) {
  return request({
    url: `/admin/user/${userId}/toggle-status`,
    method: 'post'
  })
}

/**
 * 批量删除用户
 */
export function batchDeleteUsers(userIds: number[]) {
  return request({
    url: '/admin/user/batch-delete',
    method: 'post',
    data: { userIds }
  })
}

/**
 * 导出用户数据
 */
export function exportUsers(params: any) {
  return request({
    url: '/admin/user/export',
    method: 'get',
    params,
    responseType: 'blob'
  })
}

/**
 * 导入用户数据
 */
export function importUsers(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  
  return request({
    url: '/admin/user/import',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}