<template>
  <div class="home-container">
    <AppHeader />
    
    <div class="hero-section">
      <h1>文化遗产管理与展示系统</h1>
      <p>探索中华文明的瑰宝，传承千年文化</p>
      <div class="hero-buttons">
        <el-button type="primary" size="large" @click="goToHeritage">
          浏览文化遗产
        </el-button>
        <el-button size="large" @click="goToNotice">
          查看公告
        </el-button>
        <el-button v-if="isAdmin" type="success" size="large" @click="goToAdmin">
          管理后台
        </el-button>
      </div>
    </div>
    
    <div class="features-section">
      <h2>系统特色</h2>
      <div class="features-grid">
        <div class="feature-card" @click="goToHeritage">
          <el-icon size="48"><Collection /></el-icon>
          <h3>文化遗产浏览</h3>
          <p>探索丰富的文化遗产资源，了解历史文化的魅力</p>
          <el-button type="text" class="card-button">立即浏览 →</el-button>
        </div>
        <div class="feature-card" @click="goToMultimedia">
          <el-icon size="48"><View /></el-icon>
          <h3>多媒体展示</h3>
          <p>支持图片、视频、3D模型等多种展示形式</p>
          <el-button type="text" class="card-button">查看详情 →</el-button>
        </div>
        <div class="feature-card" @click="goToInteractive">
          <el-icon size="48"><ChatDotRound /></el-icon>
          <h3>互动交流</h3>
          <p>用户可评论、点赞、收藏，参与文化传承</p>
          <el-button type="text" class="card-button">参与互动 →</el-button>
        </div>
      </div>
    </div>
    
    <!-- 文化遗产统计 -->
    <div class="stats-section">
      <h2>文化遗产数据统计</h2>
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon size="40"><Collection /></el-icon>
          </div>
          <div class="stat-content">
            <h3>{{ heritageStats.totalHeritage }}</h3>
            <p>文化遗产总数</p>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon size="40"><Picture /></el-icon>
          </div>
          <div class="stat-content">
            <h3>{{ heritageStats.totalImages }}</h3>
            <p>精美图片</p>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon size="40"><VideoPlay /></el-icon>
          </div>
          <div class="stat-content">
            <h3>{{ heritageStats.totalVideos }}</h3>
            <p>精彩视频</p>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">
            <el-icon size="40"><User /></el-icon>
          </div>
          <div class="stat-content">
            <h3>{{ heritageStats.totalUsers }}</h3>
            <p>注册用户</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 热门文化遗产推荐 -->
    <div class="featured-section">
      <h2>热门文化遗产推荐</h2>
      <div class="featured-grid">
        <div v-for="item in featuredHeritage" :key="item.id" class="featured-card" @click="goToHeritageDetail(item.id)">
          <div class="featured-image">
            <img :src="item.imageUrl" :alt="item.name" />
            <div class="featured-overlay">
              <el-icon size="24"><View /></el-icon>
            </div>
          </div>
          <div class="featured-content">
            <h3>{{ item.name }}</h3>
            <p>{{ item.description }}</p>
            <div class="featured-meta">
              <span class="category">{{ item.category }}</span>
              <span class="views">{{ item.views }} 次浏览</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 最新文化遗产 -->
    <div class="latest-section">
      <h2>最新文化遗产</h2>
      <div class="latest-list">
        <div v-for="item in latestHeritage" :key="item.id" class="latest-item" @click="goToHeritageDetail(item.id)">
          <div class="latest-image">
            <img :src="item.imageUrl" :alt="item.name" />
          </div>
          <div class="latest-content">
            <h4>{{ item.name }}</h4>
            <p>{{ item.description }}</p>
            <div class="latest-meta">
              <span class="date">{{ formatDate(item.createTime) }}</span>
              <span class="category">{{ item.category }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 文化知识小贴士 -->
    <div class="tips-section">
      <h2>文化知识小贴士</h2>
      <div class="tips-grid">
        <div v-for="tip in culturalTips" :key="tip.id" class="tip-card">
          <div class="tip-icon">
            <el-icon size="32"><InfoFilled /></el-icon>
          </div>
          <div class="tip-content">
            <h4>{{ tip.title }}</h4>
            <p>{{ tip.content }}</p>
          </div>
        </div>
      </div>
    </div>

    <div class="quick-access">
      <h2>快速访问</h2>
      <div class="access-grid">
        <div class="access-card" @click="goToHeritage">
          <el-icon size="32"><Collection /></el-icon>
          <span>文化遗产</span>
        </div>
        <div class="access-card" @click="goToNotice">
          <el-icon size="32"><Bell /></el-icon>
          <span>公告通知</span>
        </div>
        <div class="access-card" @click="goToProfile">
          <el-icon size="32"><User /></el-icon>
          <span>个人中心</span>
        </div>
        <div class="access-card" @click="goToAdmin" v-if="isAdmin">
          <el-icon size="32"><Setting /></el-icon>
          <span>管理后台</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { computed, ref, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import AppHeader from '@/components/AppHeader.vue'
import { ElMessage } from 'element-plus'
import { Collection, View, ChatDotRound, Bell, User, Setting, Picture, VideoPlay, InfoFilled } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()

const isAdmin = computed(() => userStore.isAdmin)

// 统计数据
const heritageStats = ref({
  totalHeritage: 0,
  totalImages: 0,
  totalVideos: 0,
  totalUsers: 0
})

// 热门文化遗产
const featuredHeritage = ref([
  {
    id: 1,
    name: '故宫博物院',
    description: '明清两朝的皇家宫殿，世界文化遗产',
    imageUrl: 'http://localhost:8080/api/uploads/heritage/gugong_01.jpg',
    category: '古建筑',
    views: 12580
  },
  {
    id: 2,
    name: '万里长城',
    description: '中国古代军事防御工程，世界文化遗产',
    imageUrl: 'http://localhost:8080/api/uploads/heritage/greatwall_01.jpg',
    category: '古建筑',
    views: 9876
  },
  {
    id: 3,
    name: '兵马俑',
    description: '秦始皇陵兵马俑，世界文化遗产',
    imageUrl: 'http://localhost:8080/api/uploads/heritage/terracotta_01.jpg',
    category: '文物',
    views: 15620
  }
])

// 最新文化遗产
const latestHeritage = ref([
  {
    id: 4,
    name: '苏州园林',
    description: '江南古典园林的代表作',
    imageUrl: 'http://localhost:8080/api/uploads/heritage/suzhou_01.jpg',
    category: '古建筑',
    createTime: '2025-10-19T10:30:00'
  },
  {
    id: 5,
    name: '敦煌莫高窟',
    description: '佛教艺术宝库，世界文化遗产',
    imageUrl: 'http://localhost:8080/api/uploads/heritage/dunhuang_01.jpg',
    category: '石窟',
    createTime: '2025-10-18T15:20:00'
  }
])

// 文化知识小贴士
const culturalTips = ref([
  {
    id: 1,
    title: '故宫的建筑智慧',
    content: '故宫采用"前朝后寝"的布局，体现了中国古代建筑的天人合一思想。'
  },
  {
    id: 2,
    title: '长城的防御体系',
    content: '长城不仅是城墙，更是一个完整的军事防御体系，包括烽火台、关隘等。'
  },
  {
    id: 3,
    title: '兵马俑的制作工艺',
    content: '兵马俑采用模制与手塑相结合的制作方法，每个俑都有独特的面部特征。'
  }
])

const goToHeritage = () => {
  router.push('/heritage')
}

const goToNotice = () => {
  router.push('/notice')
}

const goToProfile = () => {
  if (userStore.isAuthenticated) {
    router.push('/profile')
  } else {
    router.push('/login')
  }
}

const goToAdmin = () => {
  if (userStore.isAdmin) {
    router.push('/admin')
  } else {
    router.push('/login')
  }
}

// 加载统计数据
const loadStats = async () => {
  try {
    // 这里可以调用API获取真实数据
    // 现在使用模拟数据
    heritageStats.value = {
      totalHeritage: 156,
      totalImages: 1248,
      totalVideos: 89,
      totalUsers: 3421
    }
  } catch (error) {
    console.error('加载统计数据失败:', error)
  }
}

// 格式化日期
const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const goToHeritageDetail = (id: number) => {
  router.push(`/heritage/${id}`)
}

// 组件挂载时加载数据
onMounted(() => {
  loadStats()
})

// 新增的导航方法
const goToMultimedia = () => {
  // 多媒体展示 - 跳转到专门的多媒体展示页面
  router.push('/multimedia')
}

const goToInteractive = () => {
  // 互动交流 - 跳转到专门的互动交流页面
  if (userStore.isAuthenticated) {
    // 已登录用户跳转到互动交流页面
    router.push('/interactive')
  } else {
    // 未登录用户先跳转到登录页面
    router.push('/login')
  }
}
</script>

<style scoped lang="scss">
.home-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.hero-section {
  text-align: center;
  padding: 100px 20px;
  color: white;
  
  h1 {
    font-size: 3rem;
    margin-bottom: 20px;
    font-weight: 700;
  }
  
  p {
    font-size: 1.2rem;
    margin-bottom: 40px;
    opacity: 0.9;
  }
}

.hero-buttons {
  display: flex;
  gap: 20px;
  justify-content: center;
  flex-wrap: wrap;
}

.features-section {
  background: white;
  padding: 80px 20px;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
    color: #333;
  }
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 40px;
  max-width: 1200px;
  margin: 0 auto;
}

.feature-card {
  text-align: center;
  padding: 40px 20px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  cursor: pointer;
  
  &:hover {
    transform: translateY(-10px);
  }
  
  .el-icon {
    color: #409eff;
    margin-bottom: 20px;
  }
  
  h3 {
    font-size: 1.5rem;
    margin-bottom: 15px;
    color: #333;
  }
  
  p {
    color: #666;
    line-height: 1.6;
    margin-bottom: 20px;
  }
  
  .card-button {
    color: #409eff;
    font-weight: 500;
  }
}

// 统计数据样式
.stats-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 80px 20px;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
  }
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.stat-card {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 15px;
  padding: 30px;
  text-align: center;
  border: 1px solid rgba(255, 255, 255, 0.2);
  
  .stat-icon {
    margin-bottom: 20px;
  }
  
  h3 {
    font-size: 2.5rem;
    margin-bottom: 10px;
    font-weight: bold;
  }
  
  p {
    font-size: 1.1rem;
    opacity: 0.9;
  }
}

// 热门推荐样式
.featured-section {
  padding: 80px 20px;
  background: #f8f9fa;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
    color: #333;
  }
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.featured-card {
  background: white;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
  }
}

.featured-image {
  position: relative;
  height: 200px;
  overflow: hidden;
  
  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
  }
  
  .featured-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(0, 0, 0, 0.7);
    color: white;
    border-radius: 50%;
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  
  &:hover {
    img {
      transform: scale(1.1);
    }
    
    .featured-overlay {
      opacity: 1;
    }
  }
}

.featured-content {
  padding: 25px;
  
  h3 {
    font-size: 1.5rem;
    margin-bottom: 10px;
    color: #333;
  }
  
  p {
    color: #666;
    line-height: 1.6;
    margin-bottom: 15px;
  }
}

.featured-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  .category {
    background: #409eff;
    color: white;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 0.9rem;
  }
  
  .views {
    color: #999;
    font-size: 0.9rem;
  }
}

// 最新文化遗产样式
.latest-section {
  padding: 80px 20px;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
    color: #333;
  }
}

.latest-list {
  max-width: 800px;
  margin: 0 auto;
}

.latest-item {
  display: flex;
  align-items: center;
  background: white;
  border-radius: 10px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateX(10px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
  }
}

.latest-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  overflow: hidden;
  margin-right: 20px;
  flex-shrink: 0;
  
  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.latest-content {
  flex: 1;
  
  h4 {
    font-size: 1.2rem;
    margin-bottom: 8px;
    color: #333;
  }
  
  p {
    color: #666;
    line-height: 1.5;
    margin-bottom: 10px;
  }
}

.latest-meta {
  display: flex;
  gap: 15px;
  
  .date, .category {
    font-size: 0.9rem;
    color: #999;
  }
  
  .category {
    background: #f0f0f0;
    padding: 2px 8px;
    border-radius: 4px;
  }
}

// 文化知识小贴士样式
.tips-section {
  background: #f8f9fa;
  padding: 80px 20px;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
    color: #333;
  }
}

.tips-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto;
}

.tip-card {
  background: white;
  border-radius: 15px;
  padding: 30px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: flex-start;
  gap: 20px;
  
  .tip-icon {
    color: #409eff;
    flex-shrink: 0;
  }
  
  .tip-content {
    h4 {
      font-size: 1.2rem;
      margin-bottom: 10px;
      color: #333;
    }
    
    p {
      color: #666;
      line-height: 1.6;
    }
  }
}

.quick-access {
  background: #f8f9fa;
  padding: 80px 20px;
  
  h2 {
    text-align: center;
    font-size: 2.5rem;
    margin-bottom: 60px;
    color: #333;
  }
}

.access-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 30px;
  max-width: 1000px;
  margin: 0 auto;
}

.access-card {
  background: white;
  padding: 30px 20px;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
  }
  
  .el-icon {
    color: #409eff;
  }
  
  span {
    font-size: 1.1rem;
    font-weight: 500;
    color: #333;
  }
}
</style>
