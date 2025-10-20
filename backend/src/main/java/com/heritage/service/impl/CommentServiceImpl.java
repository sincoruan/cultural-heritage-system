package com.heritage.service.impl;

import com.heritage.entity.HeritageComment;
import com.heritage.repository.HeritageCommentRepository;
import com.heritage.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.HashMap;

/**
 * 评论Service实现
 */
@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private HeritageCommentRepository heritageCommentRepository;

    @Override
    public Page<HeritageComment> getHeritageComments(Long heritageId, Pageable pageable) {
        return heritageCommentRepository.findByHeritageId(heritageId, pageable);
    }

    @Override
    public HeritageComment addComment(HeritageComment comment) {
        return heritageCommentRepository.save(comment);
    }

    @Override
    public void deleteComment(Long commentId) {
        heritageCommentRepository.deleteById(commentId);
    }

    @Override
    public Page<HeritageComment> getUserComments(Long userId, Pageable pageable) {
        return heritageCommentRepository.findByUserId(userId, pageable);
    }

    @Override
    public Object getCommentStats(Long heritageId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalComments", heritageCommentRepository.countByHeritageId(heritageId));
        stats.put("heritageId", heritageId);
        return stats;
    }
}
