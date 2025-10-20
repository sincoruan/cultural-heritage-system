package com.heritage.repository;

import com.heritage.entity.HeritageCollect;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * 文化遗产收藏Repository
 */
@Repository
public interface HeritageCollectRepository extends JpaRepository<HeritageCollect, Long> {

    /**
     * 根据文化遗产ID统计收藏数
     */
    Long countByHeritageId(Long heritageId);

    /**
     * 根据用户ID查询收藏列表（分页）
     */
    Page<HeritageCollect> findByUserId(Long userId, Pageable pageable);

    /**
     * 检查用户是否已收藏
     */
    boolean existsByUserIdAndHeritageId(Long userId, Long heritageId);

    /**
     * 删除用户对文化遗产的收藏
     */
    void deleteByUserIdAndHeritageId(Long userId, Long heritageId);
}