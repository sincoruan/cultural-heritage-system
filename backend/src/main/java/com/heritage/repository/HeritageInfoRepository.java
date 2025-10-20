package com.heritage.repository;

import com.heritage.entity.HeritageInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 文化遗产Repository
 */
@Repository
public interface HeritageInfoRepository extends JpaRepository<HeritageInfo, Long>, JpaSpecificationExecutor<HeritageInfo> {

    /**
     * 根据状态查询文化遗产列表
     */
    Page<HeritageInfo> findByStatus(String status, Pageable pageable);

    /**
     * 根据类别查询文化遗产列表
     */
    Page<HeritageInfo> findByCategory(String category, Pageable pageable);

    /**
     * 根据地点查询文化遗产列表
     */
    Page<HeritageInfo> findByLocationContaining(String location, Pageable pageable);

    /**
     * 根据年代查询文化遗产列表
     */
    Page<HeritageInfo> findByEra(String era, Pageable pageable);

    /**
     * 搜索文化遗产（名称或描述包含关键词）
     */
    @Query("SELECT h FROM HeritageInfo h WHERE h.heritageName LIKE %:keyword% OR h.description LIKE %:keyword%")
    Page<HeritageInfo> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

    /**
     * 增加浏览量
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.viewCount = h.viewCount + 1 WHERE h.heritageId = :heritageId")
    void incrementViewCount(@Param("heritageId") Long heritageId);

    /**
     * 增加点赞数
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.likeCount = h.likeCount + 1 WHERE h.heritageId = :heritageId")
    void incrementLikeCount(@Param("heritageId") Long heritageId);

    /**
     * 减少点赞数
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.likeCount = h.likeCount - 1 WHERE h.heritageId = :heritageId AND h.likeCount > 0")
    void decrementLikeCount(@Param("heritageId") Long heritageId);

    /**
     * 增加收藏数
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.collectCount = h.collectCount + 1 WHERE h.heritageId = :heritageId")
    void incrementCollectCount(@Param("heritageId") Long heritageId);

    /**
     * 减少收藏数
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.collectCount = h.collectCount - 1 WHERE h.heritageId = :heritageId AND h.collectCount > 0")
    void decrementCollectCount(@Param("heritageId") Long heritageId);

    /**
     * 增加评论数
     */
    @Modifying
    @Query("UPDATE HeritageInfo h SET h.commentCount = h.commentCount + 1 WHERE h.heritageId = :heritageId")
    void incrementCommentCount(@Param("heritageId") Long heritageId);

    /**
     * 获取热门文化遗产（按浏览量排序）
     */
    List<HeritageInfo> findTop10ByStatusOrderByViewCountDesc(String status);

}

