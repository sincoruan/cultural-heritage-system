package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.User;
import com.heritage.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 管理员用户管理控制器
 */
@RestController
@RequestMapping("/admin/user")
@CrossOrigin(origins = "*")
public class AdminUserController {

    @Autowired
    private UserService userService;

    /**
     * 获取用户列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<User>> getUserList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String userType) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            // 简化查询，直接使用findAllUsers
            Page<User> userPage = userService.findAllUsers(pageable);
            return Result.success(userPage);
        } catch (Exception e) {
            return Result.error("获取用户列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户详情
     */
    @GetMapping("/{id}")
    public Result<User> getUserDetail(@PathVariable Long id) {
        try {
            User user = userService.findById(id);
            if (user == null) {
                return Result.error("用户不存在");
            }
            return Result.success(user);
        } catch (Exception e) {
            return Result.error("获取用户详情失败: " + e.getMessage());
        }
    }

    /**
     * 创建用户
     */
    @PostMapping
    public Result<String> createUser(@Valid @RequestBody User user) {
        try {
            userService.createUser(user);
            return Result.success("创建用户成功");
        } catch (Exception e) {
            return Result.error("创建用户失败: " + e.getMessage());
        }
    }

    /**
     * 更新用户
     */
    @PutMapping
    public Result<String> updateUser(@Valid @RequestBody User user) {
        try {
            userService.updateUser(user);
            return Result.success("更新用户成功");
        } catch (Exception e) {
            return Result.error("更新用户失败: " + e.getMessage());
        }
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return Result.success("删除用户成功");
        } catch (Exception e) {
            return Result.error("删除用户失败: " + e.getMessage());
        }
    }

    /**
     * 重置用户密码
     */
    @PostMapping("/{id}/reset-password")
    public Result<String> resetUserPassword(@PathVariable Long id) {
        try {
            userService.resetUserPassword(id);
            return Result.success("重置密码成功");
        } catch (Exception e) {
            return Result.error("重置密码失败: " + e.getMessage());
        }
    }

    /**
     * 切换用户状态
     */
    @PostMapping("/{id}/toggle-status")
    public Result<String> toggleUserStatus(@PathVariable Long id) {
        try {
            userService.toggleUserStatus(id);
            return Result.success("操作成功");
        } catch (Exception e) {
            return Result.error("操作失败: " + e.getMessage());
        }
    }
}