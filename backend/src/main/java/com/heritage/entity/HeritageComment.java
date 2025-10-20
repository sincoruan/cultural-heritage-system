package com.heritage.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 文化遗产评论实体
 */
@Data
@Entity
@Table(name = "heritage_comment")
@EntityListeners(AuditingEntityListener.class)
public class HeritageComment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "comment_id")
    private Long commentId;

    @Column(name = "heritage_id", nullable = false)
    private Long heritageId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "comment_content", columnDefinition = "TEXT", nullable = false)
    private String commentContent;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "like_count")
    private Long likeCount = 0L;

    @Column(name = "reply_count")
    private Long replyCount = 0L;

    @Column(name = "status")
    private String status = "正常";

    @Column(name = "create_time")
    @CreatedDate
    private LocalDateTime createTime;

    @Column(name = "update_time")
    @LastModifiedDate
    private LocalDateTime updateTime;

    @Column(name = "create_by")
    private String createBy;

    @Column(name = "update_by")
    private String updateBy;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "heritage_id", insertable = false, updatable = false)
    private HeritageInfo heritageInfo;
}