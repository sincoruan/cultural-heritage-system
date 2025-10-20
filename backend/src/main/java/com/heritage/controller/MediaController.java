package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.HeritageMedia;
import com.heritage.service.MediaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 多媒体管理控制器
 */
@RestController
@RequestMapping("/media")
@CrossOrigin(origins = "*")
public class MediaController {

    @Autowired
    private MediaService mediaService;

    /**
     * 获取文化遗产的多媒体资源
     */
    @GetMapping("/heritage/{heritageId}")
    public Result<List<HeritageMedia>> getHeritageMedia(@PathVariable Long heritageId) {
        try {
            List<HeritageMedia> mediaList = mediaService.getHeritageMedia(heritageId);
            return Result.success(mediaList);
        } catch (Exception e) {
            return Result.error("获取多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 添加多媒体资源
     */
    @PostMapping("/add")
    public Result<HeritageMedia> addMedia(@RequestBody HeritageMedia media) {
        try {
            HeritageMedia savedMedia = mediaService.addMedia(media);
            return Result.success(savedMedia);
        } catch (Exception e) {
            return Result.error("添加多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 添加多媒体资源 (RESTful风格)
     */
    @PostMapping
    public Result<HeritageMedia> addMediaRest(@RequestBody HeritageMedia media) {
        try {
            HeritageMedia savedMedia = mediaService.addMedia(media);
            return Result.success(savedMedia);
        } catch (Exception e) {
            return Result.error("添加多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 更新多媒体资源
     */
    @PutMapping("/{id}")
    public Result<HeritageMedia> updateMedia(@PathVariable Long id, @RequestBody HeritageMedia media) {
        try {
            media.setMediaId(id);
            HeritageMedia updatedMedia = mediaService.updateMedia(media);
            return Result.success(updatedMedia);
        } catch (Exception e) {
            return Result.error("更新多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 删除多媒体资源
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteMedia(@PathVariable Long id) {
        try {
            mediaService.deleteMedia(id);
            return Result.success("删除多媒体资源成功");
        } catch (Exception e) {
            return Result.error("删除多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 批量删除多媒体资源
     */
    @DeleteMapping("/batch")
    public Result<String> batchDeleteMedia(@RequestBody List<Long> ids) {
        try {
            mediaService.batchDeleteMedia(ids);
            return Result.success("批量删除多媒体资源成功");
        } catch (Exception e) {
            return Result.error("批量删除多媒体资源失败: " + e.getMessage());
        }
    }

    /**
     * 更新多媒体资源排序
     */
    @PutMapping("/{id}/sort")
    public Result<String> updateMediaSort(@PathVariable Long id, @RequestParam Integer sortOrder) {
        try {
            mediaService.updateMediaSort(id, sortOrder);
            return Result.success("更新排序成功");
        } catch (Exception e) {
            return Result.error("更新排序失败: " + e.getMessage());
        }
    }

    /**
     * 获取多媒体资源统计
     */
    @GetMapping("/stats/{heritageId}")
    public Result<Map<String, Object>> getMediaStats(@PathVariable Long heritageId) {
        try {
            Map<String, Object> stats = mediaService.getMediaStats(heritageId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取多媒体资源统计失败: " + e.getMessage());
        }
    }

    /**
     * 获取多媒体资源列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<HeritageMedia>> getMediaList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String mediaType,
            @RequestParam(required = false) Long heritageId) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<HeritageMedia> mediaPage = mediaService.getMediaList(mediaType, heritageId, pageable);
            return Result.success(mediaPage);
        } catch (Exception e) {
            return Result.error("获取多媒体资源列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取多媒体资源详情
     */
    @GetMapping("/{id}")
    public Result<HeritageMedia> getMediaDetail(@PathVariable Long id) {
        try {
            HeritageMedia media = mediaService.getMediaDetail(id);
            if (media == null) {
                return Result.error("多媒体资源不存在");
            }
            return Result.success(media);
        } catch (Exception e) {
            return Result.error("获取多媒体资源详情失败: " + e.getMessage());
        }
    }

    /**
     * 根据媒体类型获取多媒体列表
     */
    @GetMapping("/type/{mediaType}")
    public Result<Page<HeritageMedia>> getMediaByType(
            @PathVariable String mediaType,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<HeritageMedia> mediaPage = mediaService.getMediaByType(mediaType, pageable);
            return Result.success(mediaPage);
        } catch (Exception e) {
            return Result.error("获取多媒体资源失败: " + e.getMessage());
        }
    }
}
