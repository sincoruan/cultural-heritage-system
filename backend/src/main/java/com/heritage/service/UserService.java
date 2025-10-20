package com.heritage.service;

import com.heritage.dto.LoginRequest;
import com.heritage.dto.LoginResponse;
import com.heritage.dto.RegisterRequest;
import com.heritage.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * 用户Service接口
 */
public interface UserService {

    /**
     * 用户注册
     */
    void register(RegisterRequest request);

    /**
     * 用户登录
     */
    LoginResponse login(LoginRequest request);

    /**
     * 根据用户名查询用户
     */
    User findByUserName(String userName);

    /**
     * 根据ID查询用户
     */
    User findById(Long userId);

    /**
     * 更新用户信息
     */
    User updateUser(User user);

    /**
     * 删除用户
     */
    void deleteUser(Long userId);

    /**
     * 分页查询用户列表
     */
    Page<User> findAllUsers(Pageable pageable);

    /**
     * 修改密码
     */
    void changePassword(Long userId, String oldPassword, String newPassword);

    /**
     * 重置密码
     */
    void resetPassword(Long userId, String newPassword);

    /**
     * 保存用户
     */
    User save(User user);

    /**
     * 批量删除用户
     */
    void deleteUsers(java.util.List<Long> ids);

    /**
     * 根据条件查询用户
     */
    org.springframework.data.domain.Page<User> findUsersWithFilters(String keyword, String userType, org.springframework.data.domain.Pageable pageable);

    /**
     * 更新用户状态
     */
    void updateUserStatus(Long id, String status);

    /**
     * 获取用户统计信息
     */
    Object getUserStats();

    /**
     * 获取用户角色列表
     */
    java.util.List<String> getUserRoles();

    /**
     * 创建用户
     */
    void createUser(User user);

    /**
     * 重置用户密码
     */
    void resetUserPassword(Long userId);

    /**
     * 切换用户状态
     */
    void toggleUserStatus(Long userId);

}

