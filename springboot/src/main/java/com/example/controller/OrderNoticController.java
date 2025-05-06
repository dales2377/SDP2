package com.example.controller;


import com.example.common.Result;
import com.example.entity.Account;
import com.example.entity.OrderNotice;
import com.example.entity.Orders;
import com.example.service.OrderNoticeService;
import com.example.utils.TokenUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("orderNotic")
public class OrderNoticController {
    @Resource
    private OrderNoticeService orderNoticeService;
    /**
     * 插入
     */
    @PostMapping("add")
    public Result add(@RequestBody OrderNotice orderNotice) {
        orderNoticeService.add(orderNotice);
        return Result.success("添加成功");
    }

    /**
     * 逻辑删除
     */
    @PostMapping("/logicDel")
    public Result logicDel(@RequestBody OrderNotice orderNotice) {
        orderNoticeService.logicDeleteById(orderNotice.getId());
        return Result.success("删除成功");
    }

    /**
     * 查询所有通知
     */
    @GetMapping("getAll")
    public Result getAll() {
        List<Orders>  orders = orderNoticeService.getAll();
        return Result.success(orders);
    }
}
