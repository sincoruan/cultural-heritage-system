package com.heritage.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 文化遗产实体
 */
@Data
@Entity
@Table(name = "heritage_info")
@EntityListeners(AuditingEntityListener.class)
public class CulturalHeritage implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "heritage_id")
    private Long heritageId;

    @Column(name = "heritage_name", nullable = false)
    private String heritageName;

    @Column(name = "category")
    private String category;

    @Column(name = "era")
    private String era;

    @Column(name = "location")
    private String location;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "protection_level")
    private String protectionLevel;

    @Column(name = "status")
    private String status = "1";

    @Column(name = "view_count")
    private Long viewCount = 0L;

    @Column(name = "like_count")
    private Long likeCount = 0L;

    @Column(name = "collect_count")
    private Long collectCount = 0L;

    @Column(name = "comment_count")
    private Long commentCount = 0L;

    @Column(name = "create_time")
    @CreatedDate
    private LocalDateTime createTime;

    @Column(name = "update_time")
    @LastModifiedDate
    private LocalDateTime updateTime;

    @Column(name = "create_by")
    private String createBy;
}
