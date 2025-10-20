package com.heritage.service.impl;

import com.heritage.entity.HeritageCollect;
import com.heritage.repository.HeritageCollectRepository;
import com.heritage.service.CollectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.HashMap;

/**
 * 收藏Service实现
 */
@Service
public class CollectServiceImpl implements CollectService {

    @Autowired
    private HeritageCollectRepository heritageCollectRepository;

    @Override
    public void addCollect(HeritageCollect collect) {
        // 检查是否已经收藏
        if (!isCollected(collect.getUserId(), collect.getHeritageId())) {
            heritageCollectRepository.save(collect);
        }
    }

    @Override
    public void removeCollect(Long userId, Long heritageId) {
        heritageCollectRepository.deleteByUserIdAndHeritageId(userId, heritageId);
    }

    @Override
    public boolean isCollected(Long userId, Long heritageId) {
        return heritageCollectRepository.existsByUserIdAndHeritageId(userId, heritageId);
    }

    @Override
    public Long getCollectCount(Long heritageId) {
        return heritageCollectRepository.countByHeritageId(heritageId);
    }

    @Override
    public Page<HeritageCollect> getUserCollects(Long userId, Pageable pageable) {
        return heritageCollectRepository.findByUserId(userId, pageable);
    }

    @Override
    public Map<String, Object> getCollectStats(Long heritageId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCollects", getCollectCount(heritageId));
        stats.put("heritageId", heritageId);
        return stats;
    }
}
