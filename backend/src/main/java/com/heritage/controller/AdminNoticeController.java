package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.Notice;
import com.heritage.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 管理员公告管理控制器
 */
@RestController
@RequestMapping("/admin/notice")
@CrossOrigin(origins = "*")
public class AdminNoticeController {

    @Autowired
    private NoticeService noticeService;

    /**
     * 获取公告列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<Notice>> getNoticeList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String status) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<Notice> noticePage = noticeService.findNoticesWithFilters(keyword, status, pageable);
            return Result.success(noticePage);
        } catch (Exception e) {
            return Result.error("获取公告列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取公告详情
     */
    @GetMapping("/{id}")
    public Result<Notice> getNoticeDetail(@PathVariable Long id) {
        try {
            Notice notice = noticeService.findById(id);
            if (notice == null) {
                return Result.error("公告不存在");
            }
            return Result.success(notice);
        } catch (Exception e) {
            return Result.error("获取公告详情失败: " + e.getMessage());
        }
    }

    /**
     * 创建公告
     */
    @PostMapping("/create")
    public Result<Notice> createNotice(@Valid @RequestBody Notice notice) {
        try {
            Notice savedNotice = noticeService.save(notice);
            return Result.success(savedNotice);
        } catch (Exception e) {
            return Result.error("创建公告失败: " + e.getMessage());
        }
    }

    /**
     * 更新公告
     */
    @PutMapping("/{id}")
    public Result<Notice> updateNotice(@PathVariable Long id, @Valid @RequestBody Notice notice) {
        try {
            notice.setNoticeId(id);
            Notice updatedNotice = noticeService.save(notice);
            return Result.success(updatedNotice);
        } catch (Exception e) {
            return Result.error("更新公告失败: " + e.getMessage());
        }
    }

    /**
     * 删除公告
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteNotice(@PathVariable Long id) {
        try {
            noticeService.deleteById(id);
            return Result.success("删除成功");
        } catch (Exception e) {
            return Result.error("删除公告失败: " + e.getMessage());
        }
    }

    /**
     * 批量删除公告
     */
    @DeleteMapping("/batch")
    public Result<String> batchDeleteNotice(@RequestBody List<Long> ids) {
        try {
            noticeService.deleteByIds(ids);
            return Result.success("批量删除成功");
        } catch (Exception e) {
            return Result.error("批量删除失败: " + e.getMessage());
        }
    }

    /**
     * 发布公告
     */
    @PutMapping("/{id}/publish")
    public Result<String> publishNotice(@PathVariable Long id) {
        try {
            noticeService.publishNotice(id);
            return Result.success("公告发布成功");
        } catch (Exception e) {
            return Result.error("公告发布失败: " + e.getMessage());
        }
    }

    /**
     * 取消发布公告
     */
    @PutMapping("/{id}/unpublish")
    public Result<String> unpublishNotice(@PathVariable Long id) {
        try {
            noticeService.unpublishNotice(id);
            return Result.success("公告取消发布成功");
        } catch (Exception e) {
            return Result.error("取消发布失败: " + e.getMessage());
        }
    }

    /**
     * 获取公告统计信息
     */
    @GetMapping("/stats")
    public Result<Object> getNoticeStats() {
        try {
            Object stats = noticeService.getNoticeStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取统计信息失败: " + e.getMessage());
        }
    }
}
