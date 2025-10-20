package com.heritage.service.impl;

import com.heritage.entity.HeritageMedia;
import com.heritage.repository.HeritageMediaRepository;
import com.heritage.service.MediaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 多媒体Service实现
 */
@Service
public class MediaServiceImpl implements MediaService {

    @Autowired
    private HeritageMediaRepository heritageMediaRepository;

    @Override
    public List<HeritageMedia> getHeritageMedia(Long heritageId) {
        return heritageMediaRepository.findByHeritageIdOrderBySortOrderAsc(heritageId);
    }

    @Override
    public HeritageMedia addMedia(HeritageMedia media) {
        return heritageMediaRepository.save(media);
    }

    @Override
    public HeritageMedia updateMedia(HeritageMedia media) {
        return heritageMediaRepository.save(media);
    }

    @Override
    public void deleteMedia(Long mediaId) {
        heritageMediaRepository.deleteById(mediaId);
    }

    @Override
    public void batchDeleteMedia(List<Long> ids) {
        heritageMediaRepository.deleteAllById(ids);
    }

    @Override
    public void updateMediaSort(Long mediaId, Integer sortOrder) {
        HeritageMedia media = heritageMediaRepository.findById(mediaId).orElse(null);
        if (media != null) {
            media.setSortOrder(sortOrder);
            heritageMediaRepository.save(media);
        }
    }

    @Override
    public Map<String, Object> getMediaStats(Long heritageId) {
        Map<String, Object> stats = new HashMap<>();
        
        List<HeritageMedia> mediaList = heritageMediaRepository.findByHeritageIdOrderBySortOrderAsc(heritageId);
        stats.put("totalCount", mediaList.size());
        
        long imageCount = mediaList.stream().filter(m -> "image".equals(m.getMediaType())).count();
        long videoCount = mediaList.stream().filter(m -> "video".equals(m.getMediaType())).count();
        long modelCount = mediaList.stream().filter(m -> "model".equals(m.getMediaType())).count();
        long panoramaCount = mediaList.stream().filter(m -> "panorama".equals(m.getMediaType())).count();
        
        stats.put("imageCount", imageCount);
        stats.put("videoCount", videoCount);
        stats.put("modelCount", modelCount);
        stats.put("panoramaCount", panoramaCount);
        
        return stats;
    }

    @Override
    public Page<HeritageMedia> getMediaList(String mediaType, Long heritageId, Pageable pageable) {
        if (mediaType != null && !mediaType.trim().isEmpty() && heritageId != null) {
            return heritageMediaRepository.findByMediaTypeAndHeritageId(mediaType, heritageId, pageable);
        } else if (mediaType != null && !mediaType.trim().isEmpty()) {
            return heritageMediaRepository.findByMediaType(mediaType, pageable);
        } else if (heritageId != null) {
            return heritageMediaRepository.findByHeritageId(heritageId, pageable);
        } else {
            return heritageMediaRepository.findAll(pageable);
        }
    }

    @Override
    public HeritageMedia getMediaDetail(Long mediaId) {
        return heritageMediaRepository.findById(mediaId).orElse(null);
    }

    @Override
    public Page<HeritageMedia> getMediaByType(String mediaType, Pageable pageable) {
        return heritageMediaRepository.findByMediaType(mediaType, pageable);
    }
}
