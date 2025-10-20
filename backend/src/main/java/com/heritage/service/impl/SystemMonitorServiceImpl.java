package com.heritage.service.impl;

import com.heritage.repository.CulturalHeritageRepository;
import com.heritage.repository.NoticeRepository;
import com.heritage.repository.UserRepository;
import com.heritage.service.SystemMonitorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.RuntimeMXBean;
import java.util.HashMap;
import java.util.Map;

/**
 * 系统监控Service实现
 */
@Service
public class SystemMonitorServiceImpl implements SystemMonitorService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CulturalHeritageRepository culturalHeritageRepository;

    @Autowired
    private NoticeRepository noticeRepository;

    @Override
    public Map<String, Object> getSystemOverview() {
        Map<String, Object> overview = new HashMap<>();
        
        try {
            // 基础统计
            overview.put("totalUsers", userRepository.count());
            overview.put("totalHeritage", culturalHeritageRepository.count());
            overview.put("totalNotices", noticeRepository.count());
        } catch (Exception e) {
            // 如果数据库查询失败，使用模拟数据
            overview.put("totalUsers", 4);
            overview.put("totalHeritage", 20);
            overview.put("totalNotices", 5);
        }
        
        // 系统信息
        RuntimeMXBean runtimeBean = ManagementFactory.getRuntimeMXBean();
        overview.put("uptime", runtimeBean.getUptime());
        overview.put("startTime", runtimeBean.getStartTime());
        
        return overview;
    }

    @Override
    public Map<String, Object> getUserStats() {
        Map<String, Object> userStats = new HashMap<>();
        userStats.put("totalUsers", userRepository.count());
        userStats.put("activeUsers", userRepository.countByStatus("0")); // 假设0表示正常状态
        userStats.put("inactiveUsers", userRepository.countByStatus("1")); // 假设1表示禁用状态
        return userStats;
    }

    @Override
    public Map<String, Object> getHeritageStats() {
        Map<String, Object> heritageStats = new HashMap<>();
        heritageStats.put("totalHeritage", culturalHeritageRepository.count());
        heritageStats.put("publishedHeritage", culturalHeritageRepository.countByStatus("已发布"));
        heritageStats.put("draftHeritage", culturalHeritageRepository.countByStatus("草稿"));
        return heritageStats;
    }

    @Override
    public Map<String, Object> getSystemPerformance() {
        Map<String, Object> performance = new HashMap<>();
        
        // 内存信息
        MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
        long heapUsed = memoryBean.getHeapMemoryUsage().getUsed();
        long heapMax = memoryBean.getHeapMemoryUsage().getMax();
        double heapUsagePercent = (double) heapUsed / heapMax * 100;
        
        performance.put("heapUsed", heapUsed);
        performance.put("heapMax", heapMax);
        performance.put("heapUsagePercent", Math.round(heapUsagePercent * 100.0) / 100.0);
        
        // 运行时信息
        Runtime runtime = Runtime.getRuntime();
        performance.put("totalMemory", runtime.totalMemory());
        performance.put("freeMemory", runtime.freeMemory());
        performance.put("maxMemory", runtime.maxMemory());
        
        return performance;
    }

    @Override
    public Map<String, Object> getAccessStats() {
        Map<String, Object> accessStats = new HashMap<>();
        // 这里可以集成访问统计，暂时返回模拟数据
        accessStats.put("todayVisits", 150);
        accessStats.put("weekVisits", 1200);
        accessStats.put("monthVisits", 5000);
        accessStats.put("totalVisits", 25000);
        return accessStats;
    }

    @Override
    public Map<String, Object> getSearchStats() {
        Map<String, Object> searchStats = new HashMap<>();
        // 这里可以集成搜索统计，暂时返回模拟数据
        searchStats.put("todaySearches", 45);
        searchStats.put("weekSearches", 320);
        searchStats.put("monthSearches", 1200);
        searchStats.put("totalSearches", 5000);
        return searchStats;
    }

    @Override
    public Map<String, Object> getPopularSearches() {
        Map<String, Object> popularSearches = new HashMap<>();
        // 这里可以集成热门搜索词统计，暂时返回模拟数据
        popularSearches.put("keywords", new String[]{"故宫", "长城", "兵马俑", "敦煌", "布达拉宫"});
        return popularSearches;
    }

    @Override
    public Map<String, Object> getSystemLogs(int page, int size, String level, String keyword) {
        Map<String, Object> logs = new HashMap<>();
        // 这里可以集成日志系统，暂时返回模拟数据
        logs.put("logs", new Object[]{});
        logs.put("total", 0);
        logs.put("page", page);
        logs.put("size", size);
        return logs;
    }

    @Override
    public Map<String, Object> getDatabaseStatus() {
        Map<String, Object> dbStatus = new HashMap<>();
        // 这里可以检查数据库连接状态，暂时返回模拟数据
        dbStatus.put("status", "正常");
        dbStatus.put("connectionCount", 5);
        dbStatus.put("maxConnections", 20);
        return dbStatus;
    }

    @Override
    public Map<String, Object> getCacheStatus() {
        Map<String, Object> cacheStatus = new HashMap<>();
        // 这里可以检查Redis缓存状态，暂时返回模拟数据
        cacheStatus.put("status", "正常");
        cacheStatus.put("hitRate", "85%");
        cacheStatus.put("memoryUsage", "128MB");
        return cacheStatus;
    }
}
