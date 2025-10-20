package com.heritage.service;

import com.heritage.entity.HeritageLike;

import java.util.List;
import java.util.Map;

/**
 * 点赞Service接口
 */
public interface LikeService {

    /**
     * 添加点赞
     */
    void addLike(HeritageLike like);

    /**
     * 取消点赞
     */
    void removeLike(Long userId, Long heritageId);

    /**
     * 检查是否已点赞
     */
    boolean isLiked(Long userId, Long heritageId);

    /**
     * 获取点赞数
     */
    Long getLikeCount(Long heritageId);

    /**
     * 获取用户点赞列表
     */
    List<HeritageLike> getUserLikes(Long userId);

    /**
     * 获取点赞统计信息
     */
    Map<String, Object> getLikeStats(Long heritageId);
}
