<template>
  <div class="dashboard">
    <h1>数据统计</h1>
    
    <!-- 概览统计 -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">
          <el-icon size="32"><User /></el-icon>
        </div>
        <div class="stat-content">
          <h3>用户总数</h3>
          <p class="number">{{ overviewStats.totalUsers || 0 }}</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <el-icon size="32"><Collection /></el-icon>
        </div>
        <div class="stat-content">
          <h3>文化遗产数</h3>
          <p class="number">{{ overviewStats.totalHeritage || 0 }}</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <el-icon size="32"><Bell /></el-icon>
        </div>
        <div class="stat-content">
          <h3>公告总数</h3>
          <p class="number">{{ overviewStats.totalNotices || 0 }}</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon">
          <el-icon size="32"><View /></el-icon>
        </div>
        <div class="stat-content">
          <h3>总浏览量</h3>
          <p class="number">{{ accessStats.totalVisits || 0 }}</p>
        </div>
      </div>
    </div>

    <!-- 详细统计 -->
    <div class="detailed-stats">
      <el-row :gutter="20">
        <el-col :span="12">
          <div class="chart-card">
            <h3>用户统计</h3>
            <div class="chart-content">
              <div class="stat-item">
                <span>管理员：</span>
                <span class="number">{{ userStats.adminCount || 0 }}</span>
              </div>
              <div class="stat-item">
                <span>平台管理员：</span>
                <span class="number">{{ userStats.managerCount || 0 }}</span>
              </div>
              <div class="stat-item">
                <span>普通用户：</span>
                <span class="number">{{ userStats.userCount || 0 }}</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="chart-card">
            <h3>文化遗产统计</h3>
            <div class="chart-content">
              <div class="stat-item">
                <span>已发布：</span>
                <span class="number">{{ heritageStats.publishedHeritage || 0 }}</span>
              </div>
              <div class="stat-item">
                <span>草稿：</span>
                <span class="number">{{ heritageStats.draftHeritage || 0 }}</span>
              </div>
              <div class="stat-item">
                <span>总计：</span>
                <span class="number">{{ heritageStats.totalHeritage || 0 }}</span>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 系统性能 -->
    <div class="performance-stats">
      <h3>系统性能</h3>
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="performance-card">
            <h4>内存使用率</h4>
            <el-progress :percentage="Math.round(performance.heapUsagePercent || 0)" />
          </div>
        </el-col>
        <el-col :span="6">
          <div class="performance-card">
            <h4>数据库状态</h4>
            <el-tag :type="dbStatus.status === '正常' ? 'success' : 'danger'">
              {{ dbStatus.status || '未知' }}
            </el-tag>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="performance-card">
            <h4>缓存状态</h4>
            <el-tag :type="cacheStatus.status === '正常' ? 'success' : 'danger'">
              {{ cacheStatus.status || '未知' }}
            </el-tag>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="performance-card">
            <h4>系统运行时间</h4>
            <span>{{ formatUptime(overviewStats.uptime) }}</span>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { User, Collection, Bell, View } from '@element-plus/icons-vue'

const overviewStats = ref({})
const userStats = ref({})
const heritageStats = ref({})
const accessStats = ref({})
const performance = ref({})
const dbStatus = ref({})
const cacheStatus = ref({})

const loadDashboardData = async () => {
  try {
    // 这里应该调用实际的API获取数据
    // 暂时使用模拟数据
    overviewStats.value = {
      totalUsers: 1250,
      totalHeritage: 180,
      totalNotices: 25
    }
    
    userStats.value = {
      adminCount: 5,
      managerCount: 12,
      userCount: 1233
    }
    
    heritageStats.value = {
      publishedHeritage: 150,
      draftHeritage: 30,
      totalHeritage: 180
    }
    
    accessStats.value = {
      totalVisits: 25000
    }
    
    performance.value = {
      heapUsagePercent: 65
    }
    
    dbStatus.value = {
      status: '正常'
    }
    
    cacheStatus.value = {
      status: '正常'
    }
  } catch (error) {
    console.error('加载仪表板数据失败:', error)
  }
}

const formatUptime = (uptime: number) => {
  if (!uptime) return '未知'
  const days = Math.floor(uptime / (1000 * 60 * 60 * 24))
  const hours = Math.floor((uptime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
  return `${days}天${hours}小时`
}

onMounted(() => {
  loadDashboardData()
})
</script>

<style scoped lang="scss">
.dashboard {
  h1 {
    margin-bottom: 30px;
    color: #333;
  }
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  gap: 15px;
  
  .stat-icon {
    color: #409eff;
    background: #f0f9ff;
    padding: 15px;
    border-radius: 8px;
  }
  
  .stat-content {
    flex: 1;
    
    h3 {
      margin-bottom: 8px;
      color: #666;
      font-size: 1rem;
    }
      
      .number {
        font-size: 2rem;
        font-weight: bold;
        color: #409eff;
        margin: 0;
      }
  }
}

.detailed-stats {
  margin-bottom: 30px;
  
  .chart-card {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    
    h3 {
      margin-bottom: 20px;
      color: #333;
    }
    
    .chart-content {
      .stat-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 0;
        border-bottom: 1px solid #f0f0f0;
        
        &:last-child {
          border-bottom: none;
        }
        
        .number {
          font-weight: bold;
          color: #409eff;
        }
      }
    }
  }
}

.performance-stats {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  
  h3 {
    margin-bottom: 20px;
    color: #333;
  }
  
  .performance-card {
    text-align: center;
    
    h4 {
      margin-bottom: 10px;
      color: #666;
      font-size: 0.9rem;
    }
  }
}
</style>
