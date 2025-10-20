import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as loginApi, register as registerApi, getUserInfo } from '@/api/user'
import type { LoginRequest, RegisterRequest } from '@/types/user'

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref<string>(localStorage.getItem('token') || '')
  const userInfo = ref<any>(null)

  // 计算属性
  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => {
    if (!userInfo.value) return false
    const roles = userInfo.value.roles || []
    // 检查角色代码：00=系统管理员，01=平台管理员
    return roles.includes('00') || roles.includes('01') || roles.includes('admin') || roles.includes('manager')
  })

  // 登录
  const login = async (data: LoginRequest) => {
    try {
      const res = await loginApi(data)
      if (res.code === 200) {
        token.value = res.data.token
        userInfo.value = res.data.userInfo
        localStorage.setItem('token', res.data.token)
        localStorage.setItem('userInfo', JSON.stringify(res.data.userInfo))
        return res
      }
      throw new Error(res.message)
    } catch (error) {
      throw error
    }
  }

  // 注册
  const register = async (data: RegisterRequest) => {
    try {
      const res = await registerApi(data)
      return res
    } catch (error) {
      throw error
    }
  }

  // 登出
  const logout = () => {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
  }

  // 获取用户信息
  const loadUserInfo = async () => {
    try {
      const res = await getUserInfo()
      if (res.code === 200) {
        userInfo.value = res.data
        localStorage.setItem('userInfo', JSON.stringify(res.data))
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
    }
  }

  // 初始化用户信息
  const initUserInfo = () => {
    const savedUserInfo = localStorage.getItem('userInfo')
    if (savedUserInfo) {
      try {
        userInfo.value = JSON.parse(savedUserInfo)
      } catch (error) {
        console.error('解析用户信息失败:', error)
      }
    }
  }

  // 初始化
  initUserInfo()

  return {
    token,
    userInfo,
    isAuthenticated,
    isAdmin,
    login,
    register,
    logout,
    loadUserInfo,
  }
})

