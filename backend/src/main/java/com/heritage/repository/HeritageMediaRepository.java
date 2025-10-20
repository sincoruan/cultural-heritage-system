package com.heritage.repository;

import com.heritage.entity.HeritageMedia;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 文化遗产多媒体Repository
 */
@Repository
public interface HeritageMediaRepository extends JpaRepository<HeritageMedia, Long> {

    /**
     * 根据文化遗产ID查询媒体列表
     */
    List<HeritageMedia> findByHeritageIdOrderBySortOrder(Long heritageId);

    /**
     * 根据文化遗产ID查询媒体列表（按排序）
     */
    List<HeritageMedia> findByHeritageIdOrderBySortOrderAsc(Long heritageId);

    /**
     * 根据文化遗产ID查询媒体列表（分页）
     */
    Page<HeritageMedia> findByHeritageId(Long heritageId, Pageable pageable);

    /**
     * 根据文化遗产ID和媒体类型查询媒体列表
     */
    List<HeritageMedia> findByHeritageIdAndMediaTypeOrderBySortOrder(Long heritageId, String mediaType);

    /**
     * 根据媒体类型查询媒体列表（分页）
     */
    Page<HeritageMedia> findByMediaType(String mediaType, Pageable pageable);

    /**
     * 根据媒体类型和文化遗产ID查询媒体列表（分页）
     */
    Page<HeritageMedia> findByMediaTypeAndHeritageId(String mediaType, Long heritageId, Pageable pageable);

    /**
     * 删除文化遗产的所有媒体
     */
    void deleteByHeritageId(Long heritageId);

}

