package com.heritage.service.impl;

import com.heritage.service.BusinessStatsService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;

/**
 * 业务统计Service实现
 */
@Service
public class BusinessStatsServiceImpl implements BusinessStatsService {

    @Override
    public Map<String, Object> getBusinessOverview() {
        Map<String, Object> overview = new HashMap<>();
        overview.put("totalUsers", 1250);
        overview.put("totalHeritage", 180);
        overview.put("totalComments", 2500);
        overview.put("totalLikes", 8500);
        overview.put("totalCollects", 3200);
        overview.put("totalViews", 25000);
        return overview;
    }

    @Override
    public List<Map<String, Object>> getPopularHeritageStats(int limit) {
        // 模拟热门文化遗产数据
        return Arrays.asList(
            createHeritageStat("故宫博物院", 2500, 1),
            createHeritageStat("长城", 2200, 2),
            createHeritageStat("兵马俑", 1800, 3),
            createHeritageStat("天坛", 1500, 4),
            createHeritageStat("颐和园", 1200, 5)
        );
    }

    @Override
    public Map<String, Object> getUserActivityStats() {
        Map<String, Object> activityStats = new HashMap<>();
        activityStats.put("activeUsers", 850);
        activityStats.put("newUsers", 45);
        activityStats.put("loginCount", 3200);
        activityStats.put("commentCount", 180);
        activityStats.put("likeCount", 450);
        activityStats.put("collectCount", 120);
        return activityStats;
    }

    @Override
    public Map<String, Object> getContentHeatAnalysis() {
        Map<String, Object> heatAnalysis = new HashMap<>();
        heatAnalysis.put("hotCategories", Arrays.asList("古建筑", "文物", "遗址"));
        heatAnalysis.put("trendingKeywords", Arrays.asList("故宫", "长城", "兵马俑", "天坛", "颐和园"));
        heatAnalysis.put("popularTags", Arrays.asList("世界遗产", "国家级", "重点保护", "历史文化"));
        return heatAnalysis;
    }

    @Override
    public Map<String, Object> getInteractionStats() {
        Map<String, Object> interactionStats = new HashMap<>();
        interactionStats.put("totalComments", 2500);
        interactionStats.put("totalLikes", 8500);
        interactionStats.put("totalCollects", 3200);
        interactionStats.put("avgCommentsPerHeritage", 13.9);
        interactionStats.put("avgLikesPerHeritage", 47.2);
        interactionStats.put("avgCollectsPerHeritage", 17.8);
        return interactionStats;
    }

    @Override
    public List<Map<String, Object>> getSearchHotwords(int limit) {
        return Arrays.asList(
            createHotwordStat("故宫", 1200),
            createHotwordStat("长城", 980),
            createHotwordStat("兵马俑", 850),
            createHotwordStat("天坛", 720),
            createHotwordStat("颐和园", 680)
        );
    }

    @Override
    public Map<String, Object> getTrendAnalysis(int days) {
        Map<String, Object> trendAnalysis = new HashMap<>();
        trendAnalysis.put("period", days + "天");
        trendAnalysis.put("userGrowth", 12.5);
        trendAnalysis.put("contentGrowth", 8.3);
        trendAnalysis.put("interactionGrowth", 15.7);
        trendAnalysis.put("viewGrowth", 22.1);
        return trendAnalysis;
    }

    @Override
    public List<Map<String, Object>> getCategoryHeatStats() {
        return Arrays.asList(
            createCategoryStat("古建筑", 85, 120),
            createCategoryStat("文物", 78, 95),
            createCategoryStat("遗址", 65, 80),
            createCategoryStat("非物质文化遗产", 45, 60)
        );
    }

    private Map<String, Object> createHeritageStat(String name, int views, int rank) {
        Map<String, Object> stat = new HashMap<>();
        stat.put("name", name);
        stat.put("views", views);
        stat.put("rank", rank);
        return stat;
    }

    private Map<String, Object> createHotwordStat(String keyword, int count) {
        Map<String, Object> stat = new HashMap<>();
        stat.put("keyword", keyword);
        stat.put("count", count);
        return stat;
    }

    private Map<String, Object> createCategoryStat(String category, int heat, int count) {
        Map<String, Object> stat = new HashMap<>();
        stat.put("category", category);
        stat.put("heat", heat);
        stat.put("count", count);
        return stat;
    }
}
