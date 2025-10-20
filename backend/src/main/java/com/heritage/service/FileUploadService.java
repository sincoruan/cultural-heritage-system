package com.heritage.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 文件上传Service接口
 */
public interface FileUploadService {

    /**
     * 上传图片
     */
    String uploadImage(MultipartFile file);

    /**
     * 上传视频
     */
    String uploadVideo(MultipartFile file);

    /**
     * 上传3D模型
     */
    String uploadModel(MultipartFile file);

    /**
     * 上传全景图片
     */
    String uploadPanorama(MultipartFile file);

    /**
     * 删除文件
     */
    void deleteFile(String fileUrl);

    /**
     * 获取文件信息
     */
    Map<String, Object> getFileInfo(String fileUrl);
}
