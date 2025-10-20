<template>
  <div class="admin-layout">
    <div class="sidebar">
      <h2>管理后台</h2>
      <nav>
        <router-link to="/admin/dashboard">数据统计</router-link>
        <router-link to="/admin/heritage">文化遗产管理</router-link>
        <router-link to="/admin/notice">公告管理</router-link>
        <router-link to="/admin/user">用户管理</router-link>
        <router-link to="/admin/monitor">系统监控</router-link>
      </nav>
    </div>
    <div class="main-content">
      <router-view />
    </div>
  </div>
</template>

<script setup lang="ts">
// 管理后台布局
</script>

<style scoped lang="scss">
.admin-layout {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 250px;
  background: #304156;
  color: white;
  padding: 20px;
  
  h2 {
    margin-bottom: 30px;
    text-align: center;
  }
  
  nav {
    display: flex;
    flex-direction: column;
    gap: 10px;
    
    a {
      color: white;
      text-decoration: none;
      padding: 10px;
      border-radius: 4px;
      transition: background 0.3s;
      
      &:hover, &.router-link-active {
        background: #409eff;
      }
    }
  }
}

.main-content {
  flex: 1;
  padding: 20px;
  background: #f5f5f5;
}
</style>
