package com.heritage.service.impl;

import com.heritage.entity.CulturalHeritage;
import com.heritage.repository.CulturalHeritageRepository;
import com.heritage.service.CulturalHeritageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 文化遗产Service实现
 */
@Service
public class CulturalHeritageServiceImpl implements CulturalHeritageService {

    @Autowired
    private CulturalHeritageRepository culturalHeritageRepository;

    @Override
    public CulturalHeritage findById(Long id) {
        return culturalHeritageRepository.findById(id).orElse(null);
    }

    @Override
    public CulturalHeritage save(CulturalHeritage heritage) {
        return culturalHeritageRepository.save(heritage);
    }

    @Override
    public void deleteById(Long id) {
        culturalHeritageRepository.deleteById(id);
    }

    @Override
    public void deleteByIds(List<Long> ids) {
        culturalHeritageRepository.deleteAllById(ids);
    }

    @Override
    public Page<CulturalHeritage> findAll(Pageable pageable) {
        return culturalHeritageRepository.findAll(pageable);
    }

    @Override
    public Page<CulturalHeritage> findHeritageWithFilters(String keyword, String category, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty() && category != null && !category.trim().isEmpty()) {
            return culturalHeritageRepository.findByHeritageNameContainingAndCategory(keyword, category, pageable);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            return culturalHeritageRepository.findByHeritageNameContaining(keyword, pageable);
        } else if (category != null && !category.trim().isEmpty()) {
            return culturalHeritageRepository.findByCategory(category, pageable);
        } else {
            return culturalHeritageRepository.findAll(pageable);
        }
    }

    @Override
    public void updateStatus(Long id, String status) {
        CulturalHeritage heritage = culturalHeritageRepository.findById(id).orElse(null);
        if (heritage != null) {
            heritage.setStatus(status);
            culturalHeritageRepository.save(heritage);
        }
    }

    @Override
    public Object getHeritageStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", culturalHeritageRepository.count());
        stats.put("publishedCount", culturalHeritageRepository.countByStatus("已发布"));
        stats.put("draftCount", culturalHeritageRepository.countByStatus("草稿"));
        return stats;
    }

    @Override
    public void incrementViewCount(Long heritageId) {
        CulturalHeritage heritage = culturalHeritageRepository.findById(heritageId).orElse(null);
        if (heritage != null) {
            heritage.setViewCount(heritage.getViewCount() + 1);
            culturalHeritageRepository.save(heritage);
        }
    }

    @Override
    public org.springframework.data.domain.Page<CulturalHeritage> searchHeritage(String keyword, org.springframework.data.domain.Pageable pageable) {
        return culturalHeritageRepository.findByHeritageNameContaining(keyword, pageable);
    }

    @Override
    public java.util.List<CulturalHeritage> getPopularHeritage(int limit) {
        return culturalHeritageRepository.findTop10ByOrderByViewCountDesc().stream()
                .limit(limit)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public java.util.List<CulturalHeritage> getLatestHeritage(int limit) {
        return culturalHeritageRepository.findTop10ByOrderByCreateTimeDesc().stream()
                .limit(limit)
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public java.util.List<java.util.Map<String, Object>> getHeritageCategories() {
        return culturalHeritageRepository.countByCategory().stream()
                .map(result -> {
                    java.util.Map<String, Object> category = new java.util.HashMap<>();
                    category.put("category", result[0]);
                    category.put("count", result[1]);
                    return category;
                })
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public java.util.List<CulturalHeritage> getRelatedHeritage(Long heritageId, int limit) {
        CulturalHeritage currentHeritage = culturalHeritageRepository.findById(heritageId).orElse(null);
        if (currentHeritage == null) {
            return java.util.Collections.emptyList();
        }
        
        return culturalHeritageRepository.findByCategoryAndHeritageIdNot(
                currentHeritage.getCategory(), heritageId, 
                org.springframework.data.domain.PageRequest.of(0, limit)
        ).getContent();
    }
}
