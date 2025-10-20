package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.service.BusinessStatsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 业务统计管理控制器
 */
@RestController
@RequestMapping("/api/business-stats")
@CrossOrigin(origins = "*")
public class BusinessStatsController {

    @Autowired
    private BusinessStatsService businessStatsService;

    /**
     * 获取业务概览统计
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> getBusinessOverview() {
        try {
            Map<String, Object> overview = businessStatsService.getBusinessOverview();
            return Result.success(overview);
        } catch (Exception e) {
            return Result.error("获取业务概览失败: " + e.getMessage());
        }
    }

    /**
     * 获取热门文化遗产统计
     */
    @GetMapping("/popular-heritage")
    public Result<List<Map<String, Object>>> getPopularHeritageStats(
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<Map<String, Object>> popularHeritage = businessStatsService.getPopularHeritageStats(limit);
            return Result.success(popularHeritage);
        } catch (Exception e) {
            return Result.error("获取热门文化遗产统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户活跃度统计
     */
    @GetMapping("/user-activity")
    public Result<Map<String, Object>> getUserActivityStats() {
        try {
            Map<String, Object> activityStats = businessStatsService.getUserActivityStats();
            return Result.success(activityStats);
        } catch (Exception e) {
            return Result.error("获取用户活跃度统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取内容热度分析
     */
    @GetMapping("/content-heat")
    public Result<Map<String, Object>> getContentHeatAnalysis() {
        try {
            Map<String, Object> heatAnalysis = businessStatsService.getContentHeatAnalysis();
            return Result.success(heatAnalysis);
        } catch (Exception e) {
            return Result.error("获取内容热度分析失败: " + e.getMessage());
        }
    }

    /**
     * 获取互动数据统计
     */
    @GetMapping("/interaction-stats")
    public Result<Map<String, Object>> getInteractionStats() {
        try {
            Map<String, Object> interactionStats = businessStatsService.getInteractionStats();
            return Result.success(interactionStats);
        } catch (Exception e) {
            return Result.error("获取互动数据统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取搜索热词统计
     */
    @GetMapping("/search-hotwords")
    public Result<List<Map<String, Object>>> getSearchHotwords(
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<Map<String, Object>> hotwords = businessStatsService.getSearchHotwords(limit);
            return Result.success(hotwords);
        } catch (Exception e) {
            return Result.error("获取搜索热词统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取时间趋势分析
     */
    @GetMapping("/trend-analysis")
    public Result<Map<String, Object>> getTrendAnalysis(
            @RequestParam(defaultValue = "7") int days) {
        try {
            Map<String, Object> trendAnalysis = businessStatsService.getTrendAnalysis(days);
            return Result.success(trendAnalysis);
        } catch (Exception e) {
            return Result.error("获取时间趋势分析失败: " + e.getMessage());
        }
    }

    /**
     * 获取分类热度统计
     */
    @GetMapping("/category-heat")
    public Result<List<Map<String, Object>>> getCategoryHeatStats() {
        try {
            List<Map<String, Object>> categoryHeat = businessStatsService.getCategoryHeatStats();
            return Result.success(categoryHeat);
        } catch (Exception e) {
            return Result.error("获取分类热度统计失败: " + e.getMessage());
        }
    }
}
