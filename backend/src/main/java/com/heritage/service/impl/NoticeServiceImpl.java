package com.heritage.service.impl;

import com.heritage.entity.Notice;
import com.heritage.repository.NoticeRepository;
import com.heritage.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 公告Service实现
 */
@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeRepository noticeRepository;

    @Override
    public Notice findById(Long id) {
        return noticeRepository.findById(id).orElse(null);
    }

    @Override
    public Notice save(Notice notice) {
        return noticeRepository.save(notice);
    }

    @Override
    public void deleteById(Long id) {
        noticeRepository.deleteById(id);
    }

    @Override
    public void deleteByIds(List<Long> ids) {
        noticeRepository.deleteAllById(ids);
    }

    @Override
    public Page<Notice> findAll(Pageable pageable) {
        return noticeRepository.findAll(pageable);
    }

    @Override
    public Page<Notice> findNoticesWithFilters(String keyword, String status, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty() && status != null && !status.trim().isEmpty()) {
            return noticeRepository.findByNoticeTitleContainingAndStatus(keyword, status, pageable);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            return noticeRepository.findByNoticeTitleContaining(keyword, pageable);
        } else if (status != null && !status.trim().isEmpty()) {
            return noticeRepository.findByStatus(status, pageable);
        } else {
            return noticeRepository.findAll(pageable);
        }
    }

    @Override
    public void publishNotice(Long id) {
        Notice notice = noticeRepository.findById(id).orElse(null);
        if (notice != null) {
            notice.setStatus("已发布");
            noticeRepository.save(notice);
        }
    }

    @Override
    public void unpublishNotice(Long id) {
        Notice notice = noticeRepository.findById(id).orElse(null);
        if (notice != null) {
            notice.setStatus("草稿");
            noticeRepository.save(notice);
        }
    }

    @Override
    public Object getNoticeStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", noticeRepository.count());
        stats.put("publishedCount", noticeRepository.countByStatus("已发布"));
        stats.put("draftCount", noticeRepository.countByStatus("草稿"));
        return stats;
    }
}
