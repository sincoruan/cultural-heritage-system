package com.heritage.service;

import com.heritage.entity.CulturalHeritage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * 文化遗产Service接口
 */
public interface CulturalHeritageService {

    /**
     * 根据ID查询文化遗产
     */
    CulturalHeritage findById(Long id);

    /**
     * 保存文化遗产
     */
    CulturalHeritage save(CulturalHeritage heritage);

    /**
     * 根据ID删除文化遗产
     */
    void deleteById(Long id);

    /**
     * 批量删除文化遗产
     */
    void deleteByIds(List<Long> ids);

    /**
     * 分页查询文化遗产
     */
    Page<CulturalHeritage> findAll(Pageable pageable);

    /**
     * 根据条件查询文化遗产
     */
    Page<CulturalHeritage> findHeritageWithFilters(String keyword, String category, Pageable pageable);

    /**
     * 更新文化遗产状态
     */
    void updateStatus(Long id, String status);

    /**
     * 获取文化遗产统计信息
     */
    Object getHeritageStats();

    /**
     * 增加浏览量
     */
    void incrementViewCount(Long heritageId);

    /**
     * 搜索文化遗产
     */
    org.springframework.data.domain.Page<CulturalHeritage> searchHeritage(String keyword, org.springframework.data.domain.Pageable pageable);

    /**
     * 获取热门文化遗产
     */
    java.util.List<CulturalHeritage> getPopularHeritage(int limit);

    /**
     * 获取最新文化遗产
     */
    java.util.List<CulturalHeritage> getLatestHeritage(int limit);

    /**
     * 获取文化遗产分类统计
     */
    java.util.List<java.util.Map<String, Object>> getHeritageCategories();

    /**
     * 获取相关文化遗产推荐
     */
    java.util.List<CulturalHeritage> getRelatedHeritage(Long heritageId, int limit);
}
