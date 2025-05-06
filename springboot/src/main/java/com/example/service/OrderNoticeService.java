package com.example.service;

import com.example.entity.Account;
import com.example.entity.OrderNotice;
import com.example.entity.Orders;
import com.example.mapper.OrderNoticeMapper;
import com.example.utils.TokenUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class OrderNoticeService {
    @Resource
    private OrderNoticeMapper orderNoticeMapper;


    public void add(OrderNotice orderNotice) {
        orderNoticeMapper.insert(orderNotice);
    }

    public void logicDeleteById(Integer id) {
        orderNoticeMapper.logicDeleteById(id);
    }


    public List<Orders> getAll() {
        Account currentUser = TokenUtils.getCurrentUser();
        List<Orders> orders = orderNoticeMapper.getAll(currentUser.getId());
        return orders;
    }
}
