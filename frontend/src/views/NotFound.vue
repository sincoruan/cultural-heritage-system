<template>
  <div class="not-found">
    <div class="not-found-content">
      <h1>404</h1>
      <h2>页面未找到</h2>
      <p>抱歉，您访问的页面不存在</p>
      <el-button type="primary" @click="goHome">返回首页</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}
</script>

<style scoped lang="scss">
.not-found {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: #f5f5f5;
}

.not-found-content {
  text-align: center;
  
  h1 {
    font-size: 6rem;
    color: #409eff;
    margin-bottom: 20px;
  }
  
  h2 {
    font-size: 2rem;
    color: #333;
    margin-bottom: 20px;
  }
  
  p {
    font-size: 1.1rem;
    color: #666;
    margin-bottom: 40px;
  }
}
</style>
