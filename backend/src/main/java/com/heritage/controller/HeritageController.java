package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.CulturalHeritage;
import com.heritage.service.CulturalHeritageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 文化遗产业务管理控制器
 */
@RestController
@RequestMapping("/api/heritage")
@CrossOrigin(origins = "*")
public class HeritageController {

    @Autowired
    private CulturalHeritageService culturalHeritageService;

    /**
     * 获取文化遗产列表（分页）
     */
    @GetMapping(value = "/list", produces = "application/json;charset=UTF-8")
    public Result<Page<CulturalHeritage>> getHeritageList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String era,
            @RequestParam(required = false) String location) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<CulturalHeritage> heritagePage = culturalHeritageService.findHeritageWithFilters(
                keyword, category, pageable);
            return Result.success(heritagePage);
        } catch (Exception e) {
            return Result.error("获取文化遗产列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产详情
     */
    @GetMapping("/{id}")
    public Result<CulturalHeritage> getHeritageDetail(@PathVariable Long id) {
        try {
            CulturalHeritage heritage = culturalHeritageService.findById(id);
            if (heritage == null) {
                return Result.error("文化遗产不存在");
            }
            // 增加浏览量
            culturalHeritageService.incrementViewCount(id);
            return Result.success(heritage);
        } catch (Exception e) {
            return Result.error("获取文化遗产详情失败: " + e.getMessage());
        }
    }

    /**
     * 搜索文化遗产
     */
    @GetMapping("/search")
    public Result<Page<CulturalHeritage>> searchHeritage(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<CulturalHeritage> heritagePage = culturalHeritageService.searchHeritage(keyword, pageable);
            return Result.success(heritagePage);
        } catch (Exception e) {
            return Result.error("搜索文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 获取热门文化遗产
     */
    @GetMapping("/popular")
    public Result<List<CulturalHeritage>> getPopularHeritage(
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<CulturalHeritage> popularHeritage = culturalHeritageService.getPopularHeritage(limit);
            return Result.success(popularHeritage);
        } catch (Exception e) {
            return Result.error("获取热门文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 获取最新文化遗产
     */
    @GetMapping("/latest")
    public Result<List<CulturalHeritage>> getLatestHeritage(
            @RequestParam(defaultValue = "10") int limit) {
        try {
            List<CulturalHeritage> latestHeritage = culturalHeritageService.getLatestHeritage(limit);
            return Result.success(latestHeritage);
        } catch (Exception e) {
            return Result.error("获取最新文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产分类统计
     */
    @GetMapping("/categories")
    public Result<List<Map<String, Object>>> getHeritageCategories() {
        try {
            List<Map<String, Object>> categories = culturalHeritageService.getHeritageCategories();
            return Result.success(categories);
        } catch (Exception e) {
            return Result.error("获取文化遗产分类失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产统计信息
     */
    @GetMapping("/stats")
    public Result<Object> getHeritageStats() {
        try {
            Object stats = culturalHeritageService.getHeritageStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取文化遗产统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取相关文化遗产推荐
     */
    @GetMapping("/{id}/related")
    public Result<List<CulturalHeritage>> getRelatedHeritage(
            @PathVariable Long id,
            @RequestParam(defaultValue = "5") int limit) {
        try {
            List<CulturalHeritage> relatedHeritage = culturalHeritageService.getRelatedHeritage(id, limit);
            return Result.success(relatedHeritage);
        } catch (Exception e) {
            return Result.error("获取相关文化遗产失败: " + e.getMessage());
        }
    }
}
