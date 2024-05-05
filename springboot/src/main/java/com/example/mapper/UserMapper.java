package com.example.mapper;

import com.example.entity.User;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * User
 */
public interface UserMapper {

    /**
     * add
     */
    int insert(User user);

    /**
     * delete
     */
    int deleteById(Integer id);

    /**
     * update
     */
    int updateById(User user);

    /**
     * query by ID
     */
    User selectById(Integer id);

    /**
     * Select all
     */
    List<User> selectAll(User user);

    @Select("select * from user where username = #{username}")
    User selectByUsername(String username);

}