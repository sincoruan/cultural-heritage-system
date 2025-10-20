package com.heritage.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 文化遗产信息实体类
 */
@Data
@Entity
@Table(name = "heritage_info")
@EntityListeners(AuditingEntityListener.class)
public class HeritageInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "heritage_id")
    private Long heritageId;

    @Column(name = "heritage_name", nullable = false, length = 200)
    private String heritageName;

    @Column(name = "category", length = 100)
    private String category;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "era", length = 100)
    private String era;

    @Column(name = "location", length = 200)
    private String location;

    @Column(name = "protection_level", length = 50)
    private String protectionLevel;

    @Column(name = "status", length = 1)
    private String status = "0";

    @Column(name = "view_count")
    private Long viewCount = 0L;

    @Column(name = "like_count")
    private Long likeCount = 0L;

    @Column(name = "collect_count")
    private Long collectCount = 0L;

    @Column(name = "comment_count")
    private Long commentCount = 0L;

    @Column(name = "create_by", length = 64)
    private String createBy;

    @CreatedDate
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @LastModifiedDate
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @OneToMany(mappedBy = "heritageInfo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<HeritageMedia> mediaList = new ArrayList<>();

    @OneToMany(mappedBy = "heritageInfo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<HeritageComment> comments = new ArrayList<>();

}

