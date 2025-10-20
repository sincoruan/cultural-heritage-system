package com.heritage.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * 角色实体类
 */
@Data
@Entity
@Table(name = "sys_role")
@EntityListeners(AuditingEntityListener.class)
public class Role implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "role_id")
    private Long roleId;

    @Column(name = "role_name", nullable = false, length = 30)
    private String roleName;

    @Column(name = "role_key", nullable = false, length = 100)
    private String roleKey;

    @Column(name = "role_sort", nullable = false)
    private Integer roleSort;

    @Column(name = "data_scope", length = 1)
    private String dataScope = "1";

    @Column(name = "menu_check_strictly")
    private Boolean menuCheckStrictly = true;

    @Column(name = "dept_check_strictly")
    private Boolean deptCheckStrictly = true;

    @Column(name = "status", nullable = false, length = 1)
    private String status = "0";

    @Column(name = "del_flag", length = 1)
    private String delFlag = "0";

    @Column(name = "create_by", length = 64)
    private String createBy;

    @CreatedDate
    @Column(name = "create_time", updatable = false)
    private LocalDateTime createTime;

    @Column(name = "update_by", length = 64)
    private String updateBy;

    @LastModifiedDate
    @Column(name = "update_time")
    private LocalDateTime updateTime;

    @Column(name = "remark", length = 500)
    private String remark;

    // 暂时注释掉用户关系，避免Hibernate映射问题
    // @JsonIgnore
    // @ManyToMany(mappedBy = "roles")
    // private Set<User> users = new HashSet<>();

}

