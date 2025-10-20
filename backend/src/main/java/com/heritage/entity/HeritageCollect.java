package com.heritage.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 文化遗产收藏实体
 */
@Data
@Entity
@Table(name = "heritage_collect")
@EntityListeners(AuditingEntityListener.class)
public class HeritageCollect implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "collect_id")
    private Long collectId;

    @Column(name = "heritage_id", nullable = false)
    private Long heritageId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "create_time")
    @CreatedDate
    private LocalDateTime createTime;

    @Column(name = "create_by")
    private String createBy;
}