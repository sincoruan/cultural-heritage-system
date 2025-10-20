<template>
  <div class="admin-notice">
    <h1>公告管理</h1>
    <div class="toolbar">
      <el-button type="primary">添加公告</el-button>
    </div>
    <div class="notice-table">
      <el-table :data="noticeList" style="width: 100%">
        <el-table-column prop="noticeTitle" label="标题" />
        <el-table-column prop="noticeType" label="类型" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column prop="status" label="状态" />
        <el-table-column label="操作">
          <template #default>
            <el-button size="small">编辑</el-button>
            <el-button size="small" type="danger">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const noticeList = ref([
  {
    noticeTitle: '欢迎使用文化遗产管理与展示系统',
    noticeType: '通知',
    createTime: '2024-01-01',
    status: '已发布'
  }
])
</script>

<style scoped lang="scss">
.admin-notice {
  h1 {
    margin-bottom: 30px;
    color: #333;
  }
  
  .toolbar {
    margin-bottom: 20px;
  }
  
  .notice-table {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }
}
</style>
