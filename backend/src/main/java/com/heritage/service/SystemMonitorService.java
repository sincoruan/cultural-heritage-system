package com.heritage.service;

import java.util.Map;

/**
 * 系统监控Service接口
 */
public interface SystemMonitorService {

    /**
     * 获取系统概览信息
     */
    Map<String, Object> getSystemOverview();

    /**
     * 获取用户统计信息
     */
    Map<String, Object> getUserStats();

    /**
     * 获取文化遗产统计信息
     */
    Map<String, Object> getHeritageStats();

    /**
     * 获取系统性能信息
     */
    Map<String, Object> getSystemPerformance();

    /**
     * 获取访问统计信息
     */
    Map<String, Object> getAccessStats();

    /**
     * 获取搜索统计信息
     */
    Map<String, Object> getSearchStats();

    /**
     * 获取热门搜索词
     */
    Map<String, Object> getPopularSearches();

    /**
     * 获取系统日志
     */
    Map<String, Object> getSystemLogs(int page, int size, String level, String keyword);

    /**
     * 获取数据库状态
     */
    Map<String, Object> getDatabaseStatus();

    /**
     * 获取缓存状态
     */
    Map<String, Object> getCacheStatus();
}
