<template>
  <div class="multimedia-container">
    <AppHeader />
    
    <div class="multimedia-header">
      <h1>多媒体展示</h1>
      <p>沉浸式体验文化遗产的多媒体内容</p>
    </div>
    
    <div class="multimedia-content">
      <div class="media-tabs">
        <el-tabs v-model="activeTab" class="demo-tabs">
        <el-tab-pane label="图片展示" name="images">
          <div class="images-section">
            <div class="section-header">
              <h3>精美图片</h3>
              <el-button type="primary" @click="showUploadDialog = true">
                <el-icon><Upload /></el-icon>
                上传图片
              </el-button>
            </div>
            <div class="images-grid">
              <div v-for="item in imageItems" :key="item.id" class="image-item">
                <img :src="item.imageUrl" :alt="item.title" @click="viewImage(item)" />
                <div class="image-overlay">
                  <h4>{{ item.title }}</h4>
                  <p>{{ item.description }}</p>
                  <div class="image-actions">
                    <el-button type="primary" size="small" @click.stop="viewImage(item)">查看</el-button>
                    <el-button type="danger" size="small" @click.stop="deleteImage(item)">删除</el-button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>
          
          <el-tab-pane label="视频展示" name="videos">
            <div class="videos-section">
              <div class="section-header">
                <h3>精彩视频</h3>
                <el-button type="primary" @click="showUploadDialog = true; uploadTab = 'video'">
                  <el-icon><Upload /></el-icon>
                  上传视频
                </el-button>
              </div>
              <div class="videos-grid">
                <div v-for="item in videoItems" :key="item.id" class="video-item">
                  <div class="video-thumbnail" @click="playVideo(item)">
                    <img :src="item.thumbnail" :alt="item.title" />
                    <div class="play-button">
                      <el-icon size="48"><VideoPlay /></el-icon>
                    </div>
                  </div>
                  <div class="video-info">
                    <h4>{{ item.title }}</h4>
                    <p>{{ item.description }}</p>
                    <span class="duration">{{ item.duration }}</span>
                    <div class="video-actions">
                      <el-button type="primary" size="small" @click="playVideo(item)">播放</el-button>
                      <el-button type="danger" size="small" @click="deleteVideo(item)">删除</el-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="3D模型" name="models">
            <div class="models-section">
              <div class="section-header">
                <h3>3D模型展示</h3>
                <el-button type="primary" @click="showUploadDialog = true; uploadTab = 'model'">
                  <el-icon><Upload /></el-icon>
                  上传3D模型
                </el-button>
              </div>
              <div class="models-grid">
                <div v-for="item in modelItems" :key="item.id" class="model-item">
                  <div class="model-preview" @click="viewModel(item)">
                    <img :src="item.preview" :alt="item.title" />
                    <div class="model-overlay">
                      <el-icon size="32"><View /></el-icon>
                    </div>
                  </div>
                  <div class="model-info">
                    <h4>{{ item.title }}</h4>
                    <p>{{ item.description }}</p>
                    <div class="model-actions">
                      <el-button type="primary" size="small" @click="viewModel(item)">查看3D模型</el-button>
                      <el-button type="danger" size="small" @click="deleteModel(item)">删除</el-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
          
          <el-tab-pane label="全景展示" name="panorama">
            <div class="panorama-section">
              <div class="section-header">
                <h3>360°全景展示</h3>
                <el-button type="primary" @click="showUploadDialog = true; uploadTab = 'panorama'">
                  <el-icon><Upload /></el-icon>
                  上传全景
                </el-button>
              </div>
              <div class="panorama-grid">
                <div v-for="item in panoramaItems" :key="item.id" class="panorama-item">
                  <div class="panorama-preview" @click="viewPanorama(item)">
                    <img :src="item.thumbnail" :alt="item.title" />
                    <div class="panorama-overlay">
                      <el-icon size="32"><Location /></el-icon>
                      <span>360°全景</span>
                    </div>
                  </div>
                  <div class="panorama-info">
                    <h4>{{ item.title }}</h4>
                    <p>{{ item.description }}</p>
                    <div class="panorama-actions">
                      <el-button type="primary" size="small" @click="viewPanorama(item)">进入全景</el-button>
                      <el-button type="danger" size="small" @click="deletePanorama(item)">删除</el-button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
    
    <!-- 图片查看器 -->
    <el-dialog v-model="imageViewerVisible" title="图片查看" width="80%" center>
      <div class="image-viewer">
        <img :src="selectedImage?.imageUrl" :alt="selectedImage?.title" style="width: 100%; max-height: 70vh; object-fit: contain;" />
        <div class="image-details">
          <h3>{{ selectedImage?.title }}</h3>
          <p>{{ selectedImage?.description }}</p>
        </div>
      </div>
    </el-dialog>
    
    <!-- 视频播放器 -->
    <el-dialog v-model="videoPlayerVisible" title="视频播放" width="80%" center>
      <div class="video-player">
        <video v-if="selectedVideo" :src="selectedVideo.thumbnail" controls style="width: 100%; max-height: 70vh;">
          您的浏览器不支持视频播放
        </video>
        <div class="video-details">
          <h3>{{ selectedVideo?.title }}</h3>
          <p>{{ selectedVideo?.description }}</p>
        </div>
      </div>
    </el-dialog>
    
    <!-- 文件上传对话框 -->
    <el-dialog v-model="showUploadDialog" title="上传多媒体文件" width="600px" center>
      <el-tabs v-model="uploadTab" class="upload-tabs">
        <el-tab-pane label="上传图片" name="image">
          <FileUpload 
            media-type="image" 
            @upload-success="handleUploadSuccess"
            @upload-error="handleUploadError"
          />
        </el-tab-pane>
        <el-tab-pane label="上传视频" name="video">
          <FileUpload 
            media-type="video" 
            @upload-success="handleUploadSuccess"
            @upload-error="handleUploadError"
          />
        </el-tab-pane>
        <el-tab-pane label="上传3D模型" name="model">
          <FileUpload 
            media-type="model" 
            @upload-success="handleUploadSuccess"
            @upload-error="handleUploadError"
          />
        </el-tab-pane>
        <el-tab-pane label="上传全景" name="panorama">
          <FileUpload 
            media-type="panorama" 
            @upload-success="handleUploadSuccess"
            @upload-error="handleUploadError"
          />
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'
import AppHeader from '@/components/AppHeader.vue'
import FileUpload from '@/components/FileUpload.vue'
import { getMediaFiles, deleteMediaFile } from '@/api/media'

const router = useRouter()

const activeTab = ref('images')
const imageViewerVisible = ref(false)
const videoPlayerVisible = ref(false)
const selectedImage = ref(null)
const selectedVideo = ref(null)
const showUploadDialog = ref(false)
const uploadTab = ref('image')

// 多媒体数据
const imageItems = ref([])
const videoItems = ref([])
const modelItems = ref([])
const panoramaItems = ref([])
const loading = ref(false)

// 加载多媒体数据
const loadMediaData = async () => {
  loading.value = true
  try {
    // 加载图片数据
    const imageResponse = await getMediaFiles('image')
    if (imageResponse.code === 200) {
      imageItems.value = (imageResponse.data.content || []).map(item => ({
        ...item,
        imageUrl: `http://localhost:8080/api${item.mediaUrl}`,
        title: item.mediaName,
        description: `文件大小: ${(item.fileSize / 1024 / 1024).toFixed(2)}MB`
      }))
    }
    
    // 加载视频数据
    const videoResponse = await getMediaFiles('video')
    if (videoResponse.code === 200) {
      videoItems.value = (videoResponse.data.content || []).map(item => ({
        ...item,
        thumbnail: `http://localhost:8080/api${item.mediaUrl}`,
        title: item.mediaName,
        description: `文件大小: ${(item.fileSize / 1024 / 1024).toFixed(2)}MB`,
        duration: '未知时长'
      }))
    }
    
    // 加载3D模型数据
    const modelResponse = await getMediaFiles('model')
    if (modelResponse.code === 200) {
      modelItems.value = (modelResponse.data.content || []).map(item => ({
        ...item,
        preview: `http://localhost:8080/api${item.mediaUrl}`,
        title: item.mediaName,
        description: `文件大小: ${(item.fileSize / 1024 / 1024).toFixed(2)}MB`
      }))
    }
    
    // 加载全景数据
    const panoramaResponse = await getMediaFiles('panorama')
    if (panoramaResponse.code === 200) {
      panoramaItems.value = (panoramaResponse.data.content || []).map(item => ({
        ...item,
        thumbnail: `http://localhost:8080/api${item.mediaUrl}`,
        title: item.mediaName,
        description: `文件大小: ${(item.fileSize / 1024 / 1024).toFixed(2)}MB`
      }))
    }
  } catch (error) {
    console.error('加载多媒体数据失败:', error)
    ElMessage.error('加载多媒体数据失败')
  } finally {
    loading.value = false
  }
}

// 上传成功处理
const handleUploadSuccess = (data: any) => {
  ElMessage.success('文件上传成功')
  showUploadDialog.value = false
  // 重新加载数据
  loadMediaData()
}

// 上传失败处理
const handleUploadError = (error: any) => {
  ElMessage.error('文件上传失败')
  console.error('上传失败:', error)
}

const viewImage = (item: any) => {
  selectedImage.value = item
  imageViewerVisible.value = true
}

const playVideo = (item: any) => {
  selectedVideo.value = item
  videoPlayerVisible.value = true
}

const viewModel = (item: any) => {
  // 这里可以集成3D模型查看器
  console.log('查看3D模型:', item)
}

const viewPanorama = (item: any) => {
  // 这里可以集成全景查看器
  console.log('查看全景:', item)
}

// 删除方法
const deleteImage = async (item: any) => {
  try {
    await ElMessageBox.confirm('确定要删除这张图片吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await deleteMediaFile(item.mediaId)
    ElMessage.success('图片删除成功')
    loadMediaData() // 重新加载数据
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除图片失败:', error)
    }
  }
}

const deleteVideo = async (item: any) => {
  try {
    await ElMessageBox.confirm('确定要删除这个视频吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await deleteMediaFile(item.mediaId)
    ElMessage.success('视频删除成功')
    loadMediaData() // 重新加载数据
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除视频失败:', error)
    }
  }
}

const deleteModel = async (item: any) => {
  try {
    await ElMessageBox.confirm('确定要删除这个3D模型吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await deleteMediaFile(item.mediaId)
    ElMessage.success('3D模型删除成功')
    loadMediaData() // 重新加载数据
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除3D模型失败:', error)
    }
  }
}

const deletePanorama = async (item: any) => {
  try {
    await ElMessageBox.confirm('确定要删除这个全景图片吗？', '确认删除', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await deleteMediaFile(item.mediaId)
    ElMessage.success('全景图片删除成功')
    loadMediaData() // 重新加载数据
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('删除全景图片失败:', error)
    }
  }
}

onMounted(() => {
  loadMediaData()
})
</script>

<style scoped lang="scss">
.multimedia-container {
  min-height: 100vh;
  background: #f5f7fa;
}

.multimedia-header {
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

.multimedia-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px;
}

.media-tabs {
  background: white;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #eee;
  
  h3 {
    margin: 0;
    color: #333;
  }
}

.images-grid, .videos-grid, .models-grid, .panorama-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  padding: 20px;
}

.image-item, .video-item, .model-item, .panorama-item {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  cursor: pointer;
  
  &:hover {
    transform: translateY(-5px);
  }
}

.image-item {
  position: relative;
  
  img {
    width: 100%;
    height: 200px;
    object-fit: cover;
  }
  
  .image-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
    color: white;
    padding: 20px;
    
    h4 {
      margin-bottom: 8px;
    }
    
    .image-actions {
      margin-top: 10px;
      display: flex;
      gap: 8px;
    }
  }
}

.video-item {
  .video-thumbnail {
    position: relative;
    
    img {
      width: 100%;
      height: 200px;
      object-fit: cover;
    }
    
    .play-button {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: white;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 50%;
      width: 80px;
      height: 80px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
  
  .video-info {
    padding: 15px;
    
    h4 {
      margin-bottom: 8px;
    }
    
    .duration {
      color: #999;
      font-size: 0.9rem;
    }
    
    .video-actions {
      margin-top: 10px;
      display: flex;
      gap: 8px;
    }
  }
}

.model-item, .panorama-item {
  .model-preview, .panorama-preview {
    position: relative;
    
    img {
      width: 100%;
      height: 200px;
      object-fit: cover;
    }
    
    .model-overlay, .panorama-overlay {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      color: white;
      background: rgba(0, 0, 0, 0.7);
      border-radius: 50%;
      width: 60px;
      height: 60px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      gap: 5px;
      
      span {
        font-size: 0.8rem;
      }
    }
  }
  
  .model-info, .panorama-info {
    padding: 15px;
    
    h4 {
      margin-bottom: 8px;
    }
    
    .model-actions, .panorama-actions {
      margin-top: 10px;
      display: flex;
      gap: 8px;
    }
  }
}

.image-viewer, .video-player {
  text-align: center;
  
  .image-details, .video-details {
    margin-top: 20px;
    text-align: left;
    
    h3 {
      margin-bottom: 10px;
    }
  }
}
</style>
