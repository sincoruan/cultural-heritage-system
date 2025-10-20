package com.heritage.service;

import com.heritage.entity.HeritageCollect;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Map;

/**
 * 收藏Service接口
 */
public interface CollectService {

    /**
     * 添加收藏
     */
    void addCollect(HeritageCollect collect);

    /**
     * 取消收藏
     */
    void removeCollect(Long userId, Long heritageId);

    /**
     * 检查是否已收藏
     */
    boolean isCollected(Long userId, Long heritageId);

    /**
     * 获取收藏数
     */
    Long getCollectCount(Long heritageId);

    /**
     * 获取用户收藏列表
     */
    Page<HeritageCollect> getUserCollects(Long userId, Pageable pageable);

    /**
     * 获取收藏统计信息
     */
    Map<String, Object> getCollectStats(Long heritageId);
}
