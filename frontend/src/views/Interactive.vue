<template>
  <div class="interactive-container">
    <AppHeader />
    
    <div class="interactive-header">
      <h1>互动交流</h1>
      <p>参与文化传承，分享您的观点和感受</p>
    </div>
    
    <div class="interactive-content">
      <div class="activity-tabs">
        <el-tabs v-model="activeTab" class="demo-tabs">
          <el-tab-pane label="我的评论" name="comments">
            <div class="comments-section">
              <h3>我的评论</h3>
              <div v-if="userComments.length === 0" class="empty-state">
                <el-icon size="64"><ChatDotRound /></el-icon>
                <p>您还没有发表过评论</p>
                <el-button type="primary" @click="goToHeritage">去浏览文化遗产</el-button>
              </div>
              <div v-else class="comments-list">
                <div v-for="comment in userComments" :key="comment.id" class="comment-item">
                  <div class="comment-content">
                    <p>{{ comment.content }}</p>
                    <div class="comment-meta">
                      <span>{{ comment.heritageName }}</span>
                      <span>{{ formatDate(comment.createTime) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="我的收藏" name="collections">
            <div class="collections-section">
              <h3>我的收藏</h3>
              <div v-if="userCollections.length === 0" class="empty-state">
                <el-icon size="64"><Star /></el-icon>
                <p>您还没有收藏任何文化遗产</p>
                <el-button type="primary" @click="goToHeritage">去浏览文化遗产</el-button>
              </div>
              <div v-else class="collections-grid">
                <div v-for="item in userCollections" :key="item.id" class="collection-item">
                  <img :src="item.imageUrl || '/placeholder.jpg'" :alt="item.heritageName" />
                  <div class="item-info">
                    <h4>{{ item.heritageName }}</h4>
                    <p>{{ item.category }}</p>
                    <el-button type="text" @click="viewHeritage(item.id)">查看详情</el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="我的点赞" name="likes">
            <div class="likes-section">
              <h3>我的点赞</h3>
              <div v-if="userLikes.length === 0" class="empty-state">
                <el-icon size="64"><Like /></el-icon>
                <p>您还没有点赞任何内容</p>
                <el-button type="primary" @click="goToHeritage">去浏览文化遗产</el-button>
              </div>
              <div v-else class="likes-grid">
                <div v-for="item in userLikes" :key="item.id" class="like-item">
                  <img :src="item.imageUrl || '/placeholder.jpg'" :alt="item.heritageName" />
                  <div class="item-info">
                    <h4>{{ item.heritageName }}</h4>
                    <p>{{ item.category }}</p>
                    <el-button type="text" @click="viewHeritage(item.id)">查看详情</el-button>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import AppHeader from '@/components/AppHeader.vue'

const router = useRouter()
const userStore = useUserStore()

const activeTab = ref('comments')

// 模拟数据
const userComments = ref([
  {
    id: 1,
    content: '这个文化遗产非常震撼，体现了古代工匠的精湛技艺！',
    heritageName: '故宫博物院',
    createTime: '2024-01-15 10:30:00'
  }
])

const userCollections = ref([
  {
    id: 1,
    heritageName: '故宫博物院',
    category: '古建筑',
    imageUrl: '/placeholder.jpg'
  }
])

const userLikes = ref([
  {
    id: 1,
    heritageName: '长城',
    category: '古建筑',
    imageUrl: '/placeholder.jpg'
  }
])

const goToHeritage = () => {
  router.push('/heritage')
}

const viewHeritage = (id: number) => {
  router.push(`/heritage/${id}`)
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('zh-CN')
}

onMounted(() => {
  // 检查用户是否已登录
  if (!userStore.isAuthenticated) {
    router.push('/login')
  }
})
</script>

<style scoped lang="scss">
.interactive-container {
  min-height: 100vh;
  background: #f5f7fa;
}

.interactive-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  text-align: center;
  padding: 80px 20px;
  
  h1 {
    font-size: 2.5rem;
    margin-bottom: 20px;
  }
  
  p {
    font-size: 1.2rem;
    opacity: 0.9;
  }
}

.interactive-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.activity-tabs {
  background: white;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  
  .el-icon {
    color: #ddd;
    margin-bottom: 20px;
  }
  
  p {
    font-size: 1.1rem;
    margin-bottom: 30px;
  }
}

.comments-list, .collections-grid, .likes-grid {
  padding: 20px;
}

.comment-item {
  border-bottom: 1px solid #eee;
  padding: 20px 0;
  
  &:last-child {
    border-bottom: none;
  }
}

.comment-content {
  p {
    font-size: 1.1rem;
    line-height: 1.6;
    margin-bottom: 10px;
  }
}

.comment-meta {
  display: flex;
  gap: 20px;
  font-size: 0.9rem;
  color: #999;
}

.collections-grid, .likes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
}

.collection-item, .like-item {
  border: 1px solid #eee;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  }
  
  img {
    width: 100%;
    height: 150px;
    object-fit: cover;
  }
}

.item-info {
  padding: 15px;
  
  h4 {
    margin-bottom: 8px;
    color: #333;
  }
  
  p {
    color: #666;
    margin-bottom: 10px;
  }
}
</style>
