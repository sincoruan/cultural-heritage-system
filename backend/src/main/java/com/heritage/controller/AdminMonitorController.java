package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.service.SystemMonitorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 管理员系统监控控制器
 */
@RestController
@RequestMapping("/admin/monitor")
@CrossOrigin(origins = "*")
public class AdminMonitorController {

    @Autowired
    private SystemMonitorService systemMonitorService;

    /**
     * 获取系统概览信息
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> getSystemOverview() {
        try {
            Map<String, Object> overview = systemMonitorService.getSystemOverview();
            return Result.success(overview);
        } catch (Exception e) {
            return Result.error("获取系统概览失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户统计信息
     */
    @GetMapping("/user-stats")
    public Result<Map<String, Object>> getUserStats() {
        try {
            Map<String, Object> userStats = systemMonitorService.getUserStats();
            return Result.success(userStats);
        } catch (Exception e) {
            return Result.error("获取用户统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产统计信息
     */
    @GetMapping("/heritage-stats")
    public Result<Map<String, Object>> getHeritageStats() {
        try {
            Map<String, Object> heritageStats = systemMonitorService.getHeritageStats();
            return Result.success(heritageStats);
        } catch (Exception e) {
            return Result.error("获取文化遗产统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取系统性能信息
     */
    @GetMapping("/performance")
    public Result<Map<String, Object>> getSystemPerformance() {
        try {
            Map<String, Object> performance = systemMonitorService.getSystemPerformance();
            return Result.success(performance);
        } catch (Exception e) {
            return Result.error("获取系统性能失败: " + e.getMessage());
        }
    }

    /**
     * 获取访问统计信息
     */
    @GetMapping("/access-stats")
    public Result<Map<String, Object>> getAccessStats() {
        try {
            Map<String, Object> accessStats = systemMonitorService.getAccessStats();
            return Result.success(accessStats);
        } catch (Exception e) {
            return Result.error("获取访问统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取搜索统计信息
     */
    @GetMapping("/search-stats")
    public Result<Map<String, Object>> getSearchStats() {
        try {
            Map<String, Object> searchStats = systemMonitorService.getSearchStats();
            return Result.success(searchStats);
        } catch (Exception e) {
            return Result.error("获取搜索统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取热门搜索词
     */
    @GetMapping("/popular-searches")
    public Result<Map<String, Object>> getPopularSearches() {
        try {
            Map<String, Object> popularSearches = systemMonitorService.getPopularSearches();
            return Result.success(popularSearches);
        } catch (Exception e) {
            return Result.error("获取热门搜索词失败: " + e.getMessage());
        }
    }

    /**
     * 获取系统日志
     */
    @GetMapping("/logs")
    public Result<Map<String, Object>> getSystemLogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String level,
            @RequestParam(required = false) String keyword) {
        try {
            Map<String, Object> logs = systemMonitorService.getSystemLogs(page, size, level, keyword);
            return Result.success(logs);
        } catch (Exception e) {
            return Result.error("获取系统日志失败: " + e.getMessage());
        }
    }

    /**
     * 获取数据库状态
     */
    @GetMapping("/database-status")
    public Result<Map<String, Object>> getDatabaseStatus() {
        try {
            Map<String, Object> dbStatus = systemMonitorService.getDatabaseStatus();
            return Result.success(dbStatus);
        } catch (Exception e) {
            return Result.error("获取数据库状态失败: " + e.getMessage());
        }
    }

    /**
     * 获取缓存状态
     */
    @GetMapping("/cache-status")
    public Result<Map<String, Object>> getCacheStatus() {
        try {
            Map<String, Object> cacheStatus = systemMonitorService.getCacheStatus();
            return Result.success(cacheStatus);
        } catch (Exception e) {
            return Result.error("获取缓存状态失败: " + e.getMessage());
        }
    }
}
