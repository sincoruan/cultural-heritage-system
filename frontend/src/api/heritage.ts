import request from '@/utils/request'

// 文化遗产接口类型定义
export interface Heritage {
  heritageId: number
  heritageName: string
  category: string
  description: string
  era: string
  location: string
  protectionLevel: string
  status: string
  viewCount: number
  likeCount: number
  collectCount: number
  commentCount: number
  imageUrl?: string
  createTime: string
  updateTime: string
}

export interface HeritageListParams {
  page?: number
  size?: number
  keyword?: string
  category?: string
  protectionLevel?: string
  status?: string
}

export interface HeritageListResponse {
  content: Heritage[]
  totalElements: number
  totalPages: number
  size: number
  number: number
}

// 获取文化遗产列表
export function getHeritageList(params: HeritageListParams) {
  return request({
    url: '/api/heritage/list',
    method: 'get',
    params
  })
}

// 获取文化遗产详情
export function getHeritageDetail(heritageId: number) {
  return request({
    url: `/heritage/${heritageId}`,
    method: 'get'
  })
}

// 搜索文化遗产
export function searchHeritage(keyword: string, params?: HeritageListParams) {
  return request({
    url: '/heritage/search',
    method: 'get',
    params: {
      keyword,
      ...params
    }
  })
}

// 获取文化遗产分类
export function getHeritageCategories() {
  return request({
    url: '/heritage/categories',
    method: 'get'
  })
}

// 获取文化遗产统计
export function getHeritageStats() {
  return request({
    url: '/heritage/stats',
    method: 'get'
  })
}

// 点赞文化遗产
export function likeHeritage(heritageId: number) {
  return request({
    url: `/heritage/${heritageId}/like`,
    method: 'post'
  })
}

// 收藏文化遗产
export function collectHeritage(heritageId: number) {
  return request({
    url: `/heritage/${heritageId}/collect`,
    method: 'post'
  })
}

// 取消收藏文化遗产
export function uncollectHeritage(heritageId: number) {
  return request({
    url: `/heritage/${heritageId}/uncollect`,
    method: 'delete'
  })
}

// 获取用户收藏的文化遗产
export function getUserCollections(params?: HeritageListParams) {
  return request({
    url: '/heritage/collections',
    method: 'get',
    params
  })
}
