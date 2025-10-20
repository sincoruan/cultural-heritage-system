<template>
  <div class="notice-detail">
    <h1>{{ notice.noticeTitle }}</h1>
    <div class="notice-meta">
      <span>发布时间: {{ notice.createTime }}</span>
    </div>
    <div class="notice-content">
      <p>{{ notice.noticeContent }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const notice = ref({
  noticeId: 1,
  noticeTitle: '欢迎使用文化遗产管理与展示系统',
  noticeContent: '本系统致力于文化遗产的数字化保护与展示，欢迎广大用户使用！',
  createTime: '2024-01-01'
})
</script>

<style scoped lang="scss">
.notice-detail {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  
  h1 {
    margin-bottom: 20px;
    color: #333;
  }
  
  .notice-meta {
    margin-bottom: 30px;
    color: #666;
  }
  
  .notice-content {
    line-height: 1.6;
    color: #333;
  }
}
</style>
