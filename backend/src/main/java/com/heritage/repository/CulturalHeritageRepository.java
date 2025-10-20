package com.heritage.repository;

import com.heritage.entity.CulturalHeritage;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 * 文化遗产Repository
 */
@Repository
public interface CulturalHeritageRepository extends JpaRepository<CulturalHeritage, Long> {

    /**
     * 根据名称模糊查询
     */
    Page<CulturalHeritage> findByHeritageNameContaining(String heritageName, Pageable pageable);

    /**
     * 根据类别查询
     */
    Page<CulturalHeritage> findByCategory(String category, Pageable pageable);

    /**
     * 根据名称和类别查询
     */
    Page<CulturalHeritage> findByHeritageNameContainingAndCategory(String heritageName, String category, Pageable pageable);

    /**
     * 根据状态统计数量
     */
    long countByStatus(String status);

    /**
     * 根据类别统计数量
     */
    @Query("SELECT c.category, COUNT(c) FROM CulturalHeritage c GROUP BY c.category")
    java.util.List<Object[]> countByCategory();

    /**
     * 获取热门文化遗产（按浏览量排序）
     */
    java.util.List<CulturalHeritage> findTop10ByOrderByViewCountDesc();

    /**
     * 获取最新文化遗产（按创建时间排序）
     */
    java.util.List<CulturalHeritage> findTop10ByOrderByCreateTimeDesc();

    /**
     * 根据类别和ID查询相关文化遗产
     */
    org.springframework.data.domain.Page<CulturalHeritage> findByCategoryAndHeritageIdNot(
            String category, Long heritageId, org.springframework.data.domain.Pageable pageable);
}
