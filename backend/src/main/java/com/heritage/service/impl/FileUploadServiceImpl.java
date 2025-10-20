package com.heritage.service.impl;

import com.heritage.service.FileUploadService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 文件上传Service实现
 */
@Service
public class FileUploadServiceImpl implements FileUploadService {

    @Value("${file.upload.path:/app/uploads}")
    private String uploadPath;

    @Value("${file.upload.url-prefix:/uploads}")
    private String urlPrefix;

    @Override
    public String uploadImage(MultipartFile file) {
        return uploadFile(file, "images");
    }

    @Override
    public String uploadVideo(MultipartFile file) {
        return uploadFile(file, "videos");
    }

    @Override
    public String uploadModel(MultipartFile file) {
        return uploadFile(file, "models");
    }

    @Override
    public String uploadPanorama(MultipartFile file) {
        return uploadFile(file, "panoramas");
    }

    private String uploadFile(MultipartFile file, String subPath) {
        try {
            // 创建目录
            String datePath = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy/MM/dd"));
            Path targetPath = Paths.get(uploadPath, subPath, datePath);
            Files.createDirectories(targetPath);

            // 生成唯一文件名
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String fileName = UUID.randomUUID().toString() + extension;

            // 保存文件
            Path filePath = targetPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath);

            // 返回访问URL
            return urlPrefix + "/" + subPath + "/" + datePath + "/" + fileName;
        } catch (IOException e) {
            throw new RuntimeException("文件上传失败: " + e.getMessage());
        }
    }

    @Override
    public void deleteFile(String fileUrl) {
        try {
            // 从URL中提取文件路径
            String relativePath = fileUrl.replace(urlPrefix + "/", "");
            Path filePath = Paths.get(uploadPath, relativePath);
            
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
        } catch (IOException e) {
            throw new RuntimeException("文件删除失败: " + e.getMessage());
        }
    }

    @Override
    public Map<String, Object> getFileInfo(String fileUrl) {
        try {
            // 从URL中提取文件路径
            String relativePath = fileUrl.replace(urlPrefix + "/", "");
            Path filePath = Paths.get(uploadPath, relativePath);
            
            Map<String, Object> fileInfo = new HashMap<>();
            
            if (Files.exists(filePath)) {
                fileInfo.put("exists", true);
                fileInfo.put("size", Files.size(filePath));
                fileInfo.put("lastModified", Files.getLastModifiedTime(filePath).toInstant());
                fileInfo.put("fileName", filePath.getFileName().toString());
            } else {
                fileInfo.put("exists", false);
            }
            
            return fileInfo;
        } catch (IOException e) {
            throw new RuntimeException("获取文件信息失败: " + e.getMessage());
        }
    }
}
