package com.heritage.service;

import com.heritage.entity.Notice;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

/**
 * 公告Service接口
 */
public interface NoticeService {

    /**
     * 根据ID查询公告
     */
    Notice findById(Long id);

    /**
     * 保存公告
     */
    Notice save(Notice notice);

    /**
     * 根据ID删除公告
     */
    void deleteById(Long id);

    /**
     * 批量删除公告
     */
    void deleteByIds(List<Long> ids);

    /**
     * 分页查询公告
     */
    Page<Notice> findAll(Pageable pageable);

    /**
     * 根据条件查询公告
     */
    Page<Notice> findNoticesWithFilters(String keyword, String status, Pageable pageable);

    /**
     * 发布公告
     */
    void publishNotice(Long id);

    /**
     * 取消发布公告
     */
    void unpublishNotice(Long id);

    /**
     * 获取公告统计信息
     */
    Object getNoticeStats();
}
