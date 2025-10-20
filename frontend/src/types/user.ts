/**
 * 用户相关类型定义
 */

export interface LoginRequest {
  userName: string
  password: string
  captcha?: string
  captchaKey?: string
}

export interface RegisterRequest {
  userName: string
  password: string
  confirmPassword: string
  nickName: string
  email?: string
  phoneNumber?: string
  captcha?: string
  captchaKey?: string
}

export interface UserInfo {
  userId: number
  userName: string
  nickName: string
  email?: string
  phoneNumber?: string
  sex?: string
  avatar?: string
  roles: string[]
  createTime?: string
}

export interface LoginResponse {
  token: string
  tokenType: string
  userInfo: UserInfo
}

