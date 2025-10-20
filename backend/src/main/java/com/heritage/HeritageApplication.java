package com.heritage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * 文化遗产管理与展示系统 - 启动类
 * 
 * @author Heritage Team
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
public class HeritageApplication {

    public static void main(String[] args) {
        SpringApplication.run(HeritageApplication.class, args);
        System.out.println("\n========================================");
        System.out.println("  文化遗产管理与展示系统启动成功！");
        System.out.println("  API接口地址: http://localhost:8080/api");
        System.out.println("  接口文档地址: http://localhost:8080/api/doc.html");
        System.out.println("========================================\n");
    }

}

