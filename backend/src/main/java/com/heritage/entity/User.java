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
 * 用户实体类
 */
@Data
@Entity
@Table(name = "sys_user")
@EntityListeners(AuditingEntityListener.class)
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "dept_id")
    private Long deptId;

    @Column(name = "user_name", nullable = false, unique = true, length = 30)
    private String userName;

    @Column(name = "nick_name", nullable = false, length = 30)
    private String nickName;

    @Column(name = "user_type", length = 2)
    private String userType = "00";

    @Column(name = "email", length = 50)
    private String email;

    @Column(name = "phone_number", length = 11)
    private String phoneNumber;

    @Column(name = "sex", length = 1)
    private String sex = "0";

    @Column(name = "avatar", length = 100)
    private String avatar;

    @JsonIgnore
    @Column(name = "password", length = 100)
    private String password;

    @Column(name = "status", length = 1)
    private String status = "0";

    @Column(name = "del_flag", length = 1)
    private String delFlag = "0";

    @Column(name = "login_ip", length = 128)
    private String loginIp;

    @Column(name = "login_date")
    private LocalDateTime loginDate;

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

    // 暂时注释掉角色关系，避免Hibernate懒加载问题
    // @ManyToMany(fetch = FetchType.LAZY)
    // @JoinTable(
    //     name = "sys_user_role",
    //     joinColumns = @JoinColumn(name = "user_id"),
    //     inverseJoinColumns = @JoinColumn(name = "role_id")
    // )
    // private Set<Role> roles = new HashSet<>();

    /**
     * 是否为管理员
     */
    public boolean isAdmin() {
        // 暂时基于userType判断，后续可以恢复角色关系
        return "00".equals(userType) || "01".equals(userType);
    }

    /**
     * 是否为系统管理员
     */
    public boolean isSuperAdmin() {
        // 暂时基于userType判断，后续可以恢复角色关系
        return "00".equals(userType);
    }

}

