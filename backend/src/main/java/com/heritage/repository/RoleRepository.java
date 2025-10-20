package com.heritage.repository;

import com.heritage.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * 角色Repository
 */
@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {

    /**
     * 根据角色key查询角色
     */
    Optional<Role> findByRoleKey(String roleKey);

    /**
     * 检查角色key是否存在
     */
    boolean existsByRoleKey(String roleKey);

}

