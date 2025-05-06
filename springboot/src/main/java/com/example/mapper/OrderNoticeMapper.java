package com.example.mapper;

import com.example.entity.OrderNotice;
import com.example.entity.Orders;

import java.util.List;

public interface OrderNoticeMapper {
    /**
     * 新增
     */
    int insert(OrderNotice orderNotice);

    /**
     * 逻辑删除
     */
    int logicDeleteById(Integer id);

    List<Orders> getAll(Integer id);


}
