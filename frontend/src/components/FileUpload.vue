<template>
  <div class="file-upload">
    <el-upload
      :action="uploadUrl"
      :headers="uploadHeaders"
      :data="uploadData"
      :before-upload="beforeUpload"
      :on-change="handleFileChange"
      :on-success="handleSuccess"
      :on-error="handleError"
      :on-progress="handleProgress"
      :show-file-list="false"
      :accept="acceptTypes"
      :multiple="multiple"
      :auto-upload="false"
      drag
    >
      <div class="upload-area">
        <el-icon size="48" class="upload-icon">
          <Upload />
        </el-icon>
        <div class="upload-text">
          <p>点击或拖拽文件到此处上传</p>
          <p class="upload-hint">{{ uploadHint }}</p>
        </div>
      </div>
    </el-upload>
    
    <!-- 上传进度 -->
    <div v-if="uploading" class="upload-progress">
      <el-progress :percentage="uploadProgress" />
    </div>
    
    <!-- 文件列表 -->
    <div v-if="fileList.length > 0" class="file-list">
      <h4>已选择文件：</h4>
      <div class="file-items">
        <div v-for="(file, index) in fileList" :key="index" class="file-item">
          <div class="file-info">
            <el-icon><Document /></el-icon>
            <span class="file-name">{{ file.fileName }}</span>
            <span class="file-size">{{ formatFileSize(file.fileSize) }}</span>
          </div>
          <div class="file-actions">
            <el-button size="small" @click="showPreview(file)">预览</el-button>
            <el-button size="small" type="danger" @click="removeFile(index)">删除</el-button>
          </div>
        </div>
      </div>
      
      <!-- 上传按钮 -->
      <div class="upload-actions">
        <el-button 
          type="primary" 
          :loading="uploading" 
          :disabled="uploading || fileList.length === 0"
          @click="uploadFiles"
        >
          <el-icon><Upload /></el-icon>
          {{ uploading ? '上传中...' : '开始上传' }}
        </el-button>
        <el-button @click="clearFiles" :disabled="uploading">
          清空列表
        </el-button>
      </div>
    </div>
    
    <!-- 文件预览对话框 -->
    <el-dialog v-model="previewVisible" title="文件预览" width="80%">
      <div class="preview-content">
        <img v-if="previewFile.type === 'image'" :src="previewFile.url" style="max-width: 100%; max-height: 70vh;" />
        <video v-else-if="previewFile.type === 'video'" :src="previewFile.url" controls style="max-width: 100%; max-height: 70vh;">
          您的浏览器不支持视频播放
        </video>
        <div v-else-if="previewFile.type === 'model'" class="model-preview">
          <p>3D模型文件：{{ previewFile.fileName }}</p>
          <p>文件大小：{{ formatFileSize(previewFile.fileSize) }}</p>
          <el-button type="primary" @click="openModelViewer">在3D查看器中打开</el-button>
        </div>
        <div v-else-if="previewFile.type === 'panorama'" class="panorama-preview">
          <p>全景图片：{{ previewFile.fileName }}</p>
          <p>文件大小：{{ formatFileSize(previewFile.fileSize) }}</p>
          <el-button type="primary" @click="openPanoramaViewer">在全景查看器中打开</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { Upload, Document } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/user'
import { addMediaFile } from '@/api/media'

interface FileItem {
  fileName: string
  fileUrl?: string
  url?: string
  fileSize: number
  contentType: string
  type: string
  file?: File
}

const props = defineProps({
  mediaType: {
    type: String,
    required: true,
    validator: (value: string) => ['image', 'video', 'model', 'panorama'].includes(value)
  },
  multiple: {
    type: Boolean,
    default: false
  },
  heritageId: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['upload-success', 'upload-error', 'file-remove'])

const userStore = useUserStore()
const fileList = ref<FileItem[]>([])
const uploading = ref(false)
const uploadProgress = ref(0)
const previewVisible = ref(false)
const previewFile = ref<FileItem>({} as FileItem)

const uploadUrl = computed(() => {
  const baseUrl = import.meta.env.VITE_APP_API_BASE_URL || 'http://localhost:8080/api'
  return `${baseUrl}/upload/${props.mediaType}`
})

const uploadHeaders = computed(() => {
  const token = userStore.token
  return token ? { Authorization: `Bearer ${token}` } : {}
})

const uploadData = computed(() => {
  const data: any = {}
  if (props.heritageId) {
    data.heritageId = props.heritageId
  }
  return data
})

const acceptTypes = computed(() => {
  switch (props.mediaType) {
    case 'image':
      return 'image/*'
    case 'video':
      return 'video/*'
    case 'model':
      return '.obj,.fbx,.gltf,.glb'
    case 'panorama':
      return 'image/*'
    default:
      return '*'
  }
})

const uploadHint = computed(() => {
  switch (props.mediaType) {
    case 'image':
      return '支持 JPG、PNG、GIF 格式，最大 10MB'
    case 'video':
      return '支持 MP4、AVI、MOV 格式，最大 100MB'
    case 'model':
      return '支持 OBJ、FBX、GLTF、GLB 格式，最大 50MB'
    case 'panorama':
      return '支持 JPG、PNG 格式，最大 20MB'
    default:
      return ''
  }
})

const beforeUpload = (file: File) => {
  // 验证文件类型
  const isValidType = validateFileType(file)
  if (!isValidType) {
    ElMessage.error('文件类型不支持')
    return false
  }
  
  // 验证文件大小
  const isValidSize = validateFileSize(file)
  if (!isValidSize) {
    ElMessage.error('文件大小超出限制')
    return false
  }
  
  return false // 阻止自动上传
}

// 处理文件选择
const handleFileChange = (file: any, fileList: any[]) => {
  if (file.raw) {
    addFileToList(file.raw)
  }
}

const validateFileType = (file: File) => {
  const fileName = file.name.toLowerCase()
  const contentType = file.type
  
  switch (props.mediaType) {
    case 'image':
      return contentType.startsWith('image/')
    case 'video':
      return contentType.startsWith('video/')
    case 'model':
      return fileName.endsWith('.obj') || fileName.endsWith('.fbx') || 
             fileName.endsWith('.gltf') || fileName.endsWith('.glb')
    case 'panorama':
      return contentType.startsWith('image/')
    default:
      return true
  }
}

const validateFileSize = (file: File) => {
  const maxSizes = {
    image: 10 * 1024 * 1024,      // 10MB
    video: 100 * 1024 * 1024,     // 100MB
    model: 50 * 1024 * 1024,      // 50MB
    panorama: 20 * 1024 * 1024    // 20MB
  }
  
  return file.size <= maxSizes[props.mediaType as keyof typeof maxSizes]
}

const handleSuccess = (response: any, file: File) => {
  uploading.value = false
  uploadProgress.value = 0
  
  if (response.code === 200) {
    const fileItem: FileItem = {
      fileName: response.data.fileName,
      fileUrl: response.data.fileUrl,
      fileSize: response.data.fileSize,
      contentType: response.data.contentType,
      type: props.mediaType
    }
    
    fileList.value.push(fileItem)
    emit('upload-success', fileItem)
    ElMessage.success('文件上传成功')
  } else {
    ElMessage.error(response.message || '文件上传失败')
    emit('upload-error', response.message)
  }
}

const handleError = (error: any) => {
  uploading.value = false
  uploadProgress.value = 0
  ElMessage.error('文件上传失败')
  emit('upload-error', error)
}

const handleProgress = (event: any) => {
  uploadProgress.value = Math.round(event.percent)
}

const removeFile = (index: number) => {
  const file = fileList.value[index]
  fileList.value.splice(index, 1)
  emit('file-remove', file)
}

// 添加文件到列表
const addFileToList = (file: File) => {
  const fileItem: FileItem = {
    fileName: file.name,
    fileSize: file.size,
    contentType: file.type,
    type: props.mediaType,
    url: URL.createObjectURL(file),
    file: file
  }
  fileList.value.push(fileItem)
}

// 手动上传文件
const uploadFiles = async () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请先选择文件')
    return
  }
  
  uploading.value = true
  uploadProgress.value = 0
  
  try {
    for (let i = 0; i < fileList.value.length; i++) {
      const fileItem = fileList.value[i]
      const formData = new FormData()
      formData.append('file', fileItem.file)
      
      const response = await fetch(uploadUrl.value, {
        method: 'POST',
        headers: uploadHeaders.value,
        body: formData
      })
      
      const result = await response.json()
      
      if (result.code === 200) {
        fileItem.url = result.data.fileUrl
        fileItem.fileName = result.data.fileName
        fileItem.fileSize = result.data.fileSize
        fileItem.contentType = result.data.contentType
        
        // 保存文件信息到数据库
        try {
          const mediaData = {
            mediaName: result.data.fileName,
            mediaUrl: result.data.fileUrl,
            fileSize: result.data.fileSize,
            mediaType: props.mediaType,
            heritageId: props.heritageId || 1 // 使用默认的heritageId
          }
          await addMediaFile(mediaData)
        } catch (dbError) {
          console.error('保存文件信息到数据库失败:', dbError)
          // 即使数据库保存失败，文件上传已经成功，所以不阻止流程
        }
        
        emit('upload-success', result.data)
        ElMessage.success(`${fileItem.fileName} 上传成功`)
      } else {
        throw new Error(result.message)
      }
      
      uploadProgress.value = Math.round(((i + 1) / fileList.value.length) * 100)
    }
  } catch (error) {
    ElMessage.error('文件上传失败: ' + error)
    emit('upload-error', error)
  } finally {
    uploading.value = false
    uploadProgress.value = 0
  }
}

// 清空文件列表
const clearFiles = () => {
  fileList.value.forEach(file => {
    if (file.url && file.url.startsWith('blob:')) {
      URL.revokeObjectURL(file.url)
    }
  })
  fileList.value = []
}

const showPreview = (file: FileItem) => {
  previewFile.value = file
  previewVisible.value = true
}

const formatFileSize = (size: number) => {
  if (size < 1024) return size + ' B'
  if (size < 1024 * 1024) return Math.round(size / 1024) + ' KB'
  if (size < 1024 * 1024 * 1024) return Math.round(size / (1024 * 1024)) + ' MB'
  return Math.round(size / (1024 * 1024 * 1024)) + ' GB'
}

const openModelViewer = () => {
  // 这里可以集成3D模型查看器
  ElMessage.info('3D模型查看器功能开发中...')
}

const openPanoramaViewer = () => {
  // 这里可以集成全景查看器
  ElMessage.info('全景查看器功能开发中...')
}
</script>

<style scoped lang="scss">
.file-upload {
  .upload-area {
    text-align: center;
    padding: 40px 20px;
    border: 2px dashed #dcdfe6;
    border-radius: 6px;
    transition: border-color 0.3s;
    
    &:hover {
      border-color: #409eff;
    }
    
    .upload-icon {
      color: #c0c4cc;
      margin-bottom: 16px;
    }
    
    .upload-text {
      p {
        margin: 8px 0;
        color: #606266;
      }
      
      .upload-hint {
        font-size: 12px;
        color: #909399;
      }
    }
  }
  
  .upload-progress {
    margin-top: 20px;
  }
  
  .file-list {
    margin-top: 20px;
    
    h4 {
      margin-bottom: 10px;
      color: #303133;
    }
    
    .upload-actions {
      margin-top: 15px;
      padding-top: 15px;
      border-top: 1px solid #ebeef5;
      display: flex;
      gap: 10px;
      justify-content: center;
    }
    
    .file-items {
      .file-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px;
        border: 1px solid #ebeef5;
        border-radius: 4px;
        margin-bottom: 8px;
        
        .file-info {
          display: flex;
          align-items: center;
          gap: 8px;
          
          .file-name {
            font-weight: 500;
          }
          
          .file-size {
            color: #909399;
            font-size: 12px;
          }
        }
        
        .file-actions {
          display: flex;
          gap: 8px;
        }
      }
    }
  }
  
  .preview-content {
    text-align: center;
    
    .model-preview, .panorama-preview {
      padding: 20px;
      
      p {
        margin: 10px 0;
        color: #606266;
      }
    }
  }
}
</style>
