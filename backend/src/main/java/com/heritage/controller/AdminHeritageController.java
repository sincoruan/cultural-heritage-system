package com.heritage.controller;

import com.heritage.dto.Result;
import com.heritage.entity.CulturalHeritage;
import com.heritage.service.CulturalHeritageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * 管理员文化遗产管理控制器
 */
@RestController
@RequestMapping("/admin/heritage")
@CrossOrigin(origins = "*")
public class AdminHeritageController {

    @Autowired
    private CulturalHeritageService culturalHeritageService;

    /**
     * 获取文化遗产列表（分页）
     */
    @GetMapping("/list")
    public Result<Page<CulturalHeritage>> getHeritageList(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String category) {
        try {
            Pageable pageable = Pageable.ofSize(size).withPage(page);
            Page<CulturalHeritage> heritagePage = culturalHeritageService.findHeritageWithFilters(keyword, category, pageable);
            return Result.success(heritagePage);
        } catch (Exception e) {
            return Result.error("获取文化遗产列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产详情
     */
    @GetMapping("/{id}")
    public Result<CulturalHeritage> getHeritageDetail(@PathVariable Long id) {
        try {
            CulturalHeritage heritage = culturalHeritageService.findById(id);
            if (heritage == null) {
                return Result.error("文化遗产不存在");
            }
            return Result.success(heritage);
        } catch (Exception e) {
            return Result.error("获取文化遗产详情失败: " + e.getMessage());
        }
    }

    /**
     * 创建文化遗产
     */
    @PostMapping("/create")
    public Result<CulturalHeritage> createHeritage(@Valid @RequestBody CulturalHeritage heritage) {
        try {
            CulturalHeritage savedHeritage = culturalHeritageService.save(heritage);
            return Result.success(savedHeritage);
        } catch (Exception e) {
            return Result.error("创建文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 更新文化遗产
     */
    @PutMapping("/{id}")
    public Result<CulturalHeritage> updateHeritage(@PathVariable Long id, @Valid @RequestBody CulturalHeritage heritage) {
        try {
            heritage.setHeritageId(id);
            CulturalHeritage updatedHeritage = culturalHeritageService.save(heritage);
            return Result.success(updatedHeritage);
        } catch (Exception e) {
            return Result.error("更新文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 删除文化遗产
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteHeritage(@PathVariable Long id) {
        try {
            culturalHeritageService.deleteById(id);
            return Result.success("删除成功");
        } catch (Exception e) {
            return Result.error("删除文化遗产失败: " + e.getMessage());
        }
    }

    /**
     * 批量删除文化遗产
     */
    @DeleteMapping("/batch")
    public Result<String> batchDeleteHeritage(@RequestBody List<Long> ids) {
        try {
            culturalHeritageService.deleteByIds(ids);
            return Result.success("批量删除成功");
        } catch (Exception e) {
            return Result.error("批量删除失败: " + e.getMessage());
        }
    }

    /**
     * 更新文化遗产状态
     */
    @PutMapping("/{id}/status")
    public Result<String> updateHeritageStatus(@PathVariable Long id, @RequestParam String status) {
        try {
            culturalHeritageService.updateStatus(id, status);
            return Result.success("状态更新成功");
        } catch (Exception e) {
            return Result.error("状态更新失败: " + e.getMessage());
        }
    }

    /**
     * 获取文化遗产统计信息
     */
    @GetMapping("/stats")
    public Result<Object> getHeritageStats() {
        try {
            Object stats = culturalHeritageService.getHeritageStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取统计信息失败: " + e.getMessage());
        }
    }
}
