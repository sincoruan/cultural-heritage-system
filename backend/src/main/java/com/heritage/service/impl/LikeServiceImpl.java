package com.heritage.service.impl;

import com.heritage.entity.HeritageLike;
import com.heritage.repository.HeritageLikeRepository;
import com.heritage.service.LikeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 点赞Service实现
 */
@Service
public class LikeServiceImpl implements LikeService {

    @Autowired
    private HeritageLikeRepository heritageLikeRepository;

    @Override
    public void addLike(HeritageLike like) {
        // 检查是否已经点赞
        if (!isLiked(like.getUserId(), like.getHeritageId())) {
            heritageLikeRepository.save(like);
        }
    }

    @Override
    public void removeLike(Long userId, Long heritageId) {
        heritageLikeRepository.deleteByUserIdAndHeritageId(userId, heritageId);
    }

    @Override
    public boolean isLiked(Long userId, Long heritageId) {
        return heritageLikeRepository.existsByUserIdAndHeritageId(userId, heritageId);
    }

    @Override
    public Long getLikeCount(Long heritageId) {
        return heritageLikeRepository.countByHeritageId(heritageId);
    }

    @Override
    public List<HeritageLike> getUserLikes(Long userId) {
        return heritageLikeRepository.findByUserId(userId);
    }

    @Override
    public Map<String, Object> getLikeStats(Long heritageId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalLikes", getLikeCount(heritageId));
        stats.put("heritageId", heritageId);
        return stats;
    }
}
