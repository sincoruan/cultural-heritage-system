<template>
  <div class="forbidden">
    <div class="forbidden-content">
      <h1>403</h1>
      <h2>访问被拒绝</h2>
      <p>抱歉，您没有权限访问此页面</p>
      <p>此页面需要管理员权限</p>
      <div class="actions">
        <el-button type="primary" @click="goHome">返回首页</el-button>
        <el-button @click="goLogin">去登录</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}

const goLogin = () => {
  router.push('/login')
}
</script>

<style scoped lang="scss">
.forbidden {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f5f7fa;
}

.forbidden-content {
  text-align: center;
  padding: 40px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  
  h1 {
    font-size: 6rem;
    color: #f56c6c;
    margin: 0;
  }
  
  h2 {
    font-size: 2rem;
    color: #333;
    margin: 20px 0;
  }
  
  p {
    color: #666;
    margin: 10px 0;
    font-size: 1.1rem;
  }
  
  .actions {
    margin-top: 30px;
    display: flex;
    gap: 15px;
    justify-content: center;
  }
}
</style>
