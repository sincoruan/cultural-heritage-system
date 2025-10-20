import request from '@/utils/request'

/**
 * 获取系统概览信息
 */
export function getSystemOverview() {
  return request({
    url: '/admin/monitor/overview',
    method: 'get'
  })
}

/**
 * 获取系统性能信息
 */
export function getSystemPerformance() {
  return request({
    url: '/admin/monitor/performance',
    method: 'get'
  })
}

/**
 * 获取访问统计信息
 */
export function getAccessStats() {
  return request({
    url: '/admin/monitor/access-stats',
    method: 'get'
  })
}

/**
 * 获取数据库状态
 */
export function getDatabaseStatus() {
  return request({
    url: '/admin/monitor/database-status',
    method: 'get'
  })
}

/**
 * 获取缓存状态
 */
export function getCacheStatus() {
  return request({
    url: '/admin/monitor/cache-status',
    method: 'get'
  })
}

/**
 * 获取用户统计信息
 */
export function getUserStats() {
  return request({
    url: '/admin/monitor/user-stats',
    method: 'get'
  })
}

/**
 * 获取文化遗产统计信息
 */
export function getHeritageStats() {
  return request({
    url: '/admin/monitor/heritage-stats',
    method: 'get'
  })
}

/**
 * 获取搜索统计信息
 */
export function getSearchStats() {
  return request({
    url: '/admin/monitor/search-stats',
    method: 'get'
  })
}

/**
 * 获取热门搜索词
 */
export function getPopularSearches() {
  return request({
    url: '/admin/monitor/popular-searches',
    method: 'get'
  })
}

/**
 * 获取系统日志
 */
export function getSystemLogs(page: number = 0, size: number = 10, level?: string, keyword?: string) {
  return request({
    url: '/admin/monitor/logs',
    method: 'get',
    params: { page, size, level, keyword }
  })
}
