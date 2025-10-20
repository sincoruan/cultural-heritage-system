package com.heritage.repository;

import com.heritage.entity.HeritageLike;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 文化遗产点赞Repository
 */
@Repository
public interface HeritageLikeRepository extends JpaRepository<HeritageLike, Long> {

    /**
     * 根据文化遗产ID统计点赞数
     */
    Long countByHeritageId(Long heritageId);

    /**
     * 根据用户ID查询点赞列表
     */
    List<HeritageLike> findByUserId(Long userId);

    /**
     * 检查用户是否已点赞
     */
    boolean existsByUserIdAndHeritageId(Long userId, Long heritageId);

    /**
     * 删除用户对文化遗产的点赞
     */
    void deleteByUserIdAndHeritageId(Long userId, Long heritageId);
}