<template>
  <div class="notice-list">
    <h1>公告通知</h1>
    <div class="notice-grid">
      <div v-for="notice in noticeList" :key="notice.noticeId" class="notice-card">
        <h3>{{ notice.noticeTitle }}</h3>
        <p>{{ notice.noticeContent?.substring(0, 100) }}...</p>
        <div class="notice-meta">
          <span>{{ notice.createTime }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const noticeList = ref([
  {
    noticeId: 1,
    noticeTitle: '欢迎使用文化遗产管理与展示系统',
    noticeContent: '本系统致力于文化遗产的数字化保护与展示...',
    createTime: '2024-01-01'
  }
])
</script>

<style scoped lang="scss">
.notice-list {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  
  h1 {
    text-align: center;
    margin-bottom: 40px;
  }
}

.notice-grid {
  display: grid;
  gap: 20px;
}

.notice-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  
  h3 {
    margin-bottom: 10px;
    color: #333;
  }
  
  p {
    color: #666;
    margin-bottom: 15px;
  }
  
  .notice-meta {
    font-size: 0.9rem;
    color: #999;
  }
}
</style>
