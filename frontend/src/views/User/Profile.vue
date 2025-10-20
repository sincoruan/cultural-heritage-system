<template>
  <div class="profile">
    <h1>个人中心</h1>
    <div class="profile-content">
      <div class="user-info">
        <h2>个人信息</h2>
        <p>用户名: {{ userInfo.userName }}</p>
        <p>昵称: {{ userInfo.nickName }}</p>
        <p>邮箱: {{ userInfo.email }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const userInfo = ref({
  userName: 'user',
  nickName: '普通用户',
  email: 'user@example.com'
})
</script>

<style scoped lang="scss">
.profile {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  
  h1 {
    margin-bottom: 30px;
    color: #333;
  }
  
  .profile-content {
    background: white;
    padding: 30px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
  
  .user-info {
    h2 {
      margin-bottom: 20px;
      color: #333;
    }
    
    p {
      margin-bottom: 10px;
      color: #666;
    }
  }
}
</style>
