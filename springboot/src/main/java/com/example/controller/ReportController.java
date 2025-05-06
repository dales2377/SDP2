package com.example.controller;

import com.example.common.Result;
import com.example.entity.CountVO;
import com.example.entity.GoodsOrderVO;
import com.example.mapper.OrdersMapper;
import com.example.service.OrdersItemService;
import com.example.service.OrdersService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/report")
public class ReportController {

    @Resource
    private OrdersService ordersService;
    @Resource
    private OrdersItemService ordersItemService;

    /**
     * 订单量统计
     */
    @PostMapping("/generateOrderNum")
    public Result generateOrderNum(@RequestBody CountVO req) {
        Integer result = ordersService.generateOrderNum(req);
        return Result.success(result);
    }

    /**
     * 收入统计
     */
    @PostMapping("/income")
    public Result income(@RequestBody CountVO req) {
        Double result = ordersService.income(req);
        return Result.success(result);
    }


    /**
     * 热门产品
     */
    @PostMapping("/hotGoods")
    public Result hotGoods(@RequestBody CountVO req) {
        //todo 热门产品
        List<GoodsOrderVO> res = ordersItemService.hotGoods(req);
        return Result.success(res);
    }

}
