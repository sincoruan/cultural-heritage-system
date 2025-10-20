import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_APP_API_BASE_URL || 'http://localhost:8080/api'

// 获取多媒体文件列表
export const getMediaFiles = async (mediaType: string, page: number = 0, size: number = 100) => {
  try {
    const response = await axios.get(`${API_BASE_URL}/media/type/${mediaType}`, {
      params: { page, size }
    })
    return response.data
  } catch (error) {
    console.error('获取多媒体文件失败:', error)
    throw error
  }
}

// 添加多媒体文件
export const addMediaFile = async (mediaData: any) => {
  try {
    const response = await axios.post(`${API_BASE_URL}/media`, mediaData)
    return response.data
  } catch (error) {
    console.error('添加多媒体文件失败:', error)
    throw error
  }
}

// 删除多媒体文件
export const deleteMediaFile = async (mediaId: number) => {
  try {
    const response = await axios.delete(`${API_BASE_URL}/media/${mediaId}`)
    return response.data
  } catch (error) {
    console.error('删除多媒体文件失败:', error)
    throw error
  }
}
