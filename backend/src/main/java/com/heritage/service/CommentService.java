package com.heritage.service;

import com.heritage.entity.HeritageComment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/**
 * 评论Service接口
 */
public interface CommentService {

    /**
     * 获取文化遗产评论列表
     */
    Page<HeritageComment> getHeritageComments(Long heritageId, Pageable pageable);

    /**
     * 添加评论
     */
    HeritageComment addComment(HeritageComment comment);

    /**
     * 删除评论
     */
    void deleteComment(Long commentId);

    /**
     * 获取用户评论列表
     */
    Page<HeritageComment> getUserComments(Long userId, Pageable pageable);

    /**
     * 获取评论统计信息
     */
    Object getCommentStats(Long heritageId);
}
