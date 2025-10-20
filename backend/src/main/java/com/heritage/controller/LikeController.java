package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.HeritageLike;
import com.heritage.service.LikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 点赞业务管理控制器
 */
@RestController
@RequestMapping("/api/like")
@CrossOrigin(origins = "*")
public class LikeController {

    @Autowired
    private LikeService likeService;

    /**
     * 点赞文化遗产
     */
    @PostMapping("/add")
    public Result<String> addLike(@RequestBody HeritageLike like) {
        try {
            likeService.addLike(like);
            return Result.success("点赞成功");
        } catch (Exception e) {
            return Result.error("点赞失败: " + e.getMessage());
        }
    }

    /**
     * 取消点赞
     */
    @DeleteMapping("/remove")
    public Result<String> removeLike(@RequestParam Long userId, @RequestParam Long heritageId) {
        try {
            likeService.removeLike(userId, heritageId);
            return Result.success("取消点赞成功");
        } catch (Exception e) {
            return Result.error("取消点赞失败: " + e.getMessage());
        }
    }

    /**
     * 检查用户是否已点赞
     */
    @GetMapping("/check")
    public Result<Boolean> checkLike(@RequestParam Long userId, @RequestParam Long heritageId) {
        try {
            boolean isLiked = likeService.isLiked(userId, heritageId);
            return Result.success(isLiked);
        } catch (Exception e) {
            return Result.error("检查点赞状态失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产点赞数
     */
    @GetMapping("/count/{heritageId}")
    public Result<Long> getLikeCount(@PathVariable Long heritageId) {
        try {
            Long count = likeService.getLikeCount(heritageId);
            return Result.success(count);
        } catch (Exception e) {
            return Result.error("获取点赞数失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户点赞列表
     */
    @GetMapping("/user/{userId}")
    public Result<List<HeritageLike>> getUserLikes(@PathVariable Long userId) {
        try {
            List<HeritageLike> likes = likeService.getUserLikes(userId);
            return Result.success(likes);
        } catch (Exception e) {
            return Result.error("获取用户点赞列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取点赞统计信息
     */
    @GetMapping("/stats/{heritageId}")
    public Result<Map<String, Object>> getLikeStats(@PathVariable Long heritageId) {
        try {
            Map<String, Object> stats = likeService.getLikeStats(heritageId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取点赞统计失败: " + e.getMessage());
        }
    }
}
