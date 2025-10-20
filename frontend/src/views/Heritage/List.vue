<template>
  <div class="heritage-list">
    <div class="header">
      <h1>文化遗产展示</h1>
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索文化遗产..."
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button @click="handleSearch">搜索</el-button>
          </template>
        </el-input>
      </div>
    </div>
    
    <div v-loading="loading" class="heritage-grid">
      <div v-for="item in heritageList" :key="item.heritageId" class="heritage-card">
        <div class="card-image">
          <img :src="item.imageUrl || '/placeholder.jpg'" :alt="item.heritageName" />
        </div>
        <div class="card-content">
          <h3>{{ item.heritageName }}</h3>
          <p class="category">{{ item.category }}</p>
          <p class="description">{{ item.description?.substring(0, 100) }}...</p>
          <div class="card-footer">
            <span class="era">{{ item.era }}</span>
            <span class="location">{{ item.location }}</span>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 分页组件 -->
    <div v-if="total > 0" class="pagination-container">
      <el-pagination
        v-model:current-page="currentPage"
        :page-size="pageSize"
        :total="total"
        layout="total, prev, pager, next, jumper"
        @current-change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getHeritageList } from '@/api/heritage'

const searchKeyword = ref('')
const heritageList = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

const loadHeritageList = async () => {
  try {
    loading.value = true
    const response = await getHeritageList({
      page: currentPage.value - 1,
      size: pageSize.value,
      keyword: searchKeyword.value
    })
    
    if (response.code === 200) {
      heritageList.value = response.data.content || []
      total.value = response.data.totalElements || 0
    } else {
      ElMessage.error(response.message || '加载失败')
    }
  } catch (error) {
    ElMessage.error('加载文化遗产列表失败')
    console.error('加载失败:', error)
  } finally {
    loading.value = false
  }
}

const handleSearch = () => {
  currentPage.value = 1
  loadHeritageList()
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  loadHeritageList()
}

onMounted(() => {
  loadHeritageList()
})
</script>

<style scoped lang="scss">
.heritage-list {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.header {
  text-align: center;
  margin-bottom: 40px;
  
  h1 {
    font-size: 2.5rem;
    margin-bottom: 20px;
    color: #333;
  }
}

.search-bar {
  max-width: 500px;
  margin: 0 auto;
}

.heritage-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.heritage-card {
  background: white;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
  }
}

.card-image {
  height: 200px;
  overflow: hidden;
  
  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.card-content {
  padding: 20px;
  
  h3 {
    font-size: 1.3rem;
    margin-bottom: 10px;
    color: #333;
  }
  
  .category {
    color: #409eff;
    font-weight: 500;
    margin-bottom: 10px;
  }
  
  .description {
    color: #666;
    line-height: 1.5;
    margin-bottom: 15px;
  }
}

.card-footer {
  display: flex;
  justify-content: space-between;
  font-size: 0.9rem;
  color: #999;
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 40px;
  padding: 20px 0;
}
</style>
