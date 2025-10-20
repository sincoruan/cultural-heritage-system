package com.heritage.repository;

import com.heritage.entity.Notice;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/**
 * 公告Repository
 */
@Repository
public interface NoticeRepository extends JpaRepository<Notice, Long> {

    /**
     * 根据标题模糊查询
     */
    Page<Notice> findByNoticeTitleContaining(String noticeTitle, Pageable pageable);

    /**
     * 根据状态查询
     */
    Page<Notice> findByStatus(String status, Pageable pageable);

    /**
     * 根据标题和状态查询
     */
    Page<Notice> findByNoticeTitleContainingAndStatus(String noticeTitle, String status, Pageable pageable);

    /**
     * 根据状态统计数量
     */
    long countByStatus(String status);
}