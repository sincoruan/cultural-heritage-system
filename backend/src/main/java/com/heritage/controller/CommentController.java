package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.HeritageComment;
import com.heritage.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 评论业务管理控制器
 */
@RestController
@RequestMapping("/api/comment")
@CrossOrigin(origins = "*")
public class CommentController {

    @Autowired
    private CommentService commentService;

    /**
     * 获取文化遗产评论列表
     */
    @GetMapping("/heritage/{heritageId}")
    public Result<Page<HeritageComment>> getHeritageComments(
            @PathVariable Long heritageId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<HeritageComment> comments = commentService.getHeritageComments(heritageId, pageable);
            return Result.success(comments);
        } catch (Exception e) {
            return Result.error("获取评论列表失败: " + e.getMessage());
        }
    }

    /**
     * 添加评论
     */
    @PostMapping("/add")
    public Result<HeritageComment> addComment(@Valid @RequestBody HeritageComment comment) {
        try {
            HeritageComment savedComment = commentService.addComment(comment);
            return Result.success(savedComment);
        } catch (Exception e) {
            return Result.error("添加评论失败: " + e.getMessage());
        }
    }

    /**
     * 删除评论
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteComment(@PathVariable Long id) {
        try {
            commentService.deleteComment(id);
            return Result.success("删除评论成功");
        } catch (Exception e) {
            return Result.error("删除评论失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户评论列表
     */
    @GetMapping("/user/{userId}")
    public Result<Page<HeritageComment>> getUserComments(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<HeritageComment> comments = commentService.getUserComments(userId, pageable);
            return Result.success(comments);
        } catch (Exception e) {
            return Result.error("获取用户评论失败: " + e.getMessage());
        }
    }

    /**
     * 获取评论统计信息
     */
    @GetMapping("/stats/{heritageId}")
    public Result<Object> getCommentStats(@PathVariable Long heritageId) {
        try {
            Object stats = commentService.getCommentStats(heritageId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取评论统计失败: " + e.getMessage());
        }
    }
}
