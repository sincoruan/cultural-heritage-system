package com.heritage.service.impl;

import com.heritage.dto.LoginRequest;
import com.heritage.dto.LoginResponse;
import com.heritage.dto.RegisterRequest;
import com.heritage.entity.User;
import com.heritage.repository.UserRepository;
import com.heritage.service.UserService;
import com.heritage.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    public LoginResponse login(LoginRequest request) {
        // 查找用户
        Optional<User> userOpt = userRepository.findByUserName(request.getUserName());
        if (!userOpt.isPresent()) {
            throw new RuntimeException("用户名或密码错误");
        }

        User user = userOpt.get();
        
        // 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 生成JWT token
        String token = jwtUtil.generateToken(user.getUserName());

        // 构建响应
        LoginResponse response = new LoginResponse();
        response.setToken(token);
        
        // 设置用户信息
        LoginResponse.UserInfo userInfo = new LoginResponse.UserInfo();
        userInfo.setUserId(user.getUserId());
        userInfo.setUserName(user.getUserName());
        userInfo.setNickName(user.getNickName());
        userInfo.setEmail(user.getEmail());
        userInfo.setPhoneNumber(user.getPhoneNumber());
        userInfo.setAvatar(user.getAvatar());
        userInfo.setRoles(new String[]{user.getUserType()});
        
        response.setUserInfo(userInfo);

        return response;
    }

    @Override
    public void register(RegisterRequest request) {
        // 验证密码确认
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("两次输入的密码不一致");
        }

        // 检查用户名是否已存在
        if (userRepository.findByUserName(request.getUserName()).isPresent()) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在（如果提供了邮箱）
        if (request.getEmail() != null && !request.getEmail().trim().isEmpty()) {
            if (userRepository.findByEmail(request.getEmail()).isPresent()) {
                throw new RuntimeException("邮箱已存在");
            }
        }

        // 检查手机号是否已存在（如果提供了手机号）
        if (request.getPhoneNumber() != null && !request.getPhoneNumber().trim().isEmpty()) {
            if (userRepository.findByPhoneNumber(request.getPhoneNumber()).isPresent()) {
                throw new RuntimeException("手机号已存在");
            }
        }

        // 创建新用户
        User user = new User();
        user.setUserName(request.getUserName());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setNickName(request.getNickName());
        user.setEmail(request.getEmail());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setUserType("02"); // 默认为普通用户
        user.setStatus("0"); // 0=正常，1=停用
        user.setDelFlag("0"); // 0=正常，1=删除
        user.setSex("0"); // 0=男，1=女，2=未知
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        userRepository.save(user);
    }

    @Override
    public User findByUserName(String userName) {
        return userRepository.findByUserName(userName).orElse(null);
    }

    @Override
    public User findById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }

    @Override
    public User updateUser(User user) {
        user.setUpdateTime(LocalDateTime.now());
        return userRepository.save(user);
    }

    @Override
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }

    @Override
    public Page<User> findAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("用户不存在"));
        
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("原密码错误");
        }
        
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public void resetPassword(Long userId, String newPassword) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("用户不存在"));
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteUsers(java.util.List<Long> ids) {
        userRepository.deleteAllById(ids);
    }

    @Override
    public org.springframework.data.domain.Page<User> findUsersWithFilters(String keyword, String userType, org.springframework.data.domain.Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty() && userType != null && !userType.trim().isEmpty()) {
            return userRepository.findByUserNameContainingAndUserType(keyword, userType, pageable);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            return userRepository.findByUserNameContaining(keyword, pageable);
        } else if (userType != null && !userType.trim().isEmpty()) {
            return userRepository.findByUserType(userType, pageable);
        } else {
            return userRepository.findAll(pageable);
        }
    }

    @Override
    public void updateUserStatus(Long id, String status) {
        User user = userRepository.findById(id).orElse(null);
        if (user != null) {
            user.setStatus(status);
            user.setUpdateTime(LocalDateTime.now());
            userRepository.save(user);
        }
    }

    @Override
    public Object getUserStats() {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalCount", userRepository.count());
        stats.put("adminCount", userRepository.countByUserType("00"));
        stats.put("managerCount", userRepository.countByUserType("01"));
        stats.put("userCount", userRepository.countByUserType("02"));
        return stats;
    }

    @Override
    public java.util.List<String> getUserRoles() {
        return java.util.Arrays.asList("系统管理员", "平台管理员", "普通用户");
    }

    @Override
    public void createUser(User user) {
        // 检查用户名是否已存在
        if (userRepository.existsByUserName(user.getUserName())) {
            throw new RuntimeException("用户名已存在");
        }
        
        // 检查邮箱是否已存在
        if (user.getEmail() != null && userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("邮箱已存在");
        }
        
        // 检查手机号是否已存在
        if (user.getPhoneNumber() != null && userRepository.existsByPhoneNumber(user.getPhoneNumber())) {
            throw new RuntimeException("手机号已存在");
        }
        
        // 设置默认值
        user.setPassword(passwordEncoder.encode("123456")); // 默认密码
        user.setStatus("ACTIVE");
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        
        userRepository.save(user);
    }

    @Override
    public void resetUserPassword(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("用户不存在"));
        user.setPassword(passwordEncoder.encode("123456")); // 重置为默认密码
        user.setUpdateTime(LocalDateTime.now());
        userRepository.save(user);
    }

    @Override
    public void toggleUserStatus(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("用户不存在"));
        if ("ACTIVE".equals(user.getStatus())) {
            user.setStatus("INACTIVE");
        } else {
            user.setStatus("ACTIVE");
        }
        user.setUpdateTime(LocalDateTime.now());
        userRepository.save(user);
    }
}
