package com.example.mapper;

import com.example.entity.Business;

import java.util.List;

// business data access
public interface BusinessMapper {
    List<Business> selectAll(Business business);

    int insert(Business business);// transfer PK

    int updateById(Business business);

    int deleteById(Integer id);
}
