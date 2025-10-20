<template>
  <div class="heritage-detail">
    <div class="detail-header">
      <h1>{{ heritageInfo.heritageName }}</h1>
      <p class="meta">{{ heritageInfo.era }} · {{ heritageInfo.location }}</p>
    </div>
    
    <div class="detail-content">
      <div class="image-gallery">
        <img :src="heritageInfo.imageUrl || '/placeholder.jpg'" :alt="heritageInfo.heritageName" />
      </div>
      
      <div class="info-section">
        <h2>详细信息</h2>
        <p>{{ heritageInfo.description }}</p>
        
        <div class="stats">
          <div class="stat-item">
            <span class="label">浏览量:</span>
            <span class="value">{{ heritageInfo.viewCount }}</span>
          </div>
          <div class="stat-item">
            <span class="label">点赞数:</span>
            <span class="value">{{ heritageInfo.likeCount }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const heritageInfo = ref({
  heritageId: 1,
  heritageName: '故宫博物院',
  category: '古建筑',
  description: '故宫博物院位于北京市中心，是中国明清两代的皇家宫殿，旧称紫禁城。',
  era: '明清',
  location: '北京市',
  viewCount: 15280,
  likeCount: 8520,
  imageUrl: '/placeholder.jpg'
})

onMounted(() => {
  // 根据路由参数加载文化遗产详情
  const id = route.params.id
  console.log('加载文化遗产详情:', id)
})
</script>

<style scoped lang="scss">
.heritage-detail {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.detail-header {
  text-align: center;
  margin-bottom: 40px;
  
  h1 {
    font-size: 2.5rem;
    margin-bottom: 10px;
    color: #333;
  }
  
  .meta {
    font-size: 1.1rem;
    color: #666;
  }
}

.detail-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.image-gallery {
  img {
    width: 100%;
    height: 400px;
    object-fit: cover;
    border-radius: 10px;
  }
}

.info-section {
  h2 {
    font-size: 1.8rem;
    margin-bottom: 20px;
    color: #333;
  }
  
  p {
    line-height: 1.6;
    color: #666;
    margin-bottom: 30px;
  }
}

.stats {
  display: flex;
  gap: 30px;
  
  .stat-item {
    .label {
      color: #999;
      margin-right: 10px;
    }
    
    .value {
      font-weight: 600;
      color: #409eff;
    }
  }
}
</style>
