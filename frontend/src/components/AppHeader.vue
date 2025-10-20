<template>
  <div class="app-header">
    <div class="header-container">
      <div class="logo">
        <router-link to="/home">
          <h2>文化遗产管理系统</h2>
        </router-link>
      </div>
      
      <nav class="nav-menu">
        <router-link to="/home" class="nav-item">首页</router-link>
        <router-link to="/heritage" class="nav-item">文化遗产</router-link>
        <router-link to="/multimedia" class="nav-item">多媒体展示</router-link>
        <router-link to="/notice" class="nav-item">公告通知</router-link>
        <router-link to="/interactive" class="nav-item" v-if="isAuthenticated">互动交流</router-link>
        <router-link to="/profile" class="nav-item" v-if="isAuthenticated">个人中心</router-link>
        <router-link to="/admin" class="nav-item" v-if="isAdmin">管理后台</router-link>
      </nav>
      
      <div class="user-actions">
        <template v-if="isAuthenticated">
          <el-dropdown>
            <span class="user-info">
              <el-icon><User /></el-icon>
              {{ getUserDisplayName() }}
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goToProfile">个人中心</el-dropdown-item>
                <el-dropdown-item @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
        <template v-else>
          <el-button @click="goToLogin">登录</el-button>
          <el-button type="primary" @click="goToRegister">注册</el-button>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const isAuthenticated = computed(() => userStore.isAuthenticated)
const isAdmin = computed(() => userStore.isAdmin)
const userInfo = computed(() => userStore.userInfo)

const goToLogin = () => {
  router.push('/login')
}

const goToRegister = () => {
  router.push('/register')
}

const goToProfile = () => {
  router.push('/profile')
}

const handleLogout = () => {
  userStore.logout()
  ElMessage.success('已退出登录')
  router.push('/home')
}

// 获取用户显示名称，处理乱码问题
const getUserDisplayName = () => {
  if (!userInfo.value) return ''
  
  const nickName = userInfo.value.nickName
  const userName = userInfo.value.userName
  
  // 检查昵称是否包含乱码字符
  if (nickName && !/[\u4e00-\u9fa5]/.test(nickName) && /[^\x00-\x7F]/.test(nickName)) {
    // 如果昵称包含非ASCII字符但不是中文，可能是乱码，使用用户名
    return userName
  }
  
  // 如果昵称是正常的中文或英文，使用昵称
  if (nickName && nickName.trim()) {
    return nickName
  }
  
  // 否则使用用户名
  return userName
}
</script>

<style scoped lang="scss">
.app-header {
  background: white;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 60px;
}

.logo {
  h2 {
    margin: 0;
    color: #409eff;
    font-size: 1.5rem;
    
    a {
      text-decoration: none;
      color: inherit;
    }
  }
}

.nav-menu {
  display: flex;
  gap: 30px;
  
  .nav-item {
    text-decoration: none;
    color: #333;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 4px;
    transition: all 0.3s ease;
    
    &:hover {
      background: #f5f7fa;
      color: #409eff;
    }
    
    &.router-link-active {
      background: #409eff;
      color: white;
    }
  }
}

.user-actions {
  display: flex;
  align-items: center;
  gap: 10px;
  
  .user-info {
    display: flex;
    align-items: center;
    gap: 5px;
    cursor: pointer;
    padding: 8px 12px;
    border-radius: 4px;
    transition: background 0.3s ease;
    
    &:hover {
      background: #f5f7fa;
    }
  }
}

@media (max-width: 768px) {
  .header-container {
    flex-direction: column;
    height: auto;
    padding: 10px 20px;
  }
  
  .nav-menu {
    margin: 10px 0;
    gap: 15px;
  }
}
</style>
