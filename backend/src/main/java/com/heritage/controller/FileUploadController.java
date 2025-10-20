package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.service.FileUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

/**
 * 文件上传控制器
 */
@RestController
@RequestMapping("/upload")
@CrossOrigin(origins = "*")
public class FileUploadController {

    @Autowired
    private FileUploadService fileUploadService;

    /**
     * 上传图片
     */
    @PostMapping("/image")
    public Result<Map<String, Object>> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            // 验证文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.error("只能上传图片文件");
            }
            
            // 验证文件大小 (10MB)
            if (file.getSize() > 10 * 1024 * 1024) {
                return Result.error("图片文件大小不能超过10MB");
            }
            
            String fileUrl = fileUploadService.uploadImage(file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("fileUrl", fileUrl);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("contentType", contentType);
            
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("图片上传失败: " + e.getMessage());
        }
    }

    /**
     * 上传视频
     */
    @PostMapping("/video")
    public Result<Map<String, Object>> uploadVideo(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            // 验证文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("video/")) {
                return Result.error("只能上传视频文件");
            }
            
            // 验证文件大小 (100MB)
            if (file.getSize() > 100 * 1024 * 1024) {
                return Result.error("视频文件大小不能超过100MB");
            }
            
            String fileUrl = fileUploadService.uploadVideo(file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("fileUrl", fileUrl);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("contentType", contentType);
            
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("视频上传失败: " + e.getMessage());
        }
    }

    /**
     * 上传3D模型
     */
    @PostMapping("/model")
    public Result<Map<String, Object>> uploadModel(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            // 验证文件类型 (支持常见3D模型格式)
            String fileName = file.getOriginalFilename();
            if (fileName == null || (!fileName.toLowerCase().endsWith(".obj") && 
                !fileName.toLowerCase().endsWith(".fbx") && 
                !fileName.toLowerCase().endsWith(".gltf") && 
                !fileName.toLowerCase().endsWith(".glb"))) {
                return Result.error("只支持 .obj, .fbx, .gltf, .glb 格式的3D模型文件");
            }
            
            // 验证文件大小 (50MB)
            if (file.getSize() > 50 * 1024 * 1024) {
                return Result.error("3D模型文件大小不能超过50MB");
            }
            
            String fileUrl = fileUploadService.uploadModel(file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("fileUrl", fileUrl);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("contentType", file.getContentType());
            
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("3D模型上传失败: " + e.getMessage());
        }
    }

    /**
     * 上传全景图片
     */
    @PostMapping("/panorama")
    public Result<Map<String, Object>> uploadPanorama(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            // 验证文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.error("只能上传图片文件");
            }
            
            // 验证文件大小 (20MB)
            if (file.getSize() > 20 * 1024 * 1024) {
                return Result.error("全景图片文件大小不能超过20MB");
            }
            
            String fileUrl = fileUploadService.uploadPanorama(file);
            
            Map<String, Object> result = new HashMap<>();
            result.put("fileUrl", fileUrl);
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
            result.put("contentType", contentType);
            
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("全景图片上传失败: " + e.getMessage());
        }
    }

    /**
     * 删除文件
     */
    @DeleteMapping("/delete")
    public Result<String> deleteFile(@RequestParam String fileUrl) {
        try {
            fileUploadService.deleteFile(fileUrl);
            return Result.success("文件删除成功");
        } catch (Exception e) {
            return Result.error("文件删除失败: " + e.getMessage());
        }
    }

    /**
     * 获取文件信息
     */
    @GetMapping("/info")
    public Result<Map<String, Object>> getFileInfo(@RequestParam String fileUrl) {
        try {
            Map<String, Object> fileInfo = fileUploadService.getFileInfo(fileUrl);
            return Result.success(fileInfo);
        } catch (Exception e) {
            return Result.error("获取文件信息失败: " + e.getMessage());
        }
    }
}
