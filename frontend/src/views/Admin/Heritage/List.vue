<template>
  <div class="admin-heritage">
    <h1>文化遗产管理</h1>
    
    <!-- 搜索和筛选 -->
    <div class="toolbar">
      <div class="search-bar">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索文化遗产名称"
          style="width: 200px; margin-right: 10px;"
          @keyup.enter="loadHeritageList"
        >
          <template #append>
            <el-button @click="loadHeritageList">搜索</el-button>
          </template>
        </el-input>
        <el-select
          v-model="selectedCategory"
          placeholder="选择类别"
          style="width: 150px; margin-right: 10px;"
          @change="loadHeritageList"
        >
          <el-option label="全部" value="" />
          <el-option label="古建筑" value="古建筑" />
          <el-option label="文物" value="文物" />
          <el-option label="遗址" value="遗址" />
        </el-select>
        <el-button type="primary" @click="showAddDialog = true">
          <el-icon><Plus /></el-icon>
          添加文化遗产
        </el-button>
      </div>
    </div>

    <!-- 文化遗产表格 -->
    <div class="heritage-table">
      <el-table 
        :data="heritageList" 
        style="width: 100%"
        v-loading="loading"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="heritageName" label="名称" min-width="150" />
        <el-table-column prop="category" label="类别" width="100" />
        <el-table-column prop="era" label="年代" width="100" />
        <el-table-column prop="location" label="地点" width="120" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === '已发布' ? 'success' : 'warning'">
              {{ row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览量" width="80" />
        <el-table-column prop="createTime" label="创建时间" width="150">
          <template #default="{ row }">
            {{ formatDate(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="editHeritage(row)">编辑</el-button>
            <el-button 
              size="small" 
              :type="row.status === '已发布' ? 'warning' : 'success'"
              @click="toggleStatus(row)"
            >
              {{ row.status === '已发布' ? '下架' : '发布' }}
            </el-button>
            <el-button size="small" type="danger" @click="deleteHeritage(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadHeritageList"
          @current-change="loadHeritageList"
        />
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      v-model="showAddDialog"
      :title="editingHeritage ? '编辑文化遗产' : '添加文化遗产'"
      width="600px"
    >
      <el-form :model="heritageForm" label-width="100px">
        <el-form-item label="名称" required>
          <el-input v-model="heritageForm.heritageName" />
        </el-form-item>
        <el-form-item label="类别" required>
          <el-select v-model="heritageForm.category" style="width: 100%">
            <el-option label="古建筑" value="古建筑" />
            <el-option label="文物" value="文物" />
            <el-option label="遗址" value="遗址" />
          </el-select>
        </el-form-item>
        <el-form-item label="年代">
          <el-input v-model="heritageForm.era" />
        </el-form-item>
        <el-form-item label="地点">
          <el-input v-model="heritageForm.location" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="heritageForm.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="heritageForm.status" style="width: 100%">
            <el-option label="草稿" value="草稿" />
            <el-option label="已发布" value="已发布" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="saveHeritage">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

const loading = ref(false)
const heritageList = ref([])
const selectedHeritage = ref([])
const searchKeyword = ref('')
const selectedCategory = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

const showAddDialog = ref(false)
const editingHeritage = ref(null)
const heritageForm = ref({
  heritageName: '',
  category: '',
  era: '',
  location: '',
  description: '',
  status: '草稿'
})

const loadHeritageList = async () => {
  loading.value = true
  try {
    // 这里应该调用实际的API
    // 暂时使用模拟数据
    const mockData = [
      {
        heritageId: 1,
        heritageName: '故宫博物院',
        category: '古建筑',
        era: '明清',
        location: '北京市',
        status: '已发布',
        viewCount: 1250,
        createTime: '2024-01-15 10:30:00'
      },
      {
        heritageId: 2,
        heritageName: '长城',
        category: '古建筑',
        era: '秦朝',
        location: '北京市',
        status: '已发布',
        viewCount: 2100,
        createTime: '2024-01-16 14:20:00'
      },
      {
        heritageId: 3,
        heritageName: '兵马俑',
        category: '文物',
        era: '秦朝',
        location: '陕西省',
        status: '草稿',
        viewCount: 0,
        createTime: '2024-01-17 09:15:00'
      }
    ]
    
    heritageList.value = mockData
    total.value = mockData.length
  } catch (error) {
    ElMessage.error('加载文化遗产列表失败')
  } finally {
    loading.value = false
  }
}

const handleSelectionChange = (selection: any[]) => {
  selectedHeritage.value = selection
}

const editHeritage = (heritage: any) => {
  editingHeritage.value = heritage
  heritageForm.value = { ...heritage }
  showAddDialog.value = true
}

const saveHeritage = async () => {
  try {
    // 这里应该调用实际的API
    ElMessage.success(editingHeritage.value ? '更新成功' : '添加成功')
    showAddDialog.value = false
    editingHeritage.value = null
    heritageForm.value = {
      heritageName: '',
      category: '',
      era: '',
      location: '',
      description: '',
      status: '草稿'
    }
    loadHeritageList()
  } catch (error) {
    ElMessage.error('保存失败')
  }
}

const toggleStatus = async (heritage: any) => {
  try {
    const newStatus = heritage.status === '已发布' ? '草稿' : '已发布'
    // 这里应该调用实际的API
    heritage.status = newStatus
    ElMessage.success(`已${newStatus === '已发布' ? '发布' : '下架'}`)
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteHeritage = async (heritage: any) => {
  try {
    await ElMessageBox.confirm('确定要删除这个文化遗产吗？', '确认删除', {
      type: 'warning'
    })
    // 这里应该调用实际的API
    ElMessage.success('删除成功')
    loadHeritageList()
  } catch (error) {
    // 用户取消删除
  }
}

const formatDate = (dateString: string) => {
  if (!dateString) return ''
  return new Date(dateString).toLocaleDateString('zh-CN')
}

onMounted(() => {
  loadHeritageList()
})
</script>

<style scoped lang="scss">
.admin-heritage {
  h1 {
    margin-bottom: 30px;
    color: #333;
  }
  
  .toolbar {
    margin-bottom: 20px;
    
    .search-bar {
      display: flex;
      align-items: center;
      gap: 10px;
    }
  }
  
  .heritage-table {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    
    .pagination {
      margin-top: 20px;
      display: flex;
      justify-content: center;
    }
  }
}
</style>
