package com.heritage.repository;

import com.heritage.entity.SearchLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 搜索日志Repository
 */
@Repository
public interface SearchLogRepository extends JpaRepository<SearchLog, Long> {

    /**
     * 根据用户ID查询搜索日志
     */
    List<SearchLog> findByUserIdOrderByCreateTimeDesc(Long userId);

    /**
     * 获取热门搜索词（按搜索次数排序）
     */
    @Query("SELECT s.searchKeyword, COUNT(s) FROM SearchLog s GROUP BY s.searchKeyword ORDER BY COUNT(s) DESC")
    List<Object[]> findTopSearchKeywords();

}

