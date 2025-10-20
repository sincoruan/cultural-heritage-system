<template>
  <div class="admin-monitor">
    <div class="monitor-header">
      <h1>系统监控</h1>
      <div class="refresh-controls">
        <el-button @click="refreshData" :loading="loading">
          <el-icon><Refresh /></el-icon>
          刷新数据
        </el-button>
        <el-switch v-model="autoRefresh" @change="toggleAutoRefresh" />
        <span>自动刷新</span>
      </div>
    </div>

    <!-- 系统概览 -->
    <div class="overview-section">
      <h2>系统概览</h2>
      <div class="overview-grid">
        <div class="overview-card">
          <div class="card-icon">
            <el-icon size="32"><User /></el-icon>
          </div>
          <div class="card-content">
            <h3>总用户数</h3>
            <p class="number">{{ systemOverview.totalUsers || 0 }}</p>
          </div>
        </div>
        <div class="overview-card">
          <div class="card-icon">
            <el-icon size="32"><Collection /></el-icon>
          </div>
          <div class="card-content">
            <h3>文化遗产</h3>
            <p class="number">{{ systemOverview.totalHeritage || 0 }}</p>
          </div>
        </div>
        <div class="overview-card">
          <div class="card-icon">
            <el-icon size="32"><Bell /></el-icon>
          </div>
          <div class="card-content">
            <h3>公告数量</h3>
            <p class="number">{{ systemOverview.totalNotices || 0 }}</p>
          </div>
        </div>
        <div class="overview-card">
          <div class="card-icon">
            <el-icon size="32"><Clock /></el-icon>
          </div>
          <div class="card-content">
            <h3>运行时间</h3>
            <p class="number">{{ formatUptime(systemOverview.uptime) }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 系统性能 -->
    <div class="performance-section">
      <h2>系统性能</h2>
      <div class="performance-grid">
        <div class="performance-card">
          <h3>CPU使用率</h3>
          <div class="progress-container">
            <el-progress :percentage="systemPerformance.cpuUsage" :color="getProgressColor(systemPerformance.cpuUsage)" />
            <span class="progress-text">{{ systemPerformance.cpuUsage }}%</span>
          </div>
        </div>
        <div class="performance-card">
          <h3>内存使用率</h3>
          <div class="progress-container">
            <el-progress :percentage="systemPerformance.memoryUsage" :color="getProgressColor(systemPerformance.memoryUsage)" />
            <span class="progress-text">{{ systemPerformance.memoryUsage }}%</span>
          </div>
        </div>
        <div class="performance-card">
          <h3>磁盘使用率</h3>
          <div class="progress-container">
            <el-progress :percentage="systemPerformance.diskUsage" :color="getProgressColor(systemPerformance.diskUsage)" />
            <span class="progress-text">{{ systemPerformance.diskUsage }}%</span>
          </div>
        </div>
        <div class="performance-card">
          <h3>网络状态</h3>
          <div class="status-indicator">
            <el-icon :class="systemPerformance.networkStatus === '正常' ? 'status-good' : 'status-bad'">
              <CircleCheck v-if="systemPerformance.networkStatus === '正常'" />
              <CircleClose v-else />
            </el-icon>
            <span>{{ systemPerformance.networkStatus }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 访问统计 -->
    <div class="stats-section">
      <h2>访问统计</h2>
      <div class="stats-grid">
        <div class="stats-card">
          <h3>今日访问</h3>
          <p class="number">{{ accessStats.todayVisits || 0 }}</p>
        </div>
        <div class="stats-card">
          <h3>本周访问</h3>
          <p class="number">{{ accessStats.weekVisits || 0 }}</p>
        </div>
        <div class="stats-card">
          <h3>本月访问</h3>
          <p class="number">{{ accessStats.monthVisits || 0 }}</p>
        </div>
        <div class="stats-card">
          <h3>总访问量</h3>
          <p class="number">{{ accessStats.totalVisits || 0 }}</p>
        </div>
      </div>
    </div>

    <!-- 数据库状态 -->
    <div class="database-section">
      <h2>数据库状态</h2>
      <div class="database-grid">
        <div class="database-card">
          <h3>MySQL状态</h3>
          <div class="status-indicator">
            <el-icon :class="databaseStatus.mysqlStatus === '正常' ? 'status-good' : 'status-bad'">
              <CircleCheck v-if="databaseStatus.mysqlStatus === '正常'" />
              <CircleClose v-else />
            </el-icon>
            <span>{{ databaseStatus.mysqlStatus }}</span>
          </div>
        </div>
        <div class="database-card">
          <h3>Redis状态</h3>
          <div class="status-indicator">
            <el-icon :class="cacheStatus.redisStatus === '正常' ? 'status-good' : 'status-bad'">
              <CircleCheck v-if="cacheStatus.redisStatus === '正常'" />
              <CircleClose v-else />
            </el-icon>
            <span>{{ cacheStatus.redisStatus }}</span>
          </div>
        </div>
        <div class="database-card">
          <h3>连接数</h3>
          <p class="number">{{ databaseStatus.connections || 0 }}</p>
        </div>
        <div class="database-card">
          <h3>缓存命中率</h3>
          <p class="number">{{ cacheStatus.hitRate || 0 }}%</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import { 
  Refresh, User, Collection, Bell, Clock, 
  CircleCheck, CircleClose 
} from '@element-plus/icons-vue'
import { getSystemOverview, getSystemPerformance, getAccessStats, getDatabaseStatus, getCacheStatus } from '@/api/monitor'

// 响应式数据
const loading = ref(false)
const autoRefresh = ref(false)
let refreshTimer: NodeJS.Timeout | null = null

// 监控数据
const systemOverview = ref({
  totalUsers: 0,
  totalHeritage: 0,
  totalNotices: 0,
  uptime: 0
})

const systemPerformance = ref({
  cpuUsage: 0,
  memoryUsage: 0,
  diskUsage: 0,
  networkStatus: '正常'
})

const accessStats = ref({
  todayVisits: 0,
  weekVisits: 0,
  monthVisits: 0,
  totalVisits: 0
})

const databaseStatus = ref({
  mysqlStatus: '正常',
  connections: 0
})

const cacheStatus = ref({
  redisStatus: '正常',
  hitRate: 0
})

// 获取系统概览数据
const loadSystemOverview = async () => {
  try {
    const response = await getSystemOverview()
    if (response.code === 200) {
      systemOverview.value = response.data
    }
  } catch (error) {
    console.error('获取系统概览失败:', error)
  }
}

// 获取系统性能数据
const loadSystemPerformance = async () => {
  try {
    const response = await getSystemPerformance()
    if (response.code === 200) {
      systemPerformance.value = response.data
    }
  } catch (error) {
    console.error('获取系统性能失败:', error)
  }
}

// 获取访问统计数据
const loadAccessStats = async () => {
  try {
    const response = await getAccessStats()
    if (response.code === 200) {
      accessStats.value = response.data
    }
  } catch (error) {
    console.error('获取访问统计失败:', error)
  }
}

// 获取数据库状态
const loadDatabaseStatus = async () => {
  try {
    const response = await getDatabaseStatus()
    if (response.code === 200) {
      databaseStatus.value = response.data
    }
  } catch (error) {
    console.error('获取数据库状态失败:', error)
  }
}

// 获取缓存状态
const loadCacheStatus = async () => {
  try {
    const response = await getCacheStatus()
    if (response.code === 200) {
      cacheStatus.value = response.data
    }
  } catch (error) {
    console.error('获取缓存状态失败:', error)
  }
}

// 刷新所有数据
const refreshData = async () => {
  loading.value = true
  try {
    await Promise.all([
      loadSystemOverview(),
      loadSystemPerformance(),
      loadAccessStats(),
      loadDatabaseStatus(),
      loadCacheStatus()
    ])
    ElMessage.success('数据刷新成功')
  } catch (error) {
    ElMessage.error('数据刷新失败')
  } finally {
    loading.value = false
  }
}

// 切换自动刷新
const toggleAutoRefresh = (value: boolean) => {
  if (value) {
    refreshTimer = setInterval(refreshData, 30000) // 30秒刷新一次
  } else {
    if (refreshTimer) {
      clearInterval(refreshTimer)
      refreshTimer = null
    }
  }
}

// 格式化运行时间
const formatUptime = (uptime: number) => {
  if (!uptime) return '0天0小时0分钟'
  
  const days = Math.floor(uptime / (1000 * 60 * 60 * 24))
  const hours = Math.floor((uptime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  const minutes = Math.floor((uptime % (1000 * 60 * 60)) / (1000 * 60))
  
  return `${days}天${hours}小时${minutes}分钟`
}

// 获取进度条颜色
const getProgressColor = (percentage: number) => {
  if (percentage < 50) return '#67c23a'
  if (percentage < 80) return '#e6a23c'
  return '#f56c6c'
}

// 组件挂载时加载数据
onMounted(() => {
  refreshData()
})

// 组件卸载时清理定时器
onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
})
</script>

<style scoped lang="scss">
.admin-monitor {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.monitor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  
  h1 {
    margin: 0;
    color: #333;
    font-size: 2rem;
  }
}

.refresh-controls {
  display: flex;
  align-items: center;
  gap: 15px;
  
  span {
    color: #666;
    font-size: 0.9rem;
  }
}

// 系统概览样式
.overview-section {
  margin-bottom: 30px;
  
  h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 1.5rem;
  }
}

.overview-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.overview-card {
  background: white;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 20px;
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
  }
  
  .card-icon {
    color: #409eff;
    flex-shrink: 0;
  }
  
  .card-content {
    h3 {
      margin: 0 0 8px 0;
      color: #666;
      font-size: 1rem;
    }
    
    .number {
      font-size: 2rem;
      font-weight: bold;
      color: #333;
      margin: 0;
    }
  }
}

// 系统性能样式
.performance-section {
  margin-bottom: 30px;
  
  h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 1.5rem;
  }
}

.performance-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.performance-card {
  background: white;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  
  h3 {
    margin: 0 0 20px 0;
    color: #333;
    font-size: 1.1rem;
  }
}

.progress-container {
  display: flex;
  align-items: center;
  gap: 15px;
  
  .progress-text {
    font-weight: bold;
    color: #333;
    min-width: 40px;
  }
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 10px;
  
  .status-good {
    color: #67c23a;
  }
  
  .status-bad {
    color: #f56c6c;
  }
  
  span {
    font-weight: 500;
    color: #333;
  }
}

// 访问统计样式
.stats-section {
  margin-bottom: 30px;
  
  h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 1.5rem;
  }
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.stats-card {
  background: white;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
  }
  
  h3 {
    margin: 0 0 15px 0;
    color: #666;
    font-size: 1rem;
  }
  
  .number {
    font-size: 2.5rem;
    font-weight: bold;
    color: #409eff;
    margin: 0;
  }
}

// 数据库状态样式
.database-section {
  margin-bottom: 30px;
  
  h2 {
    margin-bottom: 20px;
    color: #333;
    font-size: 1.5rem;
  }
}

.database-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.database-card {
  background: white;
  padding: 25px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
  }
  
  h3 {
    margin: 0 0 15px 0;
    color: #333;
    font-size: 1.1rem;
  }
  
  .number {
    font-size: 2rem;
    font-weight: bold;
    color: #409eff;
    margin: 0;
  }
}
</style>
