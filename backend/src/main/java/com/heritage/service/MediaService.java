package com.heritage.service;

import com.heritage.entity.HeritageMedia;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Map;

/**
 * 多媒体Service接口
 */
public interface MediaService {

    /**
     * 获取文化遗产的多媒体资源
     */
    List<HeritageMedia> getHeritageMedia(Long heritageId);

    /**
     * 添加多媒体资源
     */
    HeritageMedia addMedia(HeritageMedia media);

    /**
     * 更新多媒体资源
     */
    HeritageMedia updateMedia(HeritageMedia media);

    /**
     * 删除多媒体资源
     */
    void deleteMedia(Long mediaId);

    /**
     * 批量删除多媒体资源
     */
    void batchDeleteMedia(List<Long> ids);

    /**
     * 更新多媒体资源排序
     */
    void updateMediaSort(Long mediaId, Integer sortOrder);

    /**
     * 获取多媒体资源统计
     */
    Map<String, Object> getMediaStats(Long heritageId);

    /**
     * 获取多媒体资源列表（分页）
     */
    Page<HeritageMedia> getMediaList(String mediaType, Long heritageId, Pageable pageable);

    /**
     * 获取多媒体资源详情
     */
    HeritageMedia getMediaDetail(Long mediaId);

    /**
     * 根据媒体类型获取多媒体列表
     */
    Page<HeritageMedia> getMediaByType(String mediaType, Pageable pageable);
}
