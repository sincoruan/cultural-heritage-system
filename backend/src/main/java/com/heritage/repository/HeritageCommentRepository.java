package com.heritage.repository;

import com.heritage.entity.HeritageComment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * 文化遗产评论Repository
 */
@Repository
public interface HeritageCommentRepository extends JpaRepository<HeritageComment, Long> {

    /**
     * 根据文化遗产ID查询评论列表（分页）
     */
    Page<HeritageComment> findByHeritageId(Long heritageId, Pageable pageable);

    /**
     * 根据用户ID查询评论列表（分页）
     */
    Page<HeritageComment> findByUserId(Long userId, Pageable pageable);

    /**
     * 根据文化遗产ID统计评论数
     */
    Long countByHeritageId(Long heritageId);
}