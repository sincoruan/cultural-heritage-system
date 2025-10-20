package com.heritage.entity;

import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 搜索日志实体类
 */
@Data
@Entity
@Table(name = "sys_search_log")
@EntityListeners(AuditingEntityListener.class)
public class SearchLog implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "log_id")
    private Long logId;

    @Column(name = "log_name", length = 100)
    private String logName;

    @Column(name = "search_keyword", length = 200)
    private String searchKeyword;

    @Column(name = "search_type", length = 50)
    private String searchType;

    @Column(name = "user_id")
    private Long userId;

    @CreatedDate
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

}

