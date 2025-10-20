package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.HeritageCollect;
import com.heritage.service.CollectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 收藏业务管理控制器
 */
@RestController
@RequestMapping("/api/collect")
@CrossOrigin(origins = "*")
public class CollectController {

    @Autowired
    private CollectService collectService;

    /**
     * 收藏文化遗产
     */
    @PostMapping("/add")
    public Result<String> addCollect(@RequestBody HeritageCollect collect) {
        try {
            collectService.addCollect(collect);
            return Result.success("收藏成功");
        } catch (Exception e) {
            return Result.error("收藏失败: " + e.getMessage());
        }
    }

    /**
     * 取消收藏
     */
    @DeleteMapping("/remove")
    public Result<String> removeCollect(@RequestParam Long userId, @RequestParam Long heritageId) {
        try {
            collectService.removeCollect(userId, heritageId);
            return Result.success("取消收藏成功");
        } catch (Exception e) {
            return Result.error("取消收藏失败: " + e.getMessage());
        }
    }

    /**
     * 检查用户是否已收藏
     */
    @GetMapping("/check")
    public Result<Boolean> checkCollect(@RequestParam Long userId, @RequestParam Long heritageId) {
        try {
            boolean isCollected = collectService.isCollected(userId, heritageId);
            return Result.success(isCollected);
        } catch (Exception e) {
            return Result.error("检查收藏状态失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户收藏列表
     */
    @GetMapping("/user/{userId}")
    public Result<Page<HeritageCollect>> getUserCollects(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<HeritageCollect> collects = collectService.getUserCollects(userId, pageable);
            return Result.success(collects);
        } catch (Exception e) {
            return Result.error("获取用户收藏列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产收藏数
     */
    @GetMapping("/count/{heritageId}")
    public Result<Long> getCollectCount(@PathVariable Long heritageId) {
        try {
            Long count = collectService.getCollectCount(heritageId);
            return Result.success(count);
        } catch (Exception e) {
            return Result.error("获取收藏数失败: " + e.getMessage());
        }
    }

    /**
     * 获取收藏统计信息
     */
    @GetMapping("/stats/{heritageId}")
    public Result<Map<String, Object>> getCollectStats(@PathVariable Long heritageId) {
        try {
            Map<String, Object> stats = collectService.getCollectStats(heritageId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取收藏统计失败: " + e.getMessage());
        }
    }
}
