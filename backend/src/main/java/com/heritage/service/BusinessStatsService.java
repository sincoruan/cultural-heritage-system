package com.heritage.service;

import java.util.List;
import java.util.Map;

/**
 * 业务统计Service接口
 */
public interface BusinessStatsService {

    /**
     * 获取业务概览统计
     */
    Map<String, Object> getBusinessOverview();

    /**
     * 获取热门文化遗产统计
     */
    List<Map<String, Object>> getPopularHeritageStats(int limit);

    /**
     * 获取用户活跃度统计
     */
    Map<String, Object> getUserActivityStats();

    /**
     * 获取内容热度分析
     */
    Map<String, Object> getContentHeatAnalysis();

    /**
     * 获取互动数据统计
     */
    Map<String, Object> getInteractionStats();

    /**
     * 获取搜索热词统计
     */
    List<Map<String, Object>> getSearchHotwords(int limit);

    /**
     * 获取时间趋势分析
     */
    Map<String, Object> getTrendAnalysis(int days);

    /**
     * 获取分类热度统计
     */
    List<Map<String, Object>> getCategoryHeatStats();
}
