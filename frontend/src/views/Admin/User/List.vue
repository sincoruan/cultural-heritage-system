<template>
  <div class="admin-user">
    <div class="user-header">
      <h1>用户管理</h1>
      <el-button type="primary" @click="showCreateDialog = true">
        <el-icon><Plus /></el-icon>
        创建用户
      </el-button>
    </div>

    <!-- 搜索和筛选 -->
    <div class="user-filters">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索用户名或邮箱"
        style="width: 300px; margin-right: 20px;"
        @input="handleSearch"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
      <el-select v-model="filterUserType" placeholder="用户类型" style="width: 150px;" @change="handleSearch">
        <el-option label="全部" value="" />
        <el-option label="管理员" value="ADMIN" />
        <el-option label="普通用户" value="USER" />
      </el-select>
    </div>

    <!-- 用户列表 -->
    <div class="user-table">
      <el-table :data="userList" style="width: 100%" v-loading="loading">
        <el-table-column prop="userName" label="用户名" width="120" />
        <el-table-column prop="nickName" label="昵称" width="120" />
        <el-table-column prop="email" label="邮箱" width="200" />
        <el-table-column prop="phoneNumber" label="手机号" width="130" />
        <el-table-column label="角色" width="100">
          <template #default="{ row }">
            <el-tag :type="getRoleType(row.roles)">
              {{ getRoleName(row.roles) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 'ACTIVE' ? 'success' : 'danger'">
              {{ row.status === 'ACTIVE' ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="editUser(row)">编辑</el-button>
            <el-button size="small" type="warning" @click="resetPassword(row)">重置密码</el-button>
            <el-button 
              size="small" 
              :type="row.status === 'ACTIVE' ? 'danger' : 'success'"
              @click="toggleStatus(row)"
            >
              {{ row.status === 'ACTIVE' ? '禁用' : '启用' }}
            </el-button>
            <el-button size="small" type="danger" @click="deleteUser(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 创建用户对话框 -->
    <el-dialog v-model="showCreateDialog" title="创建用户" width="600px">
      <el-form :model="createForm" :rules="createRules" ref="createFormRef" label-width="100px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="createForm.userName" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="昵称" prop="nickName">
          <el-input v-model="createForm.nickName" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="createForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phoneNumber">
          <el-input v-model="createForm.phoneNumber" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="createForm.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="角色" prop="roles">
          <el-select v-model="createForm.roles" multiple placeholder="请选择角色">
            <el-option label="系统管理员" value="00" />
            <el-option label="平台管理员" value="01" />
            <el-option label="普通用户" value="02" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateDialog = false">取消</el-button>
        <el-button type="primary" @click="createUser" :loading="creating">创建</el-button>
      </template>
    </el-dialog>

    <!-- 编辑用户对话框 -->
    <el-dialog v-model="showEditDialog" title="编辑用户" width="600px">
      <el-form :model="editForm" :rules="editRules" ref="editFormRef" label-width="100px">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="editForm.userName" :disabled="true" />
        </el-form-item>
        <el-form-item label="昵称" prop="nickName">
          <el-input v-model="editForm.nickName" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phoneNumber">
          <el-input v-model="editForm.phoneNumber" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="角色" prop="roles">
          <el-select v-model="editForm.roles" multiple placeholder="请选择角色">
            <el-option label="系统管理员" value="00" />
            <el-option label="平台管理员" value="01" />
            <el-option label="普通用户" value="02" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showEditDialog = false">取消</el-button>
        <el-button type="primary" @click="updateUser" :loading="updating">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search } from '@element-plus/icons-vue'
import { getUserList, createUser, updateUser, deleteUser, resetUserPassword, toggleUserStatus } from '@/api/user'

// 响应式数据
const loading = ref(false)
const userList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const searchKeyword = ref('')
const filterUserType = ref('')

// 对话框状态
const showCreateDialog = ref(false)
const showEditDialog = ref(false)
const creating = ref(false)
const updating = ref(false)

// 表单数据
const createForm = ref({
  userName: '',
  nickName: '',
  email: '',
  phoneNumber: '',
  password: '',
  roles: []
})

const editForm = ref({
  userId: null,
  userName: '',
  nickName: '',
  email: '',
  phoneNumber: '',
  roles: []
})

// 表单验证规则
const createRules = {
  userName: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
  ],
  nickName: [
    { required: true, message: '请输入昵称', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ],
  roles: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
}

const editRules = {
  nickName: [
    { required: true, message: '请输入昵称', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ]
}

// 加载用户列表
const loadUserList = async () => {
  loading.value = true
  try {
    const response = await getUserList({
      page: currentPage.value - 1,
      size: pageSize.value,
      keyword: searchKeyword.value,
      userType: filterUserType.value
    })
    if (response.code === 200) {
      userList.value = response.data.content || []
      total.value = response.data.totalElements || 0
    }
  } catch (error) {
    ElMessage.error('加载用户列表失败')
    console.error('加载用户列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1
  loadUserList()
}

// 分页处理
const handleSizeChange = (size: number) => {
  pageSize.value = size
  currentPage.value = 1
  loadUserList()
}

const handleCurrentChange = (page: number) => {
  currentPage.value = page
  loadUserList()
}

// 角色相关
const getRoleType = (roles: string[]) => {
  if (roles.includes('00')) return 'danger'
  if (roles.includes('01')) return 'warning'
  return 'info'
}

const getRoleName = (roles: string[]) => {
  if (roles.includes('00')) return '系统管理员'
  if (roles.includes('01')) return '平台管理员'
  return '普通用户'
}

// 创建用户
const createUser = async () => {
  try {
    creating.value = true
    const response = await createUser(createForm.value)
    if (response.code === 200) {
      ElMessage.success('创建用户成功')
      showCreateDialog.value = false
      createForm.value = {
        userName: '',
        nickName: '',
        email: '',
        phoneNumber: '',
        password: '',
        roles: []
      }
      loadUserList()
    }
  } catch (error) {
    ElMessage.error('创建用户失败')
    console.error('创建用户失败:', error)
  } finally {
    creating.value = false
  }
}

// 编辑用户
const editUser = (row: any) => {
  editForm.value = {
    userId: row.userId,
    userName: row.userName,
    nickName: row.nickName,
    email: row.email,
    phoneNumber: row.phoneNumber,
    roles: row.roles || []
  }
  showEditDialog.value = true
}

// 更新用户
const updateUser = async () => {
  try {
    updating.value = true
    const response = await updateUser(editForm.value)
    if (response.code === 200) {
      ElMessage.success('更新用户成功')
      showEditDialog.value = false
      loadUserList()
    }
  } catch (error) {
    ElMessage.error('更新用户失败')
    console.error('更新用户失败:', error)
  } finally {
    updating.value = false
  }
}

// 删除用户
const deleteUser = async (row: any) => {
  try {
    await ElMessageBox.confirm('确定要删除该用户吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    const response = await deleteUser(row.userId)
    if (response.code === 200) {
      ElMessage.success('删除用户成功')
      loadUserList()
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除用户失败')
      console.error('删除用户失败:', error)
    }
  }
}

// 重置密码
const resetPassword = async (row: any) => {
  try {
    await ElMessageBox.confirm('确定要重置该用户的密码吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    const response = await resetUserPassword(row.userId)
    if (response.code === 200) {
      ElMessage.success('重置密码成功')
    }
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('重置密码失败')
      console.error('重置密码失败:', error)
    }
  }
}

// 切换用户状态
const toggleStatus = async (row: any) => {
  try {
    const response = await toggleUserStatus(row.userId)
    if (response.code === 200) {
      ElMessage.success('操作成功')
      loadUserList()
    }
  } catch (error) {
    ElMessage.error('操作失败')
    console.error('操作失败:', error)
  }
}

// 页面加载时获取用户列表
onMounted(() => {
  loadUserList()
})
</script>

<style scoped lang="scss">
.admin-user {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.user-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  
  h1 {
    margin: 0;
    color: #303133;
  }
}

.user-filters {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.user-table {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

// 标签样式
:deep(.el-tag) {
  &.el-tag--danger {
    background: #fef0f0;
    color: #f56c6c;
    border-color: #fbc4c4;
  }
  
  &.el-tag--warning {
    background: #fdf6ec;
    color: #e6a23c;
    border-color: #f5dab1;
  }
  
  &.el-tag--info {
    background: #f4f4f5;
    color: #909399;
    border-color: #d3d4d6;
  }
  
  &.el-tag--success {
    background: #f0f9ff;
    color: #67c23a;
    border-color: #b3e19d;
  }
}
</style>