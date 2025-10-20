package com.heritage.repository;

import com.heritage.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 用户Repository
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {

    /**
     * 根据用户名查询用户
     */
    Optional<User> findByUserName(String userName);

    /**
     * 根据邮箱查询用户
     */
    Optional<User> findByEmail(String email);

    /**
     * 根据手机号查询用户
     */
    Optional<User> findByPhoneNumber(String phoneNumber);

    /**
     * 检查用户名是否存在
     */
    boolean existsByUserName(String userName);

    /**
     * 检查邮箱是否存在
     */
    boolean existsByEmail(String email);

    /**
     * 检查手机号是否存在
     */
    boolean existsByPhoneNumber(String phoneNumber);

    /**
     * 根据用户名模糊查询
     */
    Page<User> findByUserNameContaining(String userName, Pageable pageable);

    /**
     * 根据用户类型查询
     */
    Page<User> findByUserType(String userType, Pageable pageable);

    /**
     * 根据用户名和用户类型查询
     */
    Page<User> findByUserNameContainingAndUserType(String userName, String userType, Pageable pageable);

    /**
     * 根据状态统计数量
     */
    long countByStatus(String status);

    /**
     * 根据用户类型统计数量
     */
    long countByUserType(String userType);

}

