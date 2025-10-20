package com.heritage.dto;

import lombok.Data;

import java.io.Serializable;

/**
 * 登录响应DTO
 */
@Data
public class LoginResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * JWT Token
     */
    private String token;

    /**
     * Token类型
     */
    private String tokenType = "Bearer";

    /**
     * 用户信息
     */
    private UserInfo userInfo;

    @Data
    public static class UserInfo implements Serializable {
        private Long userId;
        private String userName;
        private String nickName;
        private String email;
        private String phoneNumber;
        private String avatar;
        private String[] roles;
    }

}

